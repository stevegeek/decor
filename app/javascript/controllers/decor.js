
export function replaceContentsWithChildren(
    parent, // Node
    children, // Node | Node[]
) {
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

    return parent; // Node
}

function emptyNode(node) {
    // https://jsperf.com/innerhtml-vs-removechild/37
    while (node.firstChild) {
        node.removeChild(node.firstChild);
    }
}
