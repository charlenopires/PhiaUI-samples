// PhiaUI HoverCard Hook — PhiaHoverCard
//
// Reveals a floating card when the user hovers over (or focuses) the trigger
// element. Uses configurable open/close delays so the card doesn't flash when
// the cursor passes through the trigger on the way to something else, and so
// the user can move the cursor into the card without it disappearing.
//
// Markup contract:
//   Hook root:    phx-hook="PhiaHoverCard", data-open-delay, data-close-delay, data-side
//   Trigger:      [data-hover-card-trigger]
//   Content:      [data-hover-card-content], data-side, class includes "hidden"

const PhiaHoverCard = {
  mounted() {
    this._openDelay = parseInt(this.el.dataset.openDelay ?? "300");
    this._closeDelay = parseInt(this.el.dataset.closeDelay ?? "200");
    this._side = this.el.dataset.side ?? "bottom";

    this._trigger = this.el.querySelector("[data-hover-card-trigger]");
    this._content = this.el.querySelector("[data-hover-card-content]");

    if (!this._trigger || !this._content) return;

    this._openTimer = null;
    this._closeTimer = null;

    this._enterTrigger = () => {
      clearTimeout(this._closeTimer);
      this._openTimer = setTimeout(() => this._open(), this._openDelay);
    };

    this._leaveTrigger = () => {
      clearTimeout(this._openTimer);
      this._closeTimer = setTimeout(() => this._close(), this._closeDelay);
    };

    // Allow cursor to move from trigger into the card without closing
    this._enterContent = () => { clearTimeout(this._closeTimer); };
    this._leaveContent = () => {
      clearTimeout(this._openTimer);
      this._closeTimer = setTimeout(() => this._close(), this._closeDelay);
    };

    this._trigger.addEventListener("mouseenter", this._enterTrigger);
    this._trigger.addEventListener("mouseleave", this._leaveTrigger);
    // Keyboard / focus support
    this._trigger.addEventListener("focus", this._enterTrigger);
    this._trigger.addEventListener("blur", this._leaveTrigger);
    this._content.addEventListener("mouseenter", this._enterContent);
    this._content.addEventListener("mouseleave", this._leaveContent);
  },

  destroyed() {
    clearTimeout(this._openTimer);
    clearTimeout(this._closeTimer);
    if (!this._trigger) return;
    this._trigger.removeEventListener("mouseenter", this._enterTrigger);
    this._trigger.removeEventListener("mouseleave", this._leaveTrigger);
    this._trigger.removeEventListener("focus", this._enterTrigger);
    this._trigger.removeEventListener("blur", this._leaveTrigger);
    if (this._content) {
      this._content.removeEventListener("mouseenter", this._enterContent);
      this._content.removeEventListener("mouseleave", this._leaveContent);
    }
  },

  _open() {
    if (!this._content) return;
    this._position();
    this._content.classList.remove("hidden");
  },

  _close() {
    if (!this._content) return;
    this._content.classList.add("hidden");
  },

  _position() {
    const side = this._content.dataset.side ?? this._side;
    const gap = 8;

    // Temporarily make visible to measure dimensions
    this._content.classList.remove("hidden");
    Object.assign(this._content.style, { top: "", bottom: "", left: "", right: "" });

    const triggerRect = this._trigger.getBoundingClientRect();
    const parentRect = this.el.getBoundingClientRect();
    const contentRect = this._content.getBoundingClientRect();

    const vw = window.innerWidth;
    const vh = window.innerHeight;

    // Choose the best side, flipping when the preferred side would overflow
    let chosen = side;
    if (side === "bottom" && triggerRect.bottom + contentRect.height + gap > vh) chosen = "top";
    else if (side === "top" && triggerRect.top - contentRect.height - gap < 0) chosen = "bottom";
    else if (side === "right" && triggerRect.right + contentRect.width + gap > vw) chosen = "left";
    else if (side === "left" && triggerRect.left - contentRect.width - gap < 0) chosen = "right";

    switch (chosen) {
      case "bottom":
        this._content.style.top = (triggerRect.bottom - parentRect.top + gap) + "px";
        this._content.style.left = (triggerRect.left - parentRect.left) + "px";
        break;
      case "top":
        this._content.style.bottom = (parentRect.bottom - triggerRect.top + gap) + "px";
        this._content.style.left = (triggerRect.left - parentRect.left) + "px";
        break;
      case "right":
        this._content.style.left = (triggerRect.right - parentRect.left + gap) + "px";
        this._content.style.top = (triggerRect.top - parentRect.top) + "px";
        break;
      case "left":
        this._content.style.right = (parentRect.right - triggerRect.left + gap) + "px";
        this._content.style.top = (triggerRect.top - parentRect.top) + "px";
        break;
    }

    // Horizontal edge clamp for top/bottom sides
    if (chosen === "bottom" || chosen === "top") {
      const leftPx = parseFloat(this._content.style.left);
      if (leftPx + contentRect.width > vw - 8) {
        this._content.style.left = (vw - contentRect.width - 8 - parentRect.left) + "px";
      }
      if (leftPx < 8) {
        this._content.style.left = (8 - parentRect.left) + "px";
      }
    }
  },
};

export default PhiaHoverCard;
