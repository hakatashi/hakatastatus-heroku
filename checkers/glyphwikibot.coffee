module.exports = (twitter, done) ->
  twitter.get 'hakatastatus', 'statuses/user_timeline',
    screen_name: 'glyphwikibot'
  , (error, response, data) ->
    if error
      return done null, new Error 'Errored on accessing twitter'
    if response.statusCode isnt 200
      return done null, new Error "Twitter responded with status code #{response.statusCode}"

    lastCreate = new Date data[0]?.created_at

    console.log 'Glyphwikibot: ' + JSON.stringify data

    # Check if the last tweet is posted after 1 hour ago
    if lastCreate < new Date() - 1 * 60 * 60 * 1000
      return done null, new Error 'Glyphwikibot is dead!'

    return done null, null
