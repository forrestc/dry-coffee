import { every, filter, isEmpty } from 'lodash'
import { Component, Store, Theme } from '../superdry'
import theme from './theme'

# Stores

class Entry extends Store
  constructor: (desc) ->
    super
      description: desc
      completed: false
      editing: false
      id: Date.now()

class TodoStore extends Store
  constructor: ->
    super
      entries: []
      visibility: 'All'
      input: ''

      visibleEntries: ->
        switch @visibility
          when 'Completed' then filter(@entries, 'completed')
          when 'Active' then filter(@entries, ['completed', false])
          else @entries

export store = new TodoStore

# Components

class Input extends Component
  updateField: (input) ->
    store.input = input

  add: ->
    entry = new Entry(store.input)
    store.entries.push entry
    store.input = ''

  render: ->
    theme.apply (t) =>
      t.newTodo
        placeholder: "What needs to be done?"
        autofocus: true
        value: store.input
        name: "newTodo"
        onInput: @updateField
        onEnter: @add

class EntryList extends Component
  checkAll: ->
    for entry in store.entries
      entry.completed = true

  render: ->
    theme.apply (t) =>
      if isEmpty(store.entries)
        main = 'emptyMain'
      else
        main = 'main'

      t[main] =>
        t.toggle
          type: "checkbox"
          name: "toggle"
          checked: every(store.entries, 'completed')
          onClick: @checkAll
        t.label
          for: 'toggle'
          text: 'Mark all as complete'
        t.list ->
          for entry in store.visibleEntries
            t.li entry.description

class Footer extends Component

class Todo extends Component
  render: ->
    theme.apply (t) ->
      t.wrapper ->
        t.app ->
          t.header 'todos'
          t.com Input
          t.com EntryList
          # t.com Footer

export default Todo
