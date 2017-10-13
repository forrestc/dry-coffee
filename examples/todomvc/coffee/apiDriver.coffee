class ApiDriver
  HOST = 'http://127.0.0.1:3000'

  list: -> @request('GET', '/entries')
  create: (obj) -> @request('POST', '/entries', obj)
  delete: (id) -> @request('DELETE', "/entry/#{id}")
  patch: (id, obj) -> @request('PATCH', "/entry/#{id}", obj)

  request: (method, path, obj = null) ->
    try
      opts =
        method: method
        headers:
          'Accept': 'application/json'
          'Content-Type': 'application/json'
      opts.body = JSON.stringify obj if obj

      res = await fetch("#{HOST}#{path}", opts)
      await res.json()
    catch e
      console.error e

export default new ApiDriver
