express = require 'express'
routes  = require './routes'
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

app.get '/login', (req, res) -> res.redirect '/auth/heroku'
app.get '/logout', bouncer.logout
app.get '/auth/heroku', bouncer.authenticate
app.get '/auth/heroku/callback', bouncer.callback

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')}"
