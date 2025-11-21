// app/javascript/theme_controller.js
document.addEventListener("DOMContentLoaded", () => {
    const toggleBtn = document.getElementById("theme-toggle");
    const icon = document.getElementById("theme-toggle-icon");

    const initializeTheme = () => {
        const stored = localStorage.getItem("theme");

        if (stored === "dark") {
            document.documentElement.classList.add("dark");
        } else if (stored === "light") {
            document.documentElement.classList.remove("dark");
        } else {
            if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
                document.documentElement.classList.add("dark");
            } else {
                document.documentElement.classList.remove("dark");
            }
        }
    };

    initializeTheme();

    if (window.matchMedia) {
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
            if (!localStorage.getItem("theme")) {
                if (e.matches) {
                    document.documentElement.classList.add("dark");
                } else {
                    document.documentElement.classList.remove("dark");
                }
            }
        });
    }

    if (toggleBtn) {
        toggleBtn.addEventListener("click", () => {
            document.documentElement.classList.toggle("dark");
            const newMode = document.documentElement.classList.contains("dark") ? "dark" : "light";
            localStorage.setItem("theme", newMode);
        });
    }
});
