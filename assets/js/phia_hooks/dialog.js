// PhiaUI Dialog Hook — PhiaDialog
// Implements WAI-ARIA Dialog pattern with focus trap, keyboard navigation,
// auto-focus, and scroll locking.

const FOCUSABLE_SELECTORS = [
  "a[href]",
  "button:not([disabled])",
  "input:not([disabled])",
  "select:not([disabled])",
  "textarea:not([disabled])",
  '[tabindex]:not([tabindex="-1"])',
].join(", ");

const PhiaDialog = {
  mounted() {
    this.previouslyFocused = document.activeElement;
    this._contentEl = this.el.querySelector("[data-dialog-content]");
    this._handleKeydown = (e) => this._onKeydown(e);
    document.addEventListener("keydown", this._handleKeydown);

    if (this._contentEl) {
      this._wasOpen = !this._contentEl.classList.contains("hidden");

      this._observer = new MutationObserver(() => {
        const isOpen = !this._contentEl.classList.contains("hidden");
        if (isOpen && !this._wasOpen) {
          this._wasOpen = true;
          this._onOpen();
        } else if (!isOpen && this._wasOpen) {
          this._wasOpen = false;
          this._onClose();
        }
      });

      this._observer.observe(this._contentEl, {
        attributes: true,
        attributeFilter: ["class", "style"],
      });

      if (this._wasOpen) {
        this._onOpen();
      }
    }
  },

  destroyed() {
    document.removeEventListener("keydown", this._handleKeydown);
    if (this._observer) {
      this._observer.disconnect();
    }
    document.body.classList.remove("overflow-hidden");
    if (this.previouslyFocused && this.previouslyFocused.focus) {
      this.previouslyFocused.focus();
    }
  },

  _onOpen() {
    document.body.classList.add("overflow-hidden");
    const focusable = this._getFocusable();
    if (focusable.length > 0) {
      focusable[0].focus();
    }
  },

  _onClose() {
    document.body.classList.remove("overflow-hidden");
    if (this.previouslyFocused && this.previouslyFocused.focus) {
      this.previouslyFocused.focus();
    }
  },

  _onKeydown(e) {
    if (!this._contentEl || this._contentEl.classList.contains("hidden")) return;
    if (e.key === "Escape") {
      e.preventDefault();
      this._hide();
    } else if (e.key === "Tab") {
      this._trapFocus(e);
    }
  },

  _hide() {
    if (this._contentEl) {
      this._contentEl.classList.add("hidden");
    }
  },

  _getFocusable() {
    const panel = this.el.querySelector("[data-dialog-panel]");
    if (!panel) return [];
    return Array.from(panel.querySelectorAll(FOCUSABLE_SELECTORS)).filter(
      (el) => !el.hasAttribute("disabled") && el.tabIndex !== -1
    );
  },

  _trapFocus(e) {
    const focusable = this._getFocusable();
    if (focusable.length === 0) return;
    const first = focusable[0];
    const last = focusable[focusable.length - 1];
    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    }
  },
};

export default PhiaDialog;
