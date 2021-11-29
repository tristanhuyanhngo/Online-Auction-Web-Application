const colors = require('tailwindcss/colors')
module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        cyan: colors.cyan,
        key: '#0E7490'
      },
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