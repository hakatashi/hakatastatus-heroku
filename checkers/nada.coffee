request = require 'request'

module.exports = (twitter, done) ->
  request 'https://nada.hakatashi.com/', (error, response, body) ->
    if error or response.statusCode isnt 200
      return done null, new Error 'nada.hakatashi.com is dead!'

    return done null
