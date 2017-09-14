import { Observable, Theme } from './Observable'
import PropTypes from 'prop-types'

theme = new Theme

class Button extends Observable
  constructor: (props) ->
    super(props)

  onClick: ->
    @props.onClick()

  render: () ->
    theme.apply (t) =>
      t.button onClick: @onClick.bind(@), @props.label

Button.propTypes =
  onClick: PropTypes.func.isRequired
  label: PropTypes.string.isRequired

export default Button
