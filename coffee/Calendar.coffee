import styled from 'styled-jss'

import { Observable, Theme } from './Observable'
import Button from './Button'
import { store as todoStore } from './Todo'

theme = new Theme
  month:
    as: 'h1'
    fontSize: 12
  thisMonth:
    as: '@month'
    color: 'blue'

class Calendar extends Observable
  constructor: (props) ->
    super(props)
    @initState
      date: @props.date

  prevMonth: -> =>
    d = @state.date
    @state.date = new Date(d.getFullYear(), d.getMonth() - 1, 1)

  nextMonth: -> =>
    d = @state.date
    @state.date = new Date(d.getFullYear(), d.getMonth() + 1, 1)

  _currDate: (d) ->
    new Date(@state.date.getFullYear(), @state.date.getMonth(), d)

  _isToday: (d) ->
    today = new Date
    @_currDate(d).toDateString() is today.toDateString()

  _todos: (d) ->
    date = @_currDate(d).toDateString()
    n = todoStore.inDates?[date]?.length
    if n then "(#{n})"

  render: () ->
    year = @state.date.getFullYear()
    month = @state.date.getMonth()
    monthDesc = year + '-' + (month + 1)

    startDate = new Date(year, month, 1)
    endDate = new Date(year, month + 1, 0)
    dates = [1..(endDate.getDate())]
    weekStart = startDate.getDay()
    dates.unshift '' for [1..weekStart] if weekStart > 0
    weeks = (dates[(w*7 + 0)..(w*7 + 6)] for w in [0..Math.ceil(dates.length/7)])

    theme.apply (t) =>
      t.div =>
        if monthDesc is '2017-8'
          t.thisMonth monthDesc
        else
          t.month monthDesc

        t.com Button, onClick: @prevMonth(), label: "<<"
        t.com Button, onClick: @nextMonth(), label: ">>"
        t.table =>
          t.thead =>
            t.tr =>
              for wd, i in 'S M T W T F S'.split(' ')
                t.th {key: 'weekday' + i}, wd
          t.tbody =>
            for w,wIndex in weeks
              t.tr {key: monthDesc + '-week' +  wIndex}, =>
                for d,dIndex in w
                  t.td {key: monthDesc + '-week' +  wIndex + '-day' + dIndex}, =>
                    cell = =>
                      t.span d
                      t.sup @_todos(d)
                    if @_isToday(d)
                      t.b cell
                    else
                      t.p cell

export default Calendar
