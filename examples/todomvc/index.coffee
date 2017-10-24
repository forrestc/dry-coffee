webpack = require('webpack')
WebpackDevServer = require('webpack-dev-server')
config = require('./webpack.config')

opts =
  publicPath: config.output.publicPath
  hot: true
  historyApiFallback: true

server = new WebpackDevServer webpack(config), opts
server.listen 3001, '127.0.0.1', (err, result) ->
  console.log(err) if (err)

  console.log('Listening at 127.0.0.1:3001')
