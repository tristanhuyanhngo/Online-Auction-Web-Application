module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontfamily: {
        'montserrat':'Montserrat',
      },
      colors: {
        transparent: 'transparent',
        current: 'currentColor',
        hor: {
          light: '#85d7ff',
          cyan: '#0891B2',
          DEFAULT: '#4682B4',
          royal: '#4169E1',
          dark: '#009eeb',
        }
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
