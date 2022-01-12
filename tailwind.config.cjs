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

      display: ["group-hover", "hover", "group-focus", "focus"],
      margin: ["group-hover", "group-focus"],
      visibility: ["group-hover", "group-focus"],
      backgroundColor: ['group-focus'],
    
    },
  },
  plugins: [],
}