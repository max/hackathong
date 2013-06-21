https = require 'https'

class Proxy
  constructor: (@key, @req) ->

  ['get', 'post', 'put', 'delete'].forEach (method) ->
    Proxy::[method] = (path, options = {}, callback) ->
      @request method.toUpperCase(), path, options, callback

  request: (method, path, {hostname, query, headers, version} = {}, callback) ->
    headers || (headers = {})
    headers['User-Agent'] = 'hackathong/0.0.1'
    headers['Accept'] = "application/vnd.heroku+json; version=#{version || 3}"

    options =
      hostname: hostname || process.env.API_HOST
      port: 443
      path: path
      query: query || {}
      auth: ":#{@key}"
      method: method
      headers: headers

    req = https.request options, (res) =>
      buffer = ''
      res.on 'data', (data) -> buffer += data
      res.on 'end', =>
        body = JSON.parse(buffer)
        callback body: body, status: res.statusCode

    req.end()

exports.init = (key, req) ->
  new Proxy(key, req)
