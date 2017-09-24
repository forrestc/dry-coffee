import {
  action, computed, extendObservable, observe, toJS,
  isObservableArray
} from 'mobx'
import { Component as ReactComponent } from 'react';
import { observer } from 'mobx-react';
import reactKup from 'react-kup';
import styled from 'styled-jss'
import { capitalize, forEach, isObject, merge, omit } from 'lodash'

export class Store {
  constructor(obj) {
    let observableAttrs = []
    for (let attrName in obj) {
      let val = obj[attrName]
      if (typeof(val) === 'function') {
        obj[attrName] = computed(val)
      } else {
        observableAttrs.push(attrName)
      }
    }
    const observable = extendObservable(this, obj)

    if (this.onUpdate) {
      observe(observable, this.onUpdate.bind(this))
    }
    forEach(observableAttrs, (attrName) => {
      let attr = observable[attrName]

      let fnUpdate = 'on' + capitalize(attrName) + 'Update'
      if (this[fnUpdate])
        observe(attr, this[fnUpdate].bind(this))

      if (isObservableArray(attr)) {
        let fnCreate = 'on' + capitalize(attrName) + 'Create'
        if (this[fnCreate]) {
          const fn = (change) => {
            if ((change.type === 'splice') && (change.added[0]))
              this[fnCreate](toJS(change.added[0]))
          }
          observe(observable[attrName], fn.bind(this))
        }

        let fnDelete = 'on' + capitalize(attrName) + 'Delete'
        if (this[fnDelete]) {
          const fn = (change) => {
            if ((change.type === 'splice') && (change.removed[0]))
              this[fnDelete](toJS(change.removed[0]))
          }
          observe(observable[attrName], fn.bind(this))
        }
      }
    })
  }

  json(obj) {
    return toJS(obj || this)
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
      let elem = def['_as'] || 'div'
      let m = elem.match(/(\w+)\((\w+)\)/)
      let defaultArgs = {}
      if (m) {
        elem = m[1]
        defaultArgs.type = m[2]
      }
      this.define(name, elem, omit(def, '_as'), defaultArgs)
    }
  }

  define(name, base, css, defaultArgs) {
    if (base.substring(0, 1) === '@')
      base = this.coms[base.substring(1)]

    const root = isObject(base) ? base.root : base
    if (isObject(base)) {
      css = merge(base.css, css)
    }
    this.coms[name] = {
      root: root,
      base: isObject(base) ? base.name : base,
      name: name,
      css: css,
      defaultArgs: defaultArgs,
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

            args[0] = merge(com.defaultArgs, omit(attrs, ['onEnter', 'onInput']))
          }
          v.build(com.component, ...args)
        }
      }

      v.with = (name, state) => {
        for (let [key, value] of Object.entries(state)) {
          if (value) return v[name + '.' + key]
        }
        return v[name]
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
