const PhiaCalendar = {
  mounted() {
    this._handleKeydown = (e) => {
      const focused = document.activeElement;
      const cells = Array.from(
        this.el.querySelectorAll('[role="gridcell"] button:not([disabled])')
      );
      const idx = cells.indexOf(focused);
      if (idx === -1) return;
      let nextIdx = idx;
      if (e.key === "ArrowRight") nextIdx = idx + 1;
      else if (e.key === "ArrowLeft") nextIdx = idx - 1;
      else if (e.key === "ArrowDown") nextIdx = idx + 7;
      else if (e.key === "ArrowUp") nextIdx = idx - 7;
      else if (e.key === "Home") nextIdx = Math.floor(idx / 7) * 7;
      else if (e.key === "End") nextIdx = Math.floor(idx / 7) * 7 + 6;
      else if (e.key === "Enter") { focused.click(); return; }
      else return;
      e.preventDefault();
      if (nextIdx >= 0 && nextIdx < cells.length) cells[nextIdx].focus();
    };
    this.el.addEventListener("keydown", this._handleKeydown);
  },
  destroyed() {
    this.el.removeEventListener("keydown", this._handleKeydown);
  },
};
export default PhiaCalendar;
