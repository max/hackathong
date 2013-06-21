OAuthClient = require './oauth-client'
encryptor   = require './encryptor'

module.exports.bouncer = (req, res, next) ->
  if req.session.user_session || ["/auth/#{process.env.OAUTH_PROVIDER_NAME}", "/auth/#{process.env.OAUTH_PROVIDER_NAME}/callback", '/login'].indexOf(req.path) >= 0
    next()
  else
    req.session.redirect_path = req.url
    res.redirect "/auth/#{process.env.OAUTH_PROVIDER_NAME}"

module.exports.authenticate = (req, res, next) ->
  oauth = new OAuthClient
  res.redirect oauth.getAuthorizeUrl(response_type: 'code')

module.exports.logout = (req, res, next) ->
  req.session = null
  res.redirect "#{process.env.AUTH_URL}/logout"

module.exports.callback = (req, res, next) ->
  oauth = new OAuthClient
  oauth.getOAuthAccessToken req.query['code'], null, (error, access_token, refresh_token, result) ->
    res.redirect '/login' if error

    user_session = JSON.stringify(access_token: access_token)
    req.session.user_session = encryptor.encrypt(user_session)

    if !req.session.redirect_path || ['/login', "/auth/#{process.env.OAUTH_PROVIDER_NAME}"].indexOf(req.session.redirect_path) >= 0
      redirect_path = '/'
    else
      redirect_path = req.session.redirect_path

    req.session.redirect_path = null
    res.redirect redirect_path
