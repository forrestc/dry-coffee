import { Observable } from '../lib/Observable'
import PropTypes from 'prop-types'

class Button extends Observable
  constructor: (props) ->
    super(props)

  onClick: ->
    @props.onClick()

  brew: (v) ->
    super(v)
    v.button onClick: @onClick.bind(@), @props.label

Button.propTypes =
  onClick: PropTypes.func.isRequired
  label: PropTypes.string.isRequired

export default Button
