request = require 'request'

module.exports = (twitter, done) ->
  request.get
    url: 'http://feed.hakatashi.com/qiita.atom'
  , (error, response, body) ->
    if error or response.statusCode isnt 200
      return done null, new Error 'feed.hakatashi.com/qiita.atom is down!'

    return done null
