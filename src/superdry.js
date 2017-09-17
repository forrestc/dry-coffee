import { extendObservable, computed, action } from 'mobx'
import { Component as ReactComponent } from 'react';
import { observer } from 'mobx-react';
import reactKup from 'react-kup';
import styled from 'styled-jss'
import { isObject, merge, omit } from 'lodash'

export class Store {
  constructor(obj) {
    for (let attrName in obj) {
      let val = obj[attrName]
      if (typeof(val) === 'function') {
        obj[attrName] = computed(val)
      }
    }
    extendObservable(this, obj)
  }

  action(fn) {
    return action(fn)
  }

}

export class Theme {
  constructor(components) {
    this.coms = {}
    for (let name in components) {
      const def = components[name]

      // TODO maybe we can use jss 'extends'
      const elem = def['_as'] || 'div'
      // TODO support input(checkbox)
      this.define(name, elem, omit(def, '_as'))
    }
  }

  define(name, base, css) {
    if (base.substring(0, 1) === '@')
      base = this.coms[base.substring(1)]

    const root = isObject(base) ? base.root : base
    if (isObject(base)) {
      css = merge(base.css, css)
    }
    console.log(111, name, root, css)
    this.coms[name] = {
      root: root,
      base: isObject(base) ? base.name : base,
      name: name,
      css: css,
      component: styled(root)(css)
    }
  }

  apply(fn) {
    const renderFn = function(v) {
      for (let [name, com] of Object.entries(this.coms)) {
        v[name] = (...args) => {
          if (com.root === 'input' && isObject(args[0])) {
            const attrs = args[0]
            if (attrs.onEnter) {
              attrs.onKeyPress = function (e) {
                if (e.which === 13) attrs.onEnter()
              }
            }

            if (attrs.onInput) {
              attrs.onChange = function (e) {
                attrs.onInput(e.target.value)
              }
            }
            args[0] = omit(attrs, ['onEnter', 'onInput'])
          }
          v.build(com.component, ...args)
        }
      }

      v.com = v.build
      fn(v)
    }.bind(this)

    return reactKup(renderFn)
  }
}

export const Component = observer(
  class OC extends ReactComponent {
    constructor(props) {
      super(props)
    }

    initState(obj) {
      this.state = new Store(obj)
    }
  }
)
