express = require 'express'
routes  = require './routes'
api     = require './routes/api'
http    = require 'http'
path    = require 'path'
bouncer = require './lib/bouncer'

app = express()

app.set 'port', process.env.PORT || 3000
app.use express.cookieParser(process.env.USER_COOKIE_SECRET)
app.use express.cookieSession
  secret: process.env.COOKIE_SESSION_SECRET
  cookie:
    path: '/'
    signed: true
    httpOnly: true
    maxAge: null
app.use bouncer.bouncer
app.use express.favicon()
app.use express.logger 'dev'
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, 'public'))

if 'development' == app.get 'env'
  app.use express.errorHandler()

app.get '/', routes.index

app.get     '/api/*', api.api
app.post    '/api/*', api.api
app.put     '/api/*', api.api
app.delete  '/api/*', api.api

app.get '/login', (req, res) -> res.redirect "/auth/#{process.env.OAUTH_PROVIDER_NAME}"
app.get '/logout', bouncer.logout
app.get "/auth/#{process.env.OAUTH_PROVIDER_NAME}", bouncer.authenticate
app.get "/auth/#{process.env.OAUTH_PROVIDER_NAME}/callback", bouncer.callback

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"
