request = require 'request'
xml2js = require 'xml2js'
moment = require 'moment-timezone'

hour = 60 * 60 * 1000
day = 24 * hour

module.exports = (twitter, done) ->
  request 'https://hakatashi.wordpress.com/feed/atom/', (error, response, body) ->
    xml2js.parseString body.toString(), (error, data) ->
      if error then return done null, new Error 'Errored when parsing Atom feed'

      now = moment.tz Date.now(), 'Asia/Tokyo'
      todayMeanTime = now.clone().startOf('day').add 23, 'hours'
      yesterdayMeanTime = todayMeanTime.clone().subtract 1, 'day'

      if todayMeanTime < now
        meanTime = todayMeanTime
      else
        meanTime = yesterdayMeanTime

      latestUpdate = data.feed?.entry?[0]?.updated?[0]
      if latestUpdate is undefined then return done null, new Error "Latest entry not found"

      latestUpdate = moment.tz latestUpdate, 'Asia/Tokyo'
      if latestUpdate < meanTime then return done null, new Error 'DO Write Today\'s Diary!!!!'

      return done null
