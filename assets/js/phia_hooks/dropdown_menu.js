// PhiaUI DropdownMenu Hook — PhiaDropdownMenu

const PhiaDropdownMenu = {
  mounted() {
    this._trigger = this.el.querySelector("[data-dropdown-trigger]");
    this._content = this.el.querySelector("[data-dropdown-content]");
    if (!this._trigger || !this._content) return;

    this._handleTriggerClick = () => this._toggle();
    this._handleClickOutside = (e) => this._onClickOutside(e);
    this._handleKeydown = (e) => this._onKeydown(e);

    this._trigger.addEventListener("click", this._handleTriggerClick);
    document.addEventListener("click", this._handleClickOutside);
    document.addEventListener("keydown", this._handleKeydown);
  },

  destroyed() {
    if (this._trigger) {
      this._trigger.removeEventListener("click", this._handleTriggerClick);
    }
    document.removeEventListener("click", this._handleClickOutside);
    document.removeEventListener("keydown", this._handleKeydown);
  },

  _isOpen() {
    return !this._content.classList.contains("hidden");
  },

  _open() {
    this._content.classList.remove("hidden");
    this._trigger.setAttribute("aria-expanded", "true");
    this._position();
    const items = this._getItems();
    if (items.length > 0) items[0].focus();
  },

  _close() {
    this._content.classList.add("hidden");
    this._trigger.setAttribute("aria-expanded", "false");
    this._trigger.focus();
  },

  _toggle() {
    this._isOpen() ? this._close() : this._open();
  },

  _position() {
    const rect = this._trigger.getBoundingClientRect();
    let top = rect.bottom + window.scrollY;
    const left = rect.left + window.scrollX;
    this._content.style.top = `${top}px`;
    this._content.style.left = `${left}px`;
    const contentRect = this._content.getBoundingClientRect();
    if (contentRect.bottom > window.innerHeight - 20) {
      top = rect.top + window.scrollY - this._content.offsetHeight;
      this._content.style.top = `${top}px`;
    }
  },

  _onClickOutside(e) {
    if (!this._isOpen()) return;
    if (!this.el.contains(e.target)) {
      this._close();
    }
  },

  _onKeydown(e) {
    if (!this._isOpen()) return;
    switch (e.key) {
      case "Escape":
        e.preventDefault();
        this._close();
        break;
      case "ArrowDown":
        e.preventDefault();
        this._focusNext(1);
        break;
      case "ArrowUp":
        e.preventDefault();
        this._focusNext(-1);
        break;
      case "Enter":
      case " ":
        e.preventDefault();
        const active = document.activeElement;
        if (active && active.getAttribute("aria-disabled") !== "true" && this._content.contains(active)) {
          active.click();
          this._close();
        }
        break;
    }
  },

  _getItems() {
    return Array.from(
      this._content.querySelectorAll('[data-dropdown-item]:not([aria-disabled="true"])')
    );
  },

  _focusNext(direction) {
    const items = this._getItems();
    if (items.length === 0) return;
    const current = document.activeElement;
    const currentIndex = items.indexOf(current);
    let nextIndex;
    if (currentIndex === -1) {
      nextIndex = direction === 1 ? 0 : items.length - 1;
    } else {
      nextIndex = (currentIndex + direction + items.length) % items.length;
    }
    items[nextIndex].focus();
  },
};

export default PhiaDropdownMenu;
