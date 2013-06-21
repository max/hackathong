proxy     = require '../lib/proxy'
encryptor = require '../lib/encryptor'

exports.api = (req, res) ->
  sessionString = encryptor.decrypt(req.session.user_session)
  token = JSON.parse(sessionString).access_token
  api = proxy.init(token, req)

  method = req.method.toLowerCase()
  apiPath = req.url.slice(4, req.url.length) # 4 == '/api'

  api[method] apiPath, null, ({body, status}) ->
    res.send body, status
