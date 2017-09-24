import { every, find, filter, isEmpty, pick, remove } from 'lodash'
import { Component, Store, Theme } from '../superdry'
import theme from './theme'
import api from './api'

# Stores

class Entry extends Store
  constructor: (description, load = {}) ->
    super
      description: description
      completed: load.completed or false
      editing: false
      id: load.id or Date.now()

  onUpdate: ->
    api.patch(@id, @json()) unless @editing

class TodoStore extends Store
  constructor: ->
    super
      entries: []
      visibility: 'All'
      input: ''

      completedEntries: -> filter(@entries, 'completed')
      incompletedEntries: -> filter(@entries, ['completed', false])
      visibleEntries: ->
        switch @visibility
          when 'Completed' then @completedEntries
          when 'Active' then @incompletedEntries
          else @entries

      completedCount: -> @completedEntries.length
      entriesLeft: ->
        count = @incompletedEntries.length
        switch count
          when 0 then ''
          when 1 then '1 item left'

  onEntriesCreate: (entry) -> api.create(entry) unless @loading
  onEntriesDelete: (entry) -> api.delete(entry.id)

  load: () ->
    @loading = true
    for obj in (await api.list())
      @entries.push new Entry(obj.description, obj)
    @loading = false

export $ = new TodoStore
window.store = $
$.load()

# Components

class Input extends Component
  updateField: (input) ->
    $.input = input

  add: ->
    entry = new Entry($.input)
    $.entries.push entry
    $.input = ''

  render: ->
    theme.apply (t) =>
      t.newTodo
        placeholder: "What needs to be done?"
        autoFocus: true
        value: $.input
        name: "newTodo"
        onInput: @updateField
        onEnter: @add

class EntryList extends Component
  checkAll: ->
    for entry in $.entries
      entry.completed = true

  _entry: (id) -> find($.entries, id: id)

  check: (id) ->
    entry = @_entry(id)
    entry.completed = not entry.completed

  edit: (id, isEditing = true) ->
    entry = @_entry(id)
    entry.editing = isEditing

  update: (id, text) ->
    @_entry(id).description = text

  delete: (id) ->
    remove $.entries, (entry) -> entry.id is id

  render: ->
    theme.apply (t) =>
      t.with('main', empty: isEmpty($.entries)) =>
        t.toggle
          name: "toggle"
          checked: every($.entries, 'completed')
          onChange: @checkAll
        t.toggleLabel { for: 'toggle' }, 'Mark all as complete'
        t.list =>
          $.visibleEntries.forEach (entry) =>
            t.with('task', pick(entry, 'editing')) =>
              if entry.editing
                t.taskEdit
                  value: entry.description
                  id: entry.id
                  autoFocus: true
                  onInput: (text) => @update(entry.id, text)
                  onBlur: => @edit(entry.id, false)
                  onEnter: => @edit(entry.id, false)
              else
                t.taskToggle
                  checked: entry.completed
                  onChange: => @check(entry.id)
                labelOpts = { onDoubleClick: => @edit(entry.id) }
                t.with('entryLabel', pick(entry, 'completed')) labelOpts, entry.description
                t.destroyButton { onClick: => @delete(entry.id) }

class Footer extends Component
  changeVisibility: (visibility) ->
    $.visibility = visibility

  clearCompleted: ->
    remove($.entries, 'completed')

  render: ->
    theme.apply (t) =>
      unless isEmpty($.entries)
        t.footer =>
          t.counter $.entriesLeft
          t.filters =>
            ['All', 'Active', 'Completed'].forEach (visibility) =>
              buttonOpts = { onClick: => @changeVisibility(visibility) }
              current = (visibility is $.visibility)
              t.with('filter', current: current) buttonOpts, visibility

          completedCount = $.completedEntries.length
          if completedCount > 0
            t.clearButton { onClick: @clearCompleted }, "Clear completed (#{completedCount})"

class Todo extends Component
  render: ->
    theme.apply (t) ->
      t.wrapper ->
        t.app ->
          t.header 'todos'
          t.com Input
          t.com EntryList
          t.com Footer
        t.info ->
          t.infoLine "Double-click to edit a todo"
          t.infoLine ->
            t.span "Written by "
            t.infoLink href: "https://github.com/forrestc", "Forrest Cao"
          t.infoLine ->
            t.span "Not yet part of "
            t.infoLink href: "http://todomvc.com", "TodoMVC"

export default Todo
