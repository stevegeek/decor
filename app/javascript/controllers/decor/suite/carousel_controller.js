import { Controller } from "@hotwired/stimulus";
import Swiper from "swiper";
import { Navigation, Pagination, Keyboard, A11y, Autoplay } from "swiper/modules";

// Tailwind-canonical breakpoints. Keys accepted in the `slidesPerView` Hash
// (from the Ruby side) map to these pixel thresholds for Swiper's
// `breakpoints:` option. `base` is the pre-sm default and translates to `0`.
const BREAKPOINT_PX = {
  base: 0,
  sm: 640,
  md: 768,
  lg: 1024,
  xl: 1280,
  "2xl": 1536,
};

export default class extends Controller {
  static values = {
    slidesPerView: { type: Object, default: {} },
    spaceBetween: { type: Number, default: 16 },
    loop: { type: Boolean, default: false },
    showPagination: { type: Boolean, default: true },
    showArrows: { type: Boolean, default: true },
    autoplayDelay: { type: Number, default: 0 },
  };

  connect() {
    this.element.classList.remove("decor:hidden");
    this.element.classList.remove("hidden");

    const config = {
      modules: [Navigation, Pagination, Keyboard, A11y, Autoplay],
      spaceBetween: this.spaceBetweenValue,
      centeredSlides: true,
      loop: this.loopValue,
      keyboard: { enabled: true, onlyInViewport: true },
      a11y: {
        enabled: true,
        prevSlideMessage: "Previous slide",
        nextSlideMessage: "Next slide",
        paginationBulletMessage: "Go to slide {{index}}",
      },
      ...this.#slidesPerViewConfig(),
    };

    if (this.showArrowsValue) {
      config.navigation = {
        prevEl: this.element.querySelector(".swiper-button-prev"),
        nextEl: this.element.querySelector(".swiper-button-next"),
        disabledClass: "swiper-button-disabled",
      };
    }

    if (this.showPaginationValue) {
      config.pagination = {
        el: this.element.querySelector(".swiper-pagination"),
        clickable: true,
      };
    }

    if (this.autoplayDelayValue > 0) {
      config.autoplay = {
        delay: this.autoplayDelayValue,
        pauseOnMouseEnter: true,
        disableOnInteraction: false,
      };
    }

    this.carousel = new Swiper(this.element, config);
  }

  disconnect() {
    if (this.carousel) {
      this.carousel.destroy();
      this.carousel = undefined;
    }
  }

  // Translates the `slidesPerView` value into a Swiper-compatible config:
  // - Number → { slidesPerView: N }
  // - Hash { base: 1, md: 2 } → { slidesPerView: 1, breakpoints: { 768: { slidesPerView: 2 } } }
  // - Empty/missing → sensible default
  #slidesPerViewConfig() {
    const val = this.slidesPerViewValue;

    if (typeof val === "number" && val > 0) {
      return { slidesPerView: val };
    }

    if (val && typeof val === "object" && !Array.isArray(val)) {
      const entries = Object.entries(val);
      if (entries.length === 0) {
        return { slidesPerView: window.innerWidth > 600 ? 3 : 1.25 };
      }

      const base = val.base ?? val.sm ?? Object.values(val)[0];

      const breakpoints = {};
      for (const [key, count] of entries) {
        if (key === "base") continue;
        const px = BREAKPOINT_PX[key];
        if (typeof px === "number" && px > 0) {
          breakpoints[px] = { slidesPerView: count };
        }
      }

      return { slidesPerView: base, breakpoints };
    }

    return { slidesPerView: window.innerWidth > 600 ? 3 : 1.25 };
  }
}
