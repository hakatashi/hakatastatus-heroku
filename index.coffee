Twitter = require './twitter'

twitter = new Twitter
  oauth:
    consumer_key: process.env.CONSUMER_KEY
    consumer_secret: process.env.CONSUMER_SECRET
    hakatastatus:
      oauth_token: process.env.OAUTH_TOKEN
      oauth_token_secret: process.env.OAUTH_TOKEN_SECRET

twitter.post 'hakatastatus', 'statuses/update',
  status: "Reported in #{new Date().toLocaleString()}: Everything is up!"
