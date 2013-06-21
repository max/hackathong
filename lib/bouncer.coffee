HerokuOAuth = require './heroku-oauth'
encryptor   = require './encryptor'

module.exports.bouncer = (req, res, next) ->
  if req.session.user_session || ['/auth/heroku', '/auth/heroku/callback', '/login'].indexOf(req.path) >= 0
    next()
  else
    req.session.redirect_path = req.url
    res.redirect '/auth/heroku'

module.exports.authenticate = (req, res, next) ->
  oauth = new HerokuOAuth
  res.redirect oauth.getAuthorizeUrl(response_type: 'code')

module.exports.logout = (req, res, next) ->
  req.session = null
  res.redirect "#{process.env.HEROKU_AUTH_URL}/logout"

module.exports.callback = (req, res, next) ->
  oauth = new HerokuOAuth
  oauth.getOAuthAccessToken req.query['code'], null, (error, access_token, refresh_token, result) ->
    res.redirect '/login' if error

    user_session = JSON.stringify(access_token: access_token)
    req.session.user_session = encryptor.encrypt(user_session)

    if !req.session.redirect_path || ['/login', '/auth/heroku'].indexOf(req.session.redirect_path) >= 0
      redirect_path = '/'
    else
      redirect_path = req.session.redirect_path

    req.session.redirect_path = null
    res.redirect redirect_path
