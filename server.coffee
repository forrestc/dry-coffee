app = require('express')()

cors = require('cors')
bodyParser = require('body-parser')

app.use cors()
app.use bodyParser.json()

{ find, merge, omit } = require 'lodash'

DEFAULT_ENTREIS =
  1506184685750: { description: 'buy milk' }
  1506184685751: { description: 'buy cheese', completed: true }

entries = DEFAULT_ENTREIS

app.get '/entries', (req, res) ->
  res.json (merge(entry, id: id) for id, entry of entries)

app.patch '/entry/:id', (req, res) ->
  entries[req.params.id] = req.body
  res.json status: 'ok'

app.delete '/entry/:id', (req, res) ->
  delete entries[req.params.id]
  res.json status: 'ok'
  
app.post '/entries', (req, res) ->
  id = req.body.id
  entries[id] = omit req.body, 'id'
  res.json { status: 'ok' }

app.listen 3000
