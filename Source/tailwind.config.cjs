module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontfamily: {
        'montserrat':'Montserrat',
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
