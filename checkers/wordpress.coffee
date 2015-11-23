request = require 'request'
xml2js = require 'xml2js'
moment = require 'moment-timezone'

module.exports = (twitter, done) ->
  request 'https://hakatashi.wordpress.com/feed/atom/', (error, response, body) ->
    xml2js.parseString body.toString(), (error, data) ->
      if error then return done null, new Error 'Errored when parsing Atom feed'

      now = moment.tz Date.now(), 'Asia/Tokyo'
      todayMeanTime = now.clone().startOf('day').add 23, 'hours'

      if todayMeanTime < now
        meanTime = now.clone().startOf('day').add 18, 'hours'
      else
        meanTime = now.clone().startOf('day').subtract 6, 'hours'

      latestUpdate = data.feed?.entry?[0]?.updated?[0]
      if latestUpdate is undefined then return done null, new Error "Latest entry not found"

      latestUpdateMoment = moment.tz latestUpdate, 'Asia/Tokyo'
      if latestUpdateMoment < meanTime then return done null, new Error 'DO Write Today\'s Diary!!!!'

      return done null
