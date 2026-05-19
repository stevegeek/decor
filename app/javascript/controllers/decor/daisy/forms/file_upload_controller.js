import FormFieldController from "./form_field";

// FileUpload controller. Inherits the FormFieldController validation pipeline
// (touched/blur/listening, error caption swap, error icon, focus-first-
// invalid) and adds the file-specific lifecycle: drop-zone drag highlighting,
// file-size guard, image / file-list / avatar preview rendering, and the
// "remove image" reset path.
//
// Registered Stimulus identifier: `decor--daisy--forms--file-upload`. The
// Decor::Suite::Forms::FileUpload Phlex component wires its data attributes
// to this identifier so the same JS drives both Daisy and Suite skins.
export default class FileUploadController extends FormFieldController {
  static classes = [...FormFieldController.classes, "image"];

  static targets = [
    ...FormFieldController.targets,
    "thumbnailWrapper",
    "thumbnailImage",
    "deleteField",
    "dropZone",
    "fileList",
  ];

  static values = {
    ...FormFieldController.values,
    maxSizeInMb: Number,
  };

  // ── drop-zone drag-and-drop ────────────────────────────────────────────

  onDragOver(event) {
    event.preventDefault();
    if (this.hasDropZoneTarget) {
      this.dropZoneTarget.classList.add(
        "border-primary-500",
        "bg-primary-50",
        "border-primary-500!",
      );
      this.dropZoneTarget.classList.remove(
        "border-hairline-strong",
        "bg-gray-25",
      );
    }
  }

  onDragLeave(_event) {
    if (this.hasDropZoneTarget) {
      this.dropZoneTarget.classList.remove(
        "border-primary-500",
        "bg-primary-50",
        "border-primary-500!",
      );
      this.dropZoneTarget.classList.add(
        "border-hairline-strong",
        "bg-gray-25",
      );
    }
  }

  onDrop(event) {
    event.preventDefault();
    this.onDragLeave(event);

    const input = this.element.querySelector('input[type="file"]');
    if (!input || !event.dataTransfer) return;

    try {
      // Some browsers refuse direct DataTransfer→input assignment; the
      // try/catch fails silently in that case rather than blowing up the
      // drag-and-drop session.
      input.files = event.dataTransfer.files;
    } catch {
      return;
    }

    input.dispatchEvent(new Event("change", { bubbles: true }));
  }

  openFilePicker() {
    const input = this.element.querySelector('input[type="file"]');
    if (input) input.click();
  }

  removeImage() {
    if (this.hasDeleteFieldTarget) {
      this.deleteFieldTarget.value = "true";
    }

    const input = this.element.querySelector('input[type="file"]');
    if (input) input.value = "";

    if (this.hasThumbnailWrapperTarget) {
      this.thumbnailWrapperTarget.outerHTML = `
        <div class="border rounded-lg bg-gray-50 w-32 h-32 flex flex-col items-center justify-center text-gray-400"
             data-${this.identifier}-target="thumbnailWrapper">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 mb-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
            <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.409a2.25 2.25 0 013.182 0l2.909 2.909M3.75 21h16.5A2.25 2.25 0 0022.5 18.75V5.25A2.25 2.25 0 0020.25 3H3.75A2.25 2.25 0 001.5 5.25v13.5A2.25 2.25 0 003.75 21z" />
          </svg>
          <span class="text-xs">No image</span>
        </div>`;
    }
  }

  // ── file selection / preview rendering ─────────────────────────────────

  fileSelected(event) {
    const input = event.target;
    if (!input.files || !input.files[0]) return;

    if (input.files[0].size / 1024 / 1024 > this.maxSize) {
      alert("Sorry that file is too large");
      input.value = "";
      return;
    }

    if (this.hasDeleteFieldTarget) {
      this.deleteFieldTarget.value = "false";
    }

    if (this.hasThumbnailWrapperTarget) {
      this._renderImagePreview(input);
    } else if (this.hasFileListTarget) {
      this._renderFileList(input.files);
    } else {
      this._renderLegacyAvatar(input);
    }
  }

  _renderImagePreview(input) {
    const reader = new FileReader();
    reader.onload = (e) => {
      if (!e.target || !e.target.result) return;
      this.thumbnailWrapperTarget.outerHTML = `
        <div class="relative group border rounded-lg overflow-hidden bg-gray-50 w-32 h-32"
             data-${this.identifier}-target="thumbnailWrapper">
          <img src="${e.target.result.toString()}"
               class="w-full h-full object-cover"
               data-${this.identifier}-target="thumbnailImage" />
          <div class="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-colors"></div>
          <div class="absolute top-1 right-1 flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
            <button type="button"
                    class="p-1 bg-white rounded-sm shadow-sm hover:bg-red-100 text-red-600"
                    data-action="${this.identifier}#removeImage"
                    title="Remove image">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>`;
    };
    reader.readAsDataURL(input.files[0]);
  }

  _renderFileList(files) {
    const items = [];
    for (let i = 0; i < files.length; i++) {
      const f = files[i];
      const kb = Math.round(f.size / 1024);
      const size = kb >= 1024 ? `${(kb / 1024).toFixed(1)} MB` : `${kb} KB`;
      items.push(
        `<div class="flex items-center gap-2 text-[12px] text-gray-700 bg-gray-50 border border-hairline rounded-[6px] px-3 py-1.5">` +
          `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="w-4 h-4 text-gray-400 shrink-0"><path d="M13 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><polyline points="13 2 13 9 20 9"/></svg>` +
          `<span class="truncate font-medium">${escapeText(f.name)}</span>` +
          `<span class="text-gray-400 shrink-0">${size}</span>` +
          `</div>`,
      );
    }
    this.fileListTarget.innerHTML = items.join("");
  }

  // Legacy avatar variant — replaces the image inside a known container
  // class. Predates the thumbnailWrapper target wiring and is kept for
  // back-compat with existing renders.
  _renderLegacyAvatar(input) {
    const container = this.element.getElementsByClassName(
      "decor--image-upload--image-container",
    )[0];
    if (!container) return;

    const reader = new FileReader();
    reader.onload = (e) => {
      const image = document.createElement("img");
      if (this.hasImageClass) {
        image.classList.add(...this.imageClasses);
      }
      if (e.target && e.target.result) {
        image.src = e.target.result.toString();
        container.replaceChild(image, container.children[0]);
      }
    };
    reader.readAsDataURL(input.files[0]);
  }

  get maxSize() {
    return this.maxSizeInMbValue;
  }
}

function escapeText(s) {
  return String(s).replace(/[&<>"']/g, (c) => (
    { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]
  ));
}
