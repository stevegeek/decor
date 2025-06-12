import { Controller } from "@hotwired/stimulus";
import { markAsSafeHTML, safelySetInnerHTML, replaceContentsWithChildren, createAxiosInstance } from "controllers/decor";
export default class extends Controller {
    constructor() {
        super(...arguments);
        this.shown = false;
    }

    static targets = ["menu", "button"];
    static values = {
        leaveTimeout: Number,
        contentHref: String,
        placeholder: String
    };
    static classes = [
        "entering",
        "enteringFrom",
        "enteringTo",
        "leaving",
        "leavingFrom",
        "leavingTo",
    ];

    toggle(event) {
        if (this.shown) {
            this.hide();
        }
        else {
            this.show();
        }
    }
    hideOnClickOutside(event) {
        if (!this.shown) {
            return;
        }
        // If the menu itself is clicked, we don't want to hide the menu.
        if (event && this.element.contains(event.target)) {
            return;
        }
        if (event &&
            this.hasButtonTarget &&
            this.buttonTarget.contains(event.target)) {
            return;
        }
        this.hide();
    }
    hide() {
        this.displayMenu(false);
        this.shown = false;
    }
    show() {
        this.prepareContent();
        this.displayMenu(true);
        this.shown = true;
    }
    displayMenu(state) {
        if (state) {
            this.menuTarget.classList.remove("hidden");
            this.menuTarget.classList.add(...this.enteringClasses);
            this.menuTarget.classList.add(...this.enteringFromClasses);
            
            setTimeout(() => {
                this.menuTarget.classList.remove(...this.enteringFromClasses);
                this.menuTarget.classList.add(...this.enteringToClasses);
            }, 10);
        } else {
            this.menuTarget.classList.add(...this.leavingClasses);
            this.menuTarget.classList.add(...this.leavingFromClasses);
            
            setTimeout(() => {
                this.menuTarget.classList.remove(...this.leavingFromClasses);
                this.menuTarget.classList.add(...this.leavingToClasses);
            }, 10);
            
            setTimeout(() => {
                this.menuTarget.classList.add("hidden");
                this.menuTarget.classList.remove(...this.enteringClasses, ...this.enteringToClasses, ...this.leavingClasses, ...this.leavingToClasses);
            }, this.leaveTimeoutValue || 75);
        }
    }
    async prepareContent() {
        if (this.placeholderValue) {
            this.setContent(markAsSafeHTML(this.placeholderValue));
        }
        if (this.contentHrefValue) {
            this.getContent(this.contentHrefValue)
                .then((c) => {
                this.setContent(c);
            })
                .catch((err) => {
                console.error("Could not fetch content for dropdown", this.contentHrefValue, err);
                const errorMessage = "Something went wrong while loading the content for this dropdown. Please try again later.";
                this.setContent(markAsSafeHTML(errorMessage));
            });
        }
    }
    async getContent(contentHref) {
        const axios = createAxiosInstance();
        return axios
            .get(contentHref, {
            headers: {
                "Content-Type": "text/html",
            },
        })
            .then((response) => {
            return markAsSafeHTML(response.data);
        });
    }
    setContent(content) {
        replaceContentsWithChildren(this.menuTarget, this.createContent(content));
    }
    createContent(content) {
        const contentContainer = document.createElement("div");
        contentContainer.id = `${this.element.id}-content`;
        // We likely want to allow arbitrary HTML here so that the dialog content can be formatted appropriately, and allow things like other MDC components to be rendered inside.
        // The problem with allowing arbitrary HTML to be rendered is that it opens the possibility of a XSS attack.
        // To try and mitigate this issue, we ask that the developer explicitly wraps the content inside an object with a `__safe` property.
        // Of course, this can't guarantee that a developer is passing safe content, but it at least gets them thinking about the dangers of XSS when pushing content to be displayed.
        // https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)
        safelySetInnerHTML(contentContainer, content);
        return contentContainer;
    }
}