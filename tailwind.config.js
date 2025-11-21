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
            fontFamily: {
                sans: ['Poppins', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'sans-serif'],
            },
            colors: {
                dada: {
                    // Primary color from logo heart
                    primary: '#E94F4F',
                    primaryDark: '#FF6F6F', // Brighter variant for dark mode

                    // Secondary color from logo text "Dada"
                    secondary: '#6D2B3E',

                    // Accent colors
                    accent: '#D64040',

                    // Text colors
                    text: {
                        light: '#2E2E2E',
                        dark: '#FAFAFA',
                        secondary: '#888888',
                    },

                    // Background colors
                    background: {
                        light: '#FFEFEF',
                        dark: '#1A1A1A',
                    },

                    // Card backgrounds
                    card: {
                        light: '#FFFFFF',
                        dark: '#2B2B2B',
                    },
                },
            },
            borderRadius: {
                'dada': '12px', // Standard brand border radius
            },
        },
    },
    plugins: []
}