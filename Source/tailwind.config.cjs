const colors = require('tailwindcss/colors')
module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        // transparent: 'transparent',
        // current: 'currentColor',
        // blue: {
        //   light: '#85d7ff',
        //   cyan: '#0891B2',
        //   DEFAULT: '#4682B4',
        //   royal: '#4169E1',
        //   dark: '#009eeb',
        
        //}
        blue: colors.cyan,
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
