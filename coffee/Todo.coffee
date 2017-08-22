import { Observable, Store } from '../lib/Observable'
import Button from './Button'

apiCall = () ->
  fetch('http://localhost:10040/autocomplete?types=chain&q=starbucks')

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

class Todo extends Observable
  constructor: (props) ->
    super(props)

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

  brew: (v) ->
    super(v)
    v.div =>
      v.h1 @props.name
      v.input
        type: 'text'
        placeholder: 'new todo'
        onKeyPress: @createTodo.bind(@)
      v.input
        type: 'text'
        placeholder: 'filter'
        value: store.filter
        onChange: @filter.bind(@)
      v.com Button, onClick: @clearCompleted, label: 'Clear Completed'

      v.ul =>
        for todo in store.filteredTodos
          v.li key: todo.id, =>
            v.input
              type: 'checkbox'
              id: todo.id
              value: todo.complete
              checked: todo.complete
              onChange: @toggle.bind(@)
            v.span todo.action
            v.small "(#{todo.due})"

export default Todo
