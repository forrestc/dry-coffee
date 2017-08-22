express = require('express')
app = express()
app.get '/', (req, res) ->
  res.json(['buy cheese', 'buy milk due 8/31/2017'])

app.listen(3002)
