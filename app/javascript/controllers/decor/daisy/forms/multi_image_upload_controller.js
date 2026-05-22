import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="decor--daisy--forms--multi-image-upload"
//
// Drives a sortable grid of image thumbnails:
//   - file picker -> validate size/count -> add pending thumbnails
//   - drag to reorder (SortableJS) + sync hidden image_order inputs
//   - optional CropperJS crop modal (Apply/Cancel)
//   - hidden new_files input is restocked via DataTransfer on every change
//     so a single form submit ships every picked + cropped file
export default class extends Controller {
  static targets = [
    "sortableContainer",
    "thumbnail",
    "thumbnailImage",
    "fileInput",
    "hiddenFieldsContainer",
    "newFilesInput",
    "imageCount",
    "primaryBadge",
    "cropModal",
    "cropImage"
  ];

  static values = {
    maxSizeInMb: Number,
    maxImages: Number,
    enableCrop: Boolean,
    cropAspectW: Number,
    cropAspectH: Number,
    fileMimeTypes: String
  };

  initialize() {
    this.sortable = null;
    this.pendingFiles = new Map();
    this.removedSignedIds = new Set();
    this.cropper = null;
    this.croppingThumbnail = null;
    this.nextClientId = 0;
  }

  connect() {
    this.initSortable();
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy();
      this.sortable = null;
    }
    this.destroyCropper();
  }

  openFilePicker() {
    if (this.totalImageCount >= this.maxImagesValue) {
      alert(`Maximum of ${this.maxImagesValue} images allowed.`);
      return;
    }
    this.fileInputTarget.click();
  }

  filesSelected(event) {
    const input = event.target;
    if (!input.files || input.files.length === 0) return;

    const remaining = this.maxImagesValue - this.totalImageCount;
    if (remaining <= 0) {
      alert(`Maximum of ${this.maxImagesValue} images allowed.`);
      input.value = "";
      return;
    }

    const files = Array.from(input.files).slice(0, remaining);
    const maxBytes = this.maxSizeInMbValue * 1024 * 1024;

    for (const file of files) {
      if (file.size > maxBytes) {
        alert(`"${file.name}" is too large (max ${this.maxSizeInMbValue}MB).`);
        continue;
      }
      this.addPendingFile(file);
    }

    // Clear so the same file can be re-selected.
    input.value = "";
    this.syncHiddenFields();
    this.updateImageCount();
    this.updatePrimaryBadge();
  }

  removeImage(event) {
    const button = event.target.closest("button");
    const thumbnail = button ? button.closest("[data-image-type]") : null;
    if (!thumbnail) return;
    this.removeThumbnail(thumbnail);
  }

  cropImage(event) {
    if (!this.enableCropValue || !this.hasCropModalTarget) return;

    const button = event.target.closest("button");
    const thumbnail = button ? button.closest("[data-image-type]") : null;
    if (!thumbnail) return;

    const img = thumbnail.querySelector("img");
    if (!img) return;

    this.croppingThumbnail = thumbnail;
    this.cropImageTarget.src = img.src;
    this.cropModalTarget.classList.remove("decor:hidden");
    this.cropModalTarget.classList.remove("hidden");

    // Defer Cropper init until the image loads (Cropper needs natural dims).
    this.cropImageTarget.onload = () => {
      this.destroyCropper();
      const aspectRatio =
        this.cropAspectWValue > 0 && this.cropAspectHValue > 0
          ? this.cropAspectWValue / this.cropAspectHValue
          : NaN;

      // Cropper is loaded globally; if absent (test/no-asset env), bail.
      const CropperCtor = window.Cropper || (typeof Cropper !== "undefined" ? Cropper : null);
      if (!CropperCtor) return;
      this.cropper = new CropperCtor(this.cropImageTarget, { aspectRatio });
    };
  }

  applyCrop() {
    if (!this.cropper || !this.croppingThumbnail) return;

    const canvas = this.cropper.getCroppedCanvas();
    if (!canvas) {
      this.cancelCrop();
      return;
    }

    const thumbnail = this.croppingThumbnail;
    const imageType = thumbnail.dataset.imageType;
    const clientId = thumbnail.dataset.clientId;

    // Data URL for preview — blob: URLs are blocked by some CSPs.
    const dataUrl = canvas.toDataURL("image/png");
    const img = thumbnail.querySelector("img");
    if (img) img.src = dataUrl;

    canvas.toBlob((blob) => {
      if (!blob) {
        this.cancelCrop();
        return;
      }

      if (imageType === "existing") {
        // Mark the source asset for removal, replace with a new pending file.
        const signedId = thumbnail.dataset.signedId;
        if (signedId) this.removedSignedIds.add(signedId);

        const newClientId = this.generateClientId();
        const file = new File([blob], `cropped-${Date.now()}.png`, { type: "image/png" });
        this.pendingFiles.set(newClientId, file);
        thumbnail.dataset.imageType = "pending";
        thumbnail.dataset.clientId = newClientId;
        delete thumbnail.dataset.signedId;
        delete thumbnail.dataset.blobId;
      } else if (imageType === "pending" && clientId) {
        // Replace the pending payload with the cropped one in-place.
        const file = new File([blob], `cropped-${Date.now()}.png`, { type: "image/png" });
        this.pendingFiles.set(clientId, file);
      }

      this.syncHiddenFields();
      this.cancelCrop();
    }, "image/png");
  }

  cancelCrop() {
    this.destroyCropper();
    if (this.hasCropModalTarget) {
      this.cropModalTarget.classList.add("decor:hidden");
      this.cropModalTarget.classList.add("hidden");
    }
    this.croppingThumbnail = null;
  }

  // ── private ────────────────────────────────────────────────────────────

  initSortable() {
    const SortableCtor = window.Sortable || (typeof Sortable !== "undefined" ? Sortable : null);
    if (!SortableCtor) return;
    this.sortable = SortableCtor.create(this.sortableContainerTarget, {
      animation: 150,
      ghostClass: "opacity-50",
      dragClass: "cursor-grabbing",
      onEnd: () => {
        this.syncHiddenFields();
        this.updatePrimaryBadge();
      }
    });
  }

  addPendingFile(file) {
    const clientId = this.generateClientId();
    this.pendingFiles.set(clientId, file);

    const thumb = document.createElement("div");
    thumb.className =
      "decor:relative decor:group decor:border decor:border-suite-hairline-strong decor:rounded-suite-control decor:overflow-hidden decor:bg-suite-gray-25 decor:aspect-square";
    thumb.setAttribute(`data-${this.identifier}-target`, "thumbnail");
    thumb.dataset.imageType = "pending";
    thumb.dataset.clientId = clientId;

    const img = document.createElement("img");
    img.className = "decor:w-full decor:h-full decor:object-cover";
    img.alt = file.name;
    thumb.appendChild(img);

    const reader = new FileReader();
    reader.onload = (e) => {
      if (e.target && e.target.result) {
        img.src = e.target.result.toString();
      }
    };
    reader.readAsDataURL(file);

    const overlay = document.createElement("div");
    overlay.className =
      "decor:absolute decor:inset-0 decor:bg-black/0 decor:group-hover:bg-black/20 decor:transition-colors decor:duration-suite-fast";
    thumb.appendChild(overlay);

    const actions = document.createElement("div");
    actions.className =
      "decor:absolute decor:top-1 decor:right-1 decor:flex decor:gap-1 decor:opacity-0 decor:group-hover:opacity-100 decor:transition-opacity decor:duration-suite-fast";

    if (this.enableCropValue) {
      const cropBtn = document.createElement("button");
      cropBtn.type = "button";
      cropBtn.className =
        "decor:p-1 decor:bg-white decor:rounded-suite-control decor:shadow decor:hover:bg-suite-gray-25 decor:text-gray-700 decor:transition-colors decor:duration-suite-fast";
      cropBtn.title = "Crop image";
      cropBtn.dataset.action = `click->${this.identifier}#cropImage`;
      cropBtn.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="decor:h-4 decor:w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M7 7V3m0 4H3m4 0l10 10m0 0v4m0-4h4M7 7l10 10"/></svg>`;
      actions.appendChild(cropBtn);
    }

    const removeBtn = document.createElement("button");
    removeBtn.type = "button";
    removeBtn.className =
      "decor:p-1 decor:bg-white decor:rounded-suite-control decor:shadow decor:hover:bg-suite-danger-50 decor:text-suite-danger-500 decor:transition-colors decor:duration-suite-fast";
    removeBtn.title = "Remove image";
    removeBtn.dataset.action = `click->${this.identifier}#removeImage`;
    removeBtn.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="decor:h-4 decor:w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>`;
    actions.appendChild(removeBtn);

    thumb.appendChild(actions);
    this.sortableContainerTarget.appendChild(thumb);
  }

  removeThumbnail(thumbnail) {
    const imageType = thumbnail.dataset.imageType;

    if (imageType === "existing") {
      const signedId = thumbnail.dataset.signedId;
      if (signedId) this.removedSignedIds.add(signedId);
    } else if (imageType === "pending") {
      const clientId = thumbnail.dataset.clientId;
      if (clientId) this.pendingFiles.delete(clientId);
    }

    thumbnail.remove();
    this.syncHiddenFields();
    this.updateImageCount();
    this.updatePrimaryBadge();
  }

  syncHiddenFields() {
    const container = this.hiddenFieldsContainerTarget;
    container.innerHTML = "";

    // Object-name strip: the `new_files` input is named `<object>[new_images][]`.
    const objectName = this.newFilesInputTarget.name.replace(/\[new_images\]\[\]$/, "");

    this.removedSignedIds.forEach((signedId) => {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = `${objectName}[remove_image_ids][]`;
      input.value = signedId;
      container.appendChild(input);
    });

    const thumbnails = this.sortableContainerTarget.querySelectorAll("[data-image-type]");
    const orderedPendingFiles = [];

    thumbnails.forEach((thumb) => {
      const imageType = thumb.dataset.imageType;

      if (imageType === "existing") {
        const signedId = thumb.dataset.signedId;
        if (signedId) {
          const orderInput = document.createElement("input");
          orderInput.type = "hidden";
          orderInput.name = `${objectName}[image_order][]`;
          orderInput.value = signedId;
          container.appendChild(orderInput);
        }
      } else if (imageType === "pending") {
        const clientId = thumb.dataset.clientId;
        if (clientId) {
          const file = this.pendingFiles.get(clientId);
          if (file) orderedPendingFiles.push(file);
          // Marker — server matches `new_<clientId>` order entries against
          // the position of the file in the new_images[] list.
          const orderInput = document.createElement("input");
          orderInput.type = "hidden";
          orderInput.name = `${objectName}[image_order][]`;
          orderInput.value = `new_${clientId}`;
          container.appendChild(orderInput);
        }
      }
    });

    this.setFilesOnInput(this.newFilesInputTarget, orderedPendingFiles);
  }

  setFilesOnInput(input, files) {
    const dt = new DataTransfer();
    files.forEach((f) => dt.items.add(f));
    input.files = dt.files;
  }

  updateImageCount() {
    if (!this.hasImageCountTarget) return;
    this.imageCountTarget.textContent = `${this.totalImageCount} / ${this.maxImagesValue} images`;
  }

  updatePrimaryBadge() {
    this.sortableContainerTarget
      .querySelectorAll("[data-primary-badge]")
      .forEach((badge) => badge.remove());
    this.sortableContainerTarget
      .querySelectorAll(`[data-${this.identifier}-target="primaryBadge"]`)
      .forEach((badge) => badge.remove());

    const first = this.sortableContainerTarget.querySelector("[data-image-type]");
    if (first) {
      const badge = document.createElement("span");
      badge.className =
        "decor:absolute decor:top-1 decor:left-1 decor:bg-suite-primary-500 decor:text-white decor:text-xs decor:px-1.5 decor:py-0.5 decor:rounded-suite-control decor:font-medium";
      badge.textContent = "Primary";
      badge.dataset.primaryBadge = "true";
      first.appendChild(badge);
    }
  }

  get totalImageCount() {
    return this.sortableContainerTarget.querySelectorAll("[data-image-type]").length;
  }

  generateClientId() {
    return `client_${this.nextClientId++}_${Date.now()}`;
  }

  destroyCropper() {
    if (this.cropper) {
      this.cropper.destroy();
      this.cropper = null;
    }
  }
}
