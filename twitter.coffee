querystring = require 'querystring'
request = require 'request'

class Twitter
  APIBase: 'https://api.twitter.com/1.1/'
  streamBase: 'https://stream.twitter.com/1.1/'
  uploadBase: 'http://upload.twitter.com/1.1/'

  toArray = (args) -> Array.prototype.slice.call args

  constructor: (@config = {}) ->
    @get = -> @twitter.apply this, [@APIBase, 'GET'].concat toArray arguments
    @post = -> @twitter.apply this, [@APIBase, 'POST'].concat toArray arguments
    @stream = -> @twitter.apply this, [@streamBase].concat toArray arguments
    @stream.get = -> @twitter.apply this, [@streamBase, 'GET'].concat toArray arguments
    @stream.post = -> @twitter.apply this, [@streamBase, 'POST'].concat toArray arguments
    @upload = -> @twitter.apply this, [@uploadBase].concat toArray arguments

  twitter: (baseUrl, method, account, resource, params, callback) ->
    paramString = querystring.stringify(params).replace(/\!/g, '%21').replace(/\'/g, '%27').replace(/\(/g, '%28').replace(/\)/g, '%29').replace(/\*/g, '%2A')
    # f*cking twitter implementation
    request
      url: baseUrl + resource + '.json' + '?' + paramString
      oauth:
        consumer_key: @config.oauth.consumer_key
        consumer_secret: @config.oauth.consumer_secret
        token: @config.oauth[account].oauth_token
        token_secret: @config.oauth[account].oauth_token_secret
      json: true
      method: method
    , callback

  formUpload: (baseUrl, account, resource, formData, callback) ->
    request
      url: baseUrl + resource + '.json'
      oauth:
        consumer_key: @config.oauth.consumer_key
        consumer_secret: @config.oauth.consumer_secret
        token: @config.oauth[account].oauth_token
        token_secret: @config.oauth[account].oauth_token_secret
      json: true
      method: 'POST'
      formData: formData
    , callback

module.exports = Twitter
