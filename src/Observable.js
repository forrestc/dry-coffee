import { extendObservable, computed, action } from 'mobx'
import { Component } from 'react';
import { observer } from 'mobx-react';
import reactKup from 'react-kup';

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
