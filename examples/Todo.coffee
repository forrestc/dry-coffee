import { Component, Store, Theme } from './superdry'
import Button from './Button'

apiCall = () ->
  fetch('http://localhost:10040/autocomplete?types=chain&q=starbucks')

theme = new Theme

class TodoItem extends Store
  constructor: (value) ->
    super
      value: value
      id: Date.now()
      complete: false
      action: ->
        [action, due] = @value.split(' due ')
        return action

      due: ->
        [action, due] = @value.split(' due ')
        if due
          new Date(due).toDateString()
        else
          new Date().toDateString()

  toggle: () ->
    @complete = not @complete

class TodoStore extends Store
  constructor: () ->
    super
      todos: []
      filter: ''

      inDates: ->
        dates = {}
        for todo in @todos
          unless todo.complete
            dates[todo.due] or= []
            dates[todo.due].push(todo.key)
        dates

      filteredTodos: ->
        matchesFilter = new RegExp(@filter, 'i')
        @todos.filter (todo) => not @filter or matchesFilter.test(todo.action)

  initData: ->
    try
      res = await apiCall()
      data = await res.json()
      console.log data
    catch e
      console.log e

export store = new TodoStore
store.initData()
window.store = store

class Todo extends Component
  createTodo: (e) ->
    if (e.which is 13)
      value = e.target.value
      todo = new TodoItem(value)
      store.todos.push todo

  toggle: (e) ->
    id = parseInt(e.target.id)
    todo.toggle() for todo in store.todos when todo.id is id

  clearCompleted: ->
    incompleted = store.todos.filter (todo) -> !todo.complete
    store.todos.replace(incompleted)

  filter: (e) ->
    store.filter = e.target.value

  render: () ->
    theme.apply (t) =>
      t.div =>
        t.h1 @props.name
        t.input
          type: 'text'
          placeholder: 'new todo'
          onKeyPress: @createTodo.bind(@)
        t.input
          type: 'text'
          placeholder: 'filter'
          value: store.filter
          onChange: @filter.bind(@)
        t.com Button, onClick: @clearCompleted, label: 'Clear Completed'

        t.ul =>
          for todo in store.filteredTodos
            t.li key: todo.id, =>
              t.input
                type: 'checkbox'
                id: todo.id
                value: todo.complete
                checked: todo.complete
                onChange: @toggle.bind(@)
              t.span todo.action
              t.small "(#{todo.due})"

export default Todo
