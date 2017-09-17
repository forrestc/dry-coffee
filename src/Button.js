// Generated by CoffeeScript 2.0.0-beta3
var Button, theme;

import {
  Component,
  Theme
} from './superdry';

import PropTypes from 'prop-types';

theme = new Theme;

Button = class Button extends Component {
  constructor(props) {
    super(props);
  }

  onClick() {
    return this.props.onClick();
  }

  render() {
    return theme.apply((t) => {
      return t.button({
        onClick: this.onClick.bind(this)
      }, this.props.label);
    });
  }

};

Button.propTypes = {
  onClick: PropTypes.func.isRequired,
  label: PropTypes.string.isRequired
};

export default Button;
