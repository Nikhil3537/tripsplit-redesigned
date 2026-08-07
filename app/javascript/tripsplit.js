// TripSplit shared front-end behavior.
// Works with Turbo navigation (drive) — everything re-initializes on turbo:load.

(function () {
  "use strict";

  /* ---------------------------------------------------------------------
   * Dark mode
   * ------------------------------------------------------------------- */
  function initTheme() {
    const stored = localStorage.getItem("ts-theme");
    const prefersDark = window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
    const theme = stored || (prefersDark ? "dark" : "light");
    document.documentElement.setAttribute("data-bs-theme", theme);
    updateThemeToggleIcon(theme);
  }

  function updateThemeToggleIcon(theme) {
    document.querySelectorAll("[data-ts-theme-toggle] i").forEach((icon) => {
      icon.className = theme === "dark" ? "bi bi-sun-fill" : "bi bi-moon-stars-fill";
    });
  }

  function bindThemeToggle() {
    document.querySelectorAll("[data-ts-theme-toggle]").forEach((btn) => {
      btn.addEventListener("click", () => {
        const current = document.documentElement.getAttribute("data-bs-theme") || "light";
        const next = current === "dark" ? "light" : "dark";
        document.documentElement.setAttribute("data-bs-theme", next);
        localStorage.setItem("ts-theme", next);
        updateThemeToggleIcon(next);
      });
    });
  }

  /* ---------------------------------------------------------------------
   * Page loader / top progress bar (Turbo navigation feedback)
   * ------------------------------------------------------------------- */
  function initPageLoader() {
    const bar = document.getElementById("ts-topbar-progress");
    if (!bar) return;

    document.addEventListener("turbo:before-fetch-request", () => {
      bar.classList.remove("is-done");
      bar.classList.add("is-active");
    });

    document.addEventListener("turbo:before-fetch-response", () => {
      bar.classList.add("is-done");
      setTimeout(() => bar.classList.remove("is-active", "is-done"), 300);
    });

    document.addEventListener("turbo:before-cache", () => {
      bar.classList.remove("is-active", "is-done");
    });
  }

  /* ---------------------------------------------------------------------
   * Toasts — converts server flash + any data-ts-flash blocks into
   * floating toast notifications, and exposes window.tsToast(msg, type)
   * for JS-triggered toasts (e.g. "copied to clipboard").
   * ------------------------------------------------------------------- */
  function ensureToastStack() {
    let stack = document.querySelector(".ts-toast-stack");
    if (!stack) {
      stack = document.createElement("div");
      stack.className = "ts-toast-stack";
      stack.setAttribute("aria-live", "polite");
      document.body.appendChild(stack);
    }
    return stack;
  }

  function showToast(message, type) {
    if (!message) return;
    type = type || "primary";
    const stack = ensureToastStack();

    const icon =
      type === "success" ? "bi-check-circle-fill" :
      type === "danger" ? "bi-exclamation-triangle-fill" :
      "bi-info-circle-fill";

    const toast = document.createElement("div");
    toast.className = "ts-toast ts-toast-" + type;
    toast.innerHTML =
      '<i class="bi ' + icon + ' ts-toast-icon"></i>' +
      '<div class="ts-toast-body"></div>' +
      '<button type="button" class="ts-toast-close" aria-label="Close"><i class="bi bi-x-lg"></i></button>';

    toast.querySelector(".ts-toast-body").textContent = message;
    stack.appendChild(toast);

    const remove = () => {
      toast.classList.add("is-leaving");
      setTimeout(() => toast.remove(), 250);
    };

    toast.querySelector(".ts-toast-close").addEventListener("click", remove);
    setTimeout(remove, 4500);
  }

  window.tsToast = showToast;

  function initFlashToasts() {
    document.querySelectorAll("[data-ts-flash]").forEach((el) => {
      showToast(el.dataset.tsFlash, el.dataset.tsFlashType || "primary");
      el.remove();
    });
  }

  /* ---------------------------------------------------------------------
   * Mobile / responsive: highlight active sidebar + nav links
   * ------------------------------------------------------------------- */
  function highlightActiveLinks() {
    const path = window.location.pathname;
    document.querySelectorAll("[data-ts-nav-match]").forEach((link) => {
      const match = link.getAttribute("data-ts-nav-match");
      const isActive = match === "/" ? path === "/" : path.startsWith(match);
      link.classList.toggle("active", isActive);
    });
  }

  /* ---------------------------------------------------------------------
   * Copy invite link buttons: <button data-ts-copy="#target-input">
   * ------------------------------------------------------------------- */
  function bindCopyButtons() {
    document.querySelectorAll("[data-ts-copy]").forEach((btn) => {
      btn.addEventListener("click", () => {
        const target = document.querySelector(btn.getAttribute("data-ts-copy"));
        if (!target) return;

        const finish = () => {
          const original = btn.innerHTML;
          btn.classList.add("is-copied");
          btn.innerHTML = '<i class="bi bi-check-lg"></i>';
          showToast("Invite link copied to clipboard.", "success");
          setTimeout(() => {
            btn.classList.remove("is-copied");
            btn.innerHTML = original;
          }, 1800);
        };

        if (navigator.clipboard && window.isSecureContext) {
          navigator.clipboard.writeText(target.value).then(finish).catch(finish);
        } else {
          target.select();
          document.execCommand("copy");
          finish();
        }
      });
    });
  }

  /* ---------------------------------------------------------------------
   * Expense form: live split preview + card selection highlight
   * ------------------------------------------------------------------- */
  function initExpenseSplitPreview() {
    const amountField = document.getElementById("expense_amount");
    if (!amountField) return;

    const splitOut = document.getElementById("split_amount");
    const checkboxes = document.querySelectorAll(".ts-member-checkbox");

    function update() {
      const amount = parseFloat(amountField.value) || 0;
      const checked = document.querySelectorAll(".ts-member-checkbox:checked");

      checkboxes.forEach((box) => {
        const card = box.closest(".ts-member-card");
        if (card) card.classList.toggle("is-checked", box.checked);
      });

      if (splitOut) {
        const split = checked.length > 0 ? (amount / checked.length).toFixed(2) : "0.00";
        splitOut.textContent = split;
      }
    }

    amountField.addEventListener("input", update);
    checkboxes.forEach((box) => box.addEventListener("change", update));
    update();
  }

  /* ---------------------------------------------------------------------
   * Password visibility toggle
   * ------------------------------------------------------------------- */
  function bindPasswordToggles() {
    document.querySelectorAll("[data-ts-toggle-password]").forEach((btn) => {
      btn.addEventListener("click", () => {
        const input = document.querySelector(btn.getAttribute("data-ts-toggle-password"));
        if (!input) return;
        const showing = input.type === "text";
        input.type = showing ? "password" : "text";
        btn.querySelector("i").className = showing ? "bi bi-eye" : "bi bi-eye-slash";
      });
    });
  }

  /* ---------------------------------------------------------------------
   * Charts (Chart.js loaded via CDN in layout). Reads JSON from a
   * <script type="application/json" data-ts-chart="category"> tag.
   * ------------------------------------------------------------------- */
  function initCharts() {
    if (typeof Chart === "undefined") return;

    const categoryEl = document.getElementById("ts-category-chart");
    if (categoryEl && !categoryEl.dataset.rendered) {
      try {
        const raw = JSON.parse(document.getElementById("ts-category-chart-data").textContent);
        new Chart(categoryEl, {
          type: "doughnut",
          data: {
            labels: raw.labels,
            datasets: [{
              data: raw.values,
              backgroundColor: ["#2563eb", "#7c3aed", "#16a34a", "#f59e0b", "#0ea5e9", "#e11d48", "#14b8a6"],
              borderWidth: 0,
              hoverOffset: 8
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: "68%",
            plugins: { legend: { position: "bottom", labels: { boxWidth: 10, padding: 14, font: { size: 11, weight: "600" } } } }
          }
        });
        categoryEl.dataset.rendered = "true";
      } catch (e) { /* no data available */ }
    }

    const settlementEl = document.getElementById("ts-settlement-chart");
    if (settlementEl && !settlementEl.dataset.rendered) {
      try {
        const raw = JSON.parse(document.getElementById("ts-settlement-chart-data").textContent);
        new Chart(settlementEl, {
          type: "bar",
          data: {
            labels: ["Pending", "Completed"],
            datasets: [{
              data: [raw.pending, raw.completed],
              backgroundColor: ["#f59e0b", "#16a34a"],
              borderRadius: 8,
              maxBarThickness: 46
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
              y: { beginAtZero: true, grid: { color: "rgba(100,116,139,0.12)" } },
              x: { grid: { display: false } }
            }
          }
        });
        settlementEl.dataset.rendered = "true";
      } catch (e) { /* no data available */ }
    }
  }

  /* ---------------------------------------------------------------------
   * Boot
   * ------------------------------------------------------------------- */
  function boot() {
    initTheme();
    bindThemeToggle();
    initPageLoader();
    initFlashToasts();
    highlightActiveLinks();
    bindCopyButtons();
    initExpenseSplitPreview();
    bindPasswordToggles();
    initCharts();
  }

  document.addEventListener("turbo:load", boot);
  document.addEventListener("DOMContentLoaded", boot);
})();
