import { extendObservable, computed, action } from 'mobx'
import { Component } from 'react';
import { observer } from 'mobx-react';
import reactKup from 'react-kup';
import styled from 'styled-jss'
import { omit } from 'lodash'

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
      this.define(name, def.as, omit(def, 'as'))
    }
  }

  define(name, base, css) {
    if (base.substring(0, 1) === '@')
      base = this.coms[base.substring(1)]

    this.coms[name] = styled(base)(css)
  }

  apply(fn) {
    const renderFn = function(v) {
      for (let [name, com] of Object.entries(this.coms)) {
        v[name] = (...args) => v.build(com, ...args)
      }

      v.com = v.build
      fn(v)
    }.bind(this)

    return reactKup(renderFn)
  }
}

export const Observable = observer(
  class OC extends Component {
    constructor(props) {
      super(props)
    }

    initState(obj) {
      this.state = new Store(obj)
    }

    brew(v) {
      v.com = v.build
    }

    render() {
      return reactKup(this.brew.bind(this))
    }
  }
)
