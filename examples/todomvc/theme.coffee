import { Theme } from '../superdry'
defaultTheme = new Theme
  wrapper:
    visibility: 'visible !important'
    font: "14px 'Helvetica Neue', Helvetica, Arial, sans-serif"
    lineHeight: '1.4em'
    background: '#f5f5f5'
    color: '#4d4d4d'
    minWidth: 230
    maxWidth: 550
    margin: '0 auto'
    fontSmoothing: 'antialiased'
    fontWeight: '300'

  app:
    background: '#fff'
    margin: '130px 0 40px 0'
    position: 'relative'
    boxShadow: '0 2px 4px 0 rgba(0, 0, 0, 0.2), 0 25px 50px 0 rgba(0, 0, 0, 0.1)'

  header:
    _as: 'h1'
    position: 'absolute'
    top: -155
    width: '100%'
    fontSize: 100
    fontWeight: 100
    textAlign: 'center'
    color: 'rgba(175, 47, 47, 0.15)'
    textRendering: 'optimizeLegibility'

  edit:
    _as: 'input'
    position: 'relative'
    margin: 0
    width: '100%'
    fontSize: 24
    fontFamily: 'inherit'
    fontWeight: 'inherit'
    lineHeight: '1.4em'
    border: 0
    outline: 'none'
    color: 'inherit'
    padding: '6px'
    border: '1px solid #999'
    boxShadow: 'inset 0 -1px 5px 0 rgba(0, 0, 0, 0.2)'
    boxSizing: 'border-box'
    fontSmoothing: 'antialiased'
  newTodo:
    _as: '@edit'
    padding: [16, 16, 16, 60]
    border: 'none'
    background: 'rgba(0, 0, 0, 0.003)'
    boxShadow: 'inset 0 -2px 1px rgba(0,0,0,0.03)'

  main:
    position: 'relative'
    zIndex: 2
    borderTop: '1px solid #e6e6e6'
    visibility: 'visible'
  emptyMain:
    _as: '@main'
    visibility: 'hidden'

  toggle:
    _as: 'input'
    position: 'absolute'
    outline: 'none'
    transform: 'rotate(90deg)'
    appearance: 'none'
    top: -55
    left: -12
    width: 60
    height: 34
    textAlign: 'center'
    border: 'none'
    '&:before':
      content: '"❯"'
      fontSize: 22
      color: '#e6e6e6'
      padding: [10, 27, 10, 27]
    '&:checked:before':
      color: '#737373'

  list:
    margin: 0
    padding: 0
    listStyle: 'none'
export default defaultTheme
