import { countBy, every, find, filter, isEmpty, remove } from 'lodash'
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

  saveUpdate: ->
    console.log 'PUT', @id, @json()

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
          else "#{count} items left"

  saveCreate: (entry) -> console.log 'POST', @json(entry)
  saveDelete: (id) -> console.log 'DELETE', id

export $ = new TodoStore

# Components

class Input extends Component
  updateField: (input) ->
    $.input = input

  add: ->
    entry = new Entry($.input)
    $.entries.push entry
    $.input = ''
    $.saveCreate(entry)

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
    entry.saveUpdate()

  edit: (id, isEditing = true) ->
    entry = @_entry(id)
    entry.editing = isEditing
    entry.saveUpdate() if isEditing is false

  update: (id, text) ->
    @_entry(id).description = text

  delete: (id) ->
    remove $.entries, (entry) -> entry.id is id
    $.saveDelete(id)

  render: ->
    theme.apply (t) =>
      main = if isEmpty($.entries) then 'emptyMain' else 'main'

      t[main] =>
        t.toggle
          name: "toggle"
          checked: every($.entries, 'completed')
          onClick: @checkAll
        t.toggleLabel { for: 'toggle' }, 'Mark all as complete'
        t.list =>
          $.visibleEntries.forEach (entry) =>
            task = if entry.editing then 'editingTask' else 'task'
            t[task] =>
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
                  onClick: => @check(entry.id)
                label = if entry.completed then 'completedLabel' else 'entryLabel'
                t[label] { onDoubleClick: => @edit(entry.id) }, entry.description
                t.destroyButton { onClick: => @delete(entry.id) }

class Footer extends Component
  changeVisibility: (visibility) ->
    $.visibility = visibility

  clearCompleted: ->
    $.entries = $.incompletedEntries

  render: ->
    theme.apply (t) =>
      unless isEmpty($.entries)
        t.footer =>
          t.counter $.entriesLeft
          t.filters =>
            ['All', 'Active', 'Completed'].forEach (visibility) =>
              button = if visibility is $.visibility then 'filteringBtn' else 'filterBtn'
              t[button] { onClick: => @changeVisibility(visibility) }, visibility

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