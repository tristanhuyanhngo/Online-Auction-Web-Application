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
        blue: {
          'light': '#85d7ff',
          DEFAULT: '#4682B4',
          royal: '#4169E1',
          dark: '#009eeb',
        },
        pink: {
          light: '#ff7ce5',
          DEFAULT: '#ff49db',
          dark: '#ff16d1',
        },
        gray: {
          darkest: '#1f2d3d',
          dark: '#3c4858',
          DEFAULT: '#c0ccda',
          light: '#e0e6ed',
          lightest: '#f9fafc',
        }
      }
    },
  },
  variants: {
    extend: {
      display: ["group-hover", "hover"],
      margin: ["group-hover"],
      visibility: ["group-hover"],
      backgroundColor: ['group-focus'],
    },
  },
  plugins: [],
}
