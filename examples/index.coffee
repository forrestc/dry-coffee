import { get } from 'lodash'
import React from 'react'
import reactKup from 'react-kup'
import { render } from 'react-dom'
import { AppContainer } from 'react-hot-loader'

import Todo from './Todo'
import Calendar from './Calendar'
import TodoMvc from './todomvc/TodoMvc'


element = () ->
  reactKup (k) ->
    k.build AppContainer, ->
      k.div ->
        #k.build Calendar, {date: new Date}
        #k.build Todo, {name: 'Home'}
        k.build TodoMvc

render(element(), document.getElementById('root'))
