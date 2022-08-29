Twitter = require './twitter'
async = require 'async'

twitter = new Twitter
  oauth:
    consumer_key: process.env.CONSUMER_KEY
    consumer_secret: process.env.CONSUMER_SECRET
    hakatastatus:
      oauth_token: process.env.OAUTH_TOKEN
      oauth_token_secret: process.env.OAUTH_TOKEN_SECRET

tweet = (text) ->
  console.log "Tweet: #{text}"
  twitter.post 'hakatastatus', 'statuses/update',
    status: "[Status Report #{new Date().toLocaleString()}]\n#{text}"[...140]

emoji = (status) ->
  if status is 'success'
    emojies = [
      '✔️' # Heavy Check Mark
      '☑️' # Ballot Box With Check
      '👌' # Ok Hand Sign
      '🙆' # Face With OK Gesture
      '👍' # Thumbs Up Sign
      '🆗' # Squared OK
      '⭕' # Heavy Large Circle
      '🙋' # Happy Person Raising One Hand
      '😍' # Smiling Face With Heart-Shaped Eyes
      '😊' # Smiling Face With Smiling Eyes
    ]
  else if status is 'failed'
    emojies = [
      '👎' # Thumbs Down Sign
      '🆖' # Squared NG
      '👊' # Fisted Hand Sign
      '🙅' # Face With No Good Gesture
      '❌' # Cross Mark
      '🙎' # Person With Pouting Face
      '😡' # Pouting Face
      '😱' # Face Screaming In Fear
      '😵' # Dizzy Face
    ]
  else emojies = []

  return emojies[Math.floor Math.random() * emojies.length]

checkers = ['glyphwikibot']

async.map checkers, (checkerName, done) ->
  checker = require "./checkers/#{checkerName}"
  checker twitter, done
, (error, statuses) ->

  return tweet("@hakatashi Status Monitor crached! #{emoji 'failed'}") if error

  everythingIsOperatinal = yes
  for status, index in statuses
    if status
      checker = checkers[index]
      tweet "#{emoji 'failed'}#{checker}: @hakatashi #{status.message}"
      everythingIsOperatinal = no

  if everythingIsOperatinal
    tweet "#{emoji 'success'} Everything is operational!"

  return
