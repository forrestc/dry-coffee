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

    theme.apply (v) =>
      v.div =>
        if monthDesc is '2017-8'
          v.thisMonth monthDesc
        else
          v.month monthDesc

        v.com Button, onClick: @prevMonth(), label: "<<"
        v.com Button, onClick: @nextMonth(), label: ">>"
        v.table =>
          v.thead =>
            v.tr =>
              for wd, i in 'S M T W T F S'.split(' ')
                v.th {key: 'weekday' + i}, wd
          v.tbody =>
            for w,wIndex in weeks
              v.tr {key: monthDesc + '-week' +  wIndex}, =>
                for d,dIndex in w
                  v.td {key: monthDesc + '-week' +  wIndex + '-day' + dIndex}, =>
                    cell = =>
                      v.span d
                      v.sup @_todos(d)
                    if @_isToday(d)
                      v.b cell
                    else
                      v.p cell

export default Calendar
