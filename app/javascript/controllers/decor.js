export function replaceContentsWithChildren(parent, children) {
    // Remove the existing children
    emptyNode(parent);

    const childrenArray = Array.isArray(children) ? children : [children];

    // Create a document fragment to contain all the child nodes
    const fragment = document.createDocumentFragment();
    childrenArray.forEach((child) => {
        fragment.appendChild(child);
    });

    // Append all at once (only one DOM touch here)
    parent.appendChild(fragment);

    return parent;
}

function emptyNode(node) {
    // https://jsperf.com/innerhtml-vs-removechild/37
    while (node.firstChild) {
        node.removeChild(node.firstChild);
    }
}

/**
 * Explicitly marks HTML content as 'safe'.
 * This attempts to mitigate the possibility of XSS by creating an extra hoop for the developer to jump through when using `innerHTML`.
 *
 * @param {string} html HTML content to mark as safe
 * @returns {Object} Safe HTML content object
 */
export function markAsSafeHTML(html) {
    return {
        __safe: true,
        content: html,
    };
}

/**
 * Proxies to the element's `innerHTML` method, ensuring that the content that is being set has previously been marked as 'safe'.
 *
 * @param {Element} el element to set innerHTML
 * @param {Object} safe safe content to set as innerHTML
 * @param {boolean} safe.__safe flag indicating content is safe
 * @param {string} safe.content the HTML content to set
 */
export function safelySetInnerHTML(el, { __safe, content }) {
    // It's temping to modify the Element's prototype here with a new `safelySetInnerHTML` method, but...
    // http://perfectionkills.com/whats-wrong-with-extending-the-dom/
    if (!__safe) {
        throw new Error(
            "This content could not be displayed as it has not been marked as safe. Content must be explicitly marked as safe to try and reduce the likelihood of a XSS attack.",
        );
    }
    el.innerHTML = content;
}

/**
 * Creates an axios instance configured with CSRF token for Rails applications.
 * 
 * @returns {Object} Configured axios instance
 */
export function createAxiosInstance() {
    // Import axios dynamically to avoid issues if it's not available
    const axios = require('axios');
    
    const csrfMetaTag = document.head.querySelector('[name="csrf-token"]');
    const csrfToken = (csrfMetaTag && csrfMetaTag.getAttribute("content")) || "";

    return axios.create({
        headers: {
            "X-CSRF-TOKEN": csrfToken,
        },
    });
}
