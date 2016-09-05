# Description
#   A hubot script for managing salt minions
#
# Configuration:
#   SALT_API_URL - The primary entry point to Salt's REST API
#   SALT_X_TOKEN - A session token from Salt API Login
#
# Commands:
#   hubot salt <ping> <all> - Execute test.ping on all minions
#   hubot salt <ping> <minion> - Execute test.ping on a specific minion
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Mostafa Hussein[@<mostafa.hussein91@gmail.com>]

salt_api_url = process.env.SALT_API_URL
salt_token = process.env.SALT_X_TOKEN

missingEnvironment = (msg) ->
    missingData = false
    unless salt_api_url?
      msg.send "You need to set SALT_API_URL"
      missingData |= true
    unless salt_token?
      msg.send "You need to set SALT_X_TOKEN"
      missingData |= true
    missingData

module.exports = (robot) ->
  robot.respond /salt\s+([\w-.]+)\s+(.+)/i, (msg) ->
    unless (missingEnvironment msg)
      salt_function = msg.match[1].trim()
      salt_target = msg.match[2].trim()

      if salt_function == 'ping'
        salt_function = 'test.ping'

      if salt_target == 'all'
        salt_target = '*'

      data = JSON.stringify({
        client: 'local',
        tgt: salt_target,
        fun: salt_function,
      })
      process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"
      robot.http(salt_api_url)
        .headers('Content-Type': 'application/json', 'X-Auth-Token': salt_token)
        .post(data) (err, res, body) ->
          if res.statusCode == 401
            msg.reply "Unauthorized Request, This might be a permission issue or the Token is expired."
          else
            try
              jsonBody = JSON.parse(body)
              textBody = JSON.stringify(jsonBody, null, 2)
              msg.reply textBody
