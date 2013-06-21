OAuth     = require('oauth').OAuth2

module.exports = ->
  new OAuth(
    process.env.HEROKU_OAUTH_ID
    process.env.HEROKU_OAUTH_SECRET
    process.env.HEROKU_AUTH_URL
    '/oauth/authorize'
    '/oauth/token'
  )

