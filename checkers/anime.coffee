request = require 'request'

module.exports = (twitter, done) ->
  request.get
    url: 'https://anime.hakatashi.com/'
    auth:
      user: 'sunpro'
      pass: process.env.ANIME_PASSWORD
  , (error, response, body) ->
    if error or response.statusCode isnt 200
      return done null, new Error 'anime.hakatashi.com is down!'

    return done null
