OAuth     = require('oauth').OAuth2

module.exports = ->
  new OAuth(
    process.env.OAUTH_ID
    process.env.OAUTH_SECRET
    process.env.OAUTH_URL
    '/oauth/authorize'
    '/oauth/token'
  )

