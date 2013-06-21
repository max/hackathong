crypto = require 'crypto'

exports.encrypt = (value) ->
  key       = process.env.USER_SESSION_ENCRYPTION_SECRET
  iv        = crypto.randomBytes(32)
  cipher    = crypto.createCipher 'aes256', key, iv
  encrypted = cipher.update(value, 'utf8', 'base64') + cipher.final('base64')

exports.decrypt = (data) ->
  key       = process.env.USER_SESSION_ENCRYPTION_SECRET
  decipher  = crypto.createDecipher 'aes256', key
  decrypted = decipher.update(data, 'base64', 'utf8') + decipher.final('utf8')
