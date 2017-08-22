webpack = require('webpack')
WebpackDevServer = require('webpack-dev-server')
config = require('./webpack.config')

opts =
  publicPath: config.output.publicPath
  hot: true
  historyApiFallback: true

server = new WebpackDevServer webpack(config), opts
server.listen 3001, 'localhost', (err, result) ->
  console.log(err) if (err)

  console.log('Listening at localhost:3001')
