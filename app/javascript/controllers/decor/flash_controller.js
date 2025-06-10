import { Controller } from "@hotwired/stimulus";
import { replaceContentsWithChildren } from "controllers/decor";

const INITIAL_CLASSES = "invisible opacity-0";
const VISIBLE_CLASSES = "transition-opacity duration-300 opacity-100 visible";
const COLLAPSED_CLASS = "hidden";
const TEXT_CLASS = "text-sm";

export default class extends Controller {
    static values = {
        showInitial: Boolean
    };

    connect() {
        this.hidden = true;
        
        if (this.showInitialValue) {
            this.hidden = false;
            this.reveal();
        }
    }

    showFlashMessage(text, timeout) {
        this.text = text;
        this.reveal(timeout);
    }

    reveal(timeout) {
        this.removeInitialClass();
        this.addVisibleClasses();
        this.removeCollapsedClasses();
        
        if (timeout) {
            setTimeout(() => this.hide(), timeout);
        }
        
        this.hidden = false;
        this.element.removeAttribute("hidden");
    }

    hide() {
        this.removeVisibleClasses();
        this.addInitialClasses();
        this.hidden = true;
        this.element.setAttribute("hidden", "hidden");
    }

    toggle() {
        if (this.hidden) {
            this.reveal();
        } else {
            this.hide();
        }
    }

    handleCloseEvent() {
        this.hide();
    }

    // Reveal by calling:
    // window.dispatchEvent(new CustomEvent("decor-flash:show", { detail: { message } }));
    async handleShowEvent(evt) {
        const { detail: { message, timeout } } = evt;
        this.showFlashMessage(message, timeout);
    }

    get isRevealed() {
        return !this.hidden;
    }

    set text(text) {
        const p = document.createElement("p");
        TEXT_CLASS.split(" ").forEach((cl) => p.classList.add(cl));
        p.textContent = text;
        this.content = p;
    }

    renderHeadingWithListContent(heading, items) {
        const headingNode = this.createHeading(heading);
        const listNode = document.createElement("ul");
        items.forEach((item) => {
            const listItemNode = document.createElement("li");
            listItemNode.textContent = item;
            listNode.appendChild(listItemNode);
        });
        this.content = [headingNode, listNode];
    }

    removeVisibleClasses() {
        VISIBLE_CLASSES.split(" ").forEach((cl) => this.element.classList.remove(cl));
    }

    addVisibleClasses() {
        VISIBLE_CLASSES.split(" ").forEach((cl) => this.element.classList.add(cl));
    }

    removeCollapsedClasses() {
        COLLAPSED_CLASS.split(" ").forEach((cl) => this.element.classList.remove(cl));
    }

    removeInitialClass() {
        INITIAL_CLASSES.split(" ").forEach((cl) => this.element.classList.remove(cl));
    }

    addInitialClasses() {
        INITIAL_CLASSES.split(" ").forEach((cl) => this.element.classList.add(cl));
    }

    createHeading(content) {
        const heading = document.createElement("h2");
        heading.classList.add("c-h7");
        heading.textContent = content;
        return heading;
    }

    set content(children) {
        replaceContentsWithChildren(this.element, children);
    }
}
