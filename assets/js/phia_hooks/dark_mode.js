// PhiaUI Dark Mode Hook — PhiaDarkMode

const PhiaDarkMode = {
  mounted() {
    this._sync();
    this._onClick = this._onClick.bind(this);
    this.el.addEventListener("click", this._onClick);
  },

  destroyed() {
    this.el.removeEventListener("click", this._onClick);
  },

  _onClick() {
    const isDark = document.documentElement.classList.toggle("dark");
    const theme = isDark ? "dark" : "light";
    localStorage.setItem("phia-theme", theme);
    this._updateLabel(isDark);
    document.dispatchEvent(
      new CustomEvent("phia:theme-changed", { detail: { theme }, bubbles: true })
    );
  },

  _sync() {
    const stored = localStorage.getItem("phia-theme");
    let isDark;
    if (stored) {
      isDark = stored === "dark";
    } else {
      isDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
      localStorage.setItem("phia-theme", isDark ? "dark" : "light");
    }
    if (isDark) {
      document.documentElement.classList.add("dark");
    } else {
      document.documentElement.classList.remove("dark");
    }
    this._updateLabel(isDark);
  },

  _updateLabel(isDark) {
    this.el.setAttribute(
      "aria-label",
      isDark ? "Switch to light mode" : "Switch to dark mode"
    );
  },
};

export default PhiaDarkMode;
