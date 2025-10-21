/** @type {import('tailwindcss').Config} */
export default {
    darkMode: 'class',
    content: [
        './app/views/**/*.{html,erb}',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.{js,ts}',
        './app/assets/**/*.{css,scss,js,erb}'
    ],
    safelist: [
        'bg-dada-primary',
        'bg-dada-secondary',
        'text-dada-text'
    ],
    theme: {
        extend: {
            colors: {
                dada: {
                    primary: '#E84D4D',
                    secondary: '#FFB6A9',
                    text: '#5E2A35',
                },
            },
        },
    },
    plugins: []
}