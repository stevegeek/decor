/**
 * Service for persisting table selections across page reloads and pagination
 * via localStorage.
 *
 * Features:
 * - Persists checkbox selections across page refreshes and pagination
 * - Supports multiple tables on the same page through unique table identifiers
 * - Cross-tab synchronization via storage events
 * - Automatic cleanup of expired selections after 24 hours
 * - Stores checkbox values (not row IDs) as stable identifiers
 */

export class SelectionPersistenceService {
  static CONFIG = {
    STORAGE_PREFIX: "dataTable",
    STORAGE_SEPARATOR: ":",
    TTL_HOURS: 24,
    MAX_SELECTION_SIZE: 1000,
  };

  static quotaExceededCallback = null;

  static getStorageKey(tableId) {
    return `${this.CONFIG.STORAGE_PREFIX}${this.CONFIG.STORAGE_SEPARATOR}${tableId}${this.CONFIG.STORAGE_SEPARATOR}selections`;
  }

  static getMetadataKey(tableId) {
    return `${this.CONFIG.STORAGE_PREFIX}${this.CONFIG.STORAGE_SEPARATOR}${tableId}${this.CONFIG.STORAGE_SEPARATOR}metadata`;
  }

  static saveSelections(tableId, selectedIds) {
    if (!tableId) return false;
    if (!this.validateSelections(selectedIds)) {
      console.warn(
        `Invalid selections for table ${tableId}: Too many selections or invalid IDs`,
      );
      return false;
    }

    try {
      const key = this.getStorageKey(tableId);
      const metadataKey = this.getMetadataKey(tableId);

      if (selectedIds.length === 0) {
        localStorage.removeItem(key);
        localStorage.removeItem(metadataKey);
      } else {
        const metadata = { timestamp: Date.now(), count: selectedIds.length };
        localStorage.setItem(key, JSON.stringify(selectedIds));
        localStorage.setItem(metadataKey, JSON.stringify(metadata));
      }
      return true;
    } catch (error) {
      this.handleStorageError(tableId, error);
      return false;
    }
  }

  static loadSelections(tableId) {
    if (!tableId) return [];

    try {
      const key = this.getStorageKey(tableId);
      const metadataKey = this.getMetadataKey(tableId);

      const selectionsJson = localStorage.getItem(key);
      const metadataJson = localStorage.getItem(metadataKey);

      if (!selectionsJson) return [];

      if (metadataJson) {
        const metadata = JSON.parse(metadataJson);
        const ageInHours = (Date.now() - metadata.timestamp) / (1000 * 60 * 60);
        if (ageInHours > this.CONFIG.TTL_HOURS) {
          this.clearSelections(tableId);
          return [];
        }
      }

      return JSON.parse(selectionsJson);
    } catch (error) {
      console.warn(`Failed to load selections for table ${tableId}:`, error);
      return [];
    }
  }

  static clearSelections(tableId) {
    if (!tableId) return;
    try {
      localStorage.removeItem(this.getStorageKey(tableId));
      localStorage.removeItem(this.getMetadataKey(tableId));
    } catch (error) {
      console.warn(`Failed to clear selections for table ${tableId}:`, error);
    }
  }

  static getPersistedCount(tableId) {
    if (!tableId) return 0;
    try {
      const metadataJson = localStorage.getItem(this.getMetadataKey(tableId));
      if (metadataJson) {
        const metadata = JSON.parse(metadataJson);
        return metadata.count || 0;
      }
      return this.loadSelections(tableId).length;
    } catch (error) {
      console.warn(
        `Failed to get persisted count for table ${tableId}:`,
        error,
      );
      return 0;
    }
  }

  static addSelection(tableId, itemId) {
    if (!tableId || !itemId) return;
    try {
      const selectionSet = new Set(this.loadSelections(tableId));
      if (!selectionSet.has(itemId)) {
        selectionSet.add(itemId);
        this.saveSelections(tableId, Array.from(selectionSet));
      }
    } catch (error) {
      console.warn(`Failed to add selection for table ${tableId}:`, error);
    }
  }

  static removeSelection(tableId, itemId) {
    if (!tableId || !itemId) return;
    try {
      const selectionSet = new Set(this.loadSelections(tableId));
      if (selectionSet.has(itemId)) {
        selectionSet.delete(itemId);
        this.saveSelections(tableId, Array.from(selectionSet));
      }
    } catch (error) {
      console.warn(`Failed to remove selection for table ${tableId}:`, error);
    }
  }

  static isSelected(tableId, itemId) {
    if (!tableId || !itemId) return false;
    return this.loadSelections(tableId).includes(itemId);
  }

  static validateSelections(selectedIds) {
    if (selectedIds.length > this.CONFIG.MAX_SELECTION_SIZE) return false;
    return selectedIds.every((id) => {
      if (typeof id !== "string" || id.length === 0 || id.length > 200) return false;
      const xssPatterns = [
        /<script/i,
        /<iframe/i,
        /javascript:/i,
        /on[a-z]{1,20}\s{0,10}=/i,
        /<\s*\w+/,
      ];
      if (xssPatterns.some((pattern) => pattern.test(id))) {
        console.warn("Potential XSS attempt detected in selection ID:", id);
        return false;
      }
      if (/[\0\x00-\x1F\x7F\n\r]/.test(id)) return false;
      if (!/^[a-zA-Z0-9_\-\.]+$/.test(id)) {
        console.warn(
          "Invalid ID format (must be alphanumeric with -_. only):",
          id,
        );
        return false;
      }
      return true;
    });
  }

  static handleStorageError(tableId, error) {
    const errorMessage = (error.message || "").toLowerCase();
    const isQuotaError =
      errorMessage.includes("quota") ||
      errorMessage.includes("exceeded") ||
      error.name === "QuotaExceededError";

    if (isQuotaError) {
      console.error(`localStorage quota exceeded for table ${tableId}`);
      this.cleanupExpiredSelections();
      if (this.quotaExceededCallback) {
        this.quotaExceededCallback(tableId, error);
      }
    } else {
      console.warn(`Failed to save selections for table ${tableId}:`, error);
    }
  }

  static onQuotaExceeded(callback) {
    this.quotaExceededCallback = callback;
  }

  static cleanupExpiredSelections() {
    try {
      const keys = Object.keys(localStorage);
      const prefix = this.CONFIG.STORAGE_PREFIX + this.CONFIG.STORAGE_SEPARATOR;

      keys.forEach((key) => {
        if (key.startsWith(prefix) && key.endsWith(":metadata")) {
          try {
            const metadata = JSON.parse(localStorage.getItem(key) || "{}");
            const ageInHours =
              (Date.now() - (metadata.timestamp || 0)) / (1000 * 60 * 60);
            if (ageInHours > this.CONFIG.TTL_HOURS) {
              localStorage.removeItem(key);
              localStorage.removeItem(key.replace(":metadata", ":selections"));
            }
          } catch (e) {
            localStorage.removeItem(key);
          }
        }
      });
    } catch (error) {
      console.warn("Failed to cleanup expired selections:", error);
    }
  }

  static addStorageListener(tableId, callback) {
    const key = this.getStorageKey(tableId);
    const handler = (event) => {
      if (event.key === key && event.newValue !== event.oldValue) {
        try {
          const selectedIds = event.newValue ? JSON.parse(event.newValue) : [];
          callback(selectedIds);
        } catch (error) {
          console.warn("Failed to parse storage event:", error);
        }
      }
    };
    window.addEventListener("storage", handler);
    return () => window.removeEventListener("storage", handler);
  }
}

if (typeof window !== "undefined") {
  SelectionPersistenceService.cleanupExpiredSelections();
}

export default SelectionPersistenceService;
