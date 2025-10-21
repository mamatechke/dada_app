// app/javascript/theme_controller.js
document.addEventListener("DOMContentLoaded", () => {
    const toggleBtn = document.getElementById("theme-toggle");
    const icon = document.getElementById("theme-toggle-icon");

    const stored = localStorage.getItem("theme");
    if (stored === "dark") {
        document.documentElement.classList.add("dark");
    }

    toggleBtn.addEventListener("click", () => {
        document.documentElement.classList.toggle("dark");
        const newMode = document.documentElement.classList.contains("dark") ? "dark" : "light";
        localStorage.setItem("theme", newMode);
    });
});
