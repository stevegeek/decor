/**
 * Decor JavaScript Utilities
 * 
 * This file contains utility functions for use with Stimulus controllers in the Decor component library.
 * All functions are standalone utilities that can be imported and used independently.
 * 
 * Core Functions:
 * - replaceContentsWithChildren: DOM manipulation utility
 * - markAsSafeHTML, safelySetInnerHTML: XSS-safe HTML handling
 * - createHTTPClient: Modern fetch-based HTTP client
 * 
 * Animation & CSS Utilities:
 * - toggleTargetElementTransitionClasses: Complex transition animations
 * - toggleTargetElementClasses: Simple class toggling
 * - setTargetElementClasses: Add/remove CSS classes
 * 
 * Additional Utilities:
 * - toggleOnSearch: Search functionality with class toggling
 * - emitEvent: Custom event emission with namespacing
 */

import { createHTTPClient, getHTML, getJSON } from "controllers/decor/http";

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

// Re-export HTTP utilities for convenience
export { createHTTPClient, getHTML, getJSON } from "controllers/decor/http";

/**
 * Toggles CSS classes on an element based on state
 * @param {Element} target - DOM element to modify
 * @param {boolean} state - true to apply "on" classes, false for "off" classes
 * @param {Array} classesOff - classes to use when state is false
 * @param {Array} classesOn - classes to use when state is true
 */
export function toggleTargetElementClasses(target, state, classesOff, classesOn) {
    if (state) {
        setTargetElementClasses(target, classesOff, classesOn);
    } else {
        setTargetElementClasses(target, classesOn, classesOff);
    }
}
/**
 * Adds and removes CSS classes on an element
 * @param {Element} target - DOM element to modify
 * @param {Array} classesToRemove - classes to remove
 * @param {Array} classesToAdd - classes to add
 */
export function setTargetElementClasses(target, classesToRemove, classesToAdd) {
    classesToRemove.forEach((className) => target.classList.remove(className));
    classesToAdd.forEach((className) => target.classList.add(className));
}
/**
 * Handles search functionality with class toggling based on matches
 * @param {string} search - search term
 * @param {Element} target - element to apply classes to
 * @param {Array} searchTargets - elements to search within
 * @param {Array} classesOnMatch - classes to apply when matches found
 * @param {Array} classesOnNoMatch - classes to apply when no matches found
 * @returns {boolean} true if matches found or search is too short
 */
export function toggleOnSearch(search, target, searchTargets, classesOnMatch, classesOnNoMatch) {
    const st = search.trim().toLowerCase();
    if (st.length < 2 || st == "") {
        setTargetElementClasses(target, classesOnNoMatch, classesOnMatch);
        return true;
    }
    const matches = searchTargets.filter((searchTarget) => searchTarget.innerText.toLowerCase().includes(st)).length > 0;
    toggleTargetElementClasses(target, matches, classesOnNoMatch, classesOnMatch);
    return matches;
}
/**
 * Emit a custom event with proper namespacing
 * @param {Element} target - element to dispatch event from
 * @param {Object} controller - Stimulus controller instance for context
 * @param {string} eventName - name of the event
 * @param {*} detail - event detail data
 * @param {boolean} bubbles - whether event should bubble
 * @param {boolean} cancelable - whether event can be cancelled
 */
export function emitEvent(target, controller, eventName, detail = undefined, bubbles = true, cancelable = false) {
    const identifier = controller.identifier || 'component';
    console.debug(`[${identifier}] Emitting event ${identifier}:${eventName}`);
    
    // Use direct CustomEvent instead of Stimulus dispatch for broader compatibility
    const customEvent = new CustomEvent(`${identifier}:${eventName}`, {
        detail,
        bubbles,
        cancelable,
    });
    
    target.dispatchEvent(customEvent);
}
