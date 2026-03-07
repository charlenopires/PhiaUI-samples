// PhiaUI BackTop Hook — PhiaBackTop
//
// Monitors window scroll position and toggles the button's visibility
// once the user scrolls past `data-threshold` pixels.
// Clicking the button scrolls to the top using the native scrollTo API.

const PhiaBackTop = {
  mounted() {
    this._threshold = parseInt(this.el.dataset.threshold ?? "200");
    this._smooth = this.el.dataset.smooth !== "false";

    this._onScroll = () => {
      const scrollY = window.scrollY ?? window.pageYOffset ?? 0;
      if (scrollY > this._threshold) {
        this.el.style.opacity = "1";
        this.el.style.pointerEvents = "auto";
        this.el.setAttribute("aria-hidden", "false");
      } else {
        this.el.style.opacity = "0";
        this.el.style.pointerEvents = "none";
        this.el.setAttribute("aria-hidden", "true");
      }
    };

    this._onClick = () => {
      window.scrollTo({ top: 0, behavior: this._smooth ? "smooth" : "instant" });
    };

    window.addEventListener("scroll", this._onScroll, { passive: true });
    this.el.addEventListener("click", this._onClick);
    // Run initial check in case page is already scrolled on mount
    this._onScroll();
  },

  destroyed() {
    window.removeEventListener("scroll", this._onScroll);
    this.el.removeEventListener("click", this._onClick);
  },
};

export default PhiaBackTop;
