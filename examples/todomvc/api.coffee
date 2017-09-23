class Api
  HOST = 'http://127.0.0.1:3000'

  list: -> @get('/entries')
  
  get: (path) ->
    try
      res = await fetch("#{HOST}#{path}")
      await res.json()
    catch e
      console.error e

export default new Api
