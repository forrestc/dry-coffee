import React from 'react'
import { render } from 'react-dom'
import { AppContainer } from 'react-hot-loader'
import Todo from './Todo'
import { get } from 'lodash'
import Calendar from './Calendar'
import reactKup from 'react-kup'


element = () ->
  reactKup (k) ->
    k.build AppContainer, ->
      k.div ->
        k.build Calendar, {date: new Date}
        k.build Todo, {name: 'Home'}

render(element(), document.getElementById('root'))
