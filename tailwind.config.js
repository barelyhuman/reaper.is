/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./hooks/*.lua', './pages/**/*.{html,md}'],
  theme: {
    extend: {
      colors: {
        dark: 'var(--dark)',
        light: 'var(--light)',
        gray: 'var(--gray)',
        accent: 'var(--accent)',
      },
    },
  },
  plugins: [],
}
