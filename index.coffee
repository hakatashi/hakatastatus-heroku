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
  twitter.post 'hakatastatus', 'statuses/update',
    status: "[Status Report #{new Date().toLocaleString()}]\n#{text}"[...140]

checkers = ['glyphwikibot']

async.map checkers, (checkerName, done) ->
  checker = require "./checkers/#{checkerName}"
  checker twitter, done
, (error, statuses) ->

  return tweet('@hakatashi Status Monitor crached!') if error

  everythingIsOperatinal = yes
  for status, index in statuses
    if status
      checker = checkers[index]
      tweet "#{checker}: @hakatashi #{status.message}"
      everythingIsOperatinal = no

  if everythingIsOperatinal
    tweet 'Everything is operational!'

  return
