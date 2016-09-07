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
#   hubot salt <apply> <state_name> to <minion> - Executing a state or formula on a specific minion
#
# Notes:
#   Salt REST API needs to be up and running
#   <https://docs.saltstack.com/en/latest/ref/netapi/all/salt.netapi.rest_cherrypy.html>
#
# Author:
#   Mostafa Hussein[@<mostafa.hussein91@gmail.com>]

salt_api_url = process.env.SALT_API_URL
salt_token = process.env.SALT_X_TOKEN

salt =
  commands:
    ping: "test.ping"
    apply: "state.apply"
    exec: "cmd.run"
    whois: "grains.items"

missingEnvironment = (msg) ->
  missingData = false
  unless salt_api_url?
    msg.send "You need to set SALT_API_URL"
    missingData |= true
  unless salt_token?
    msg.send "You need to set SALT_X_TOKEN"
    missingData |= true
  missingData

wrongCommand = (msg) ->
  undefinedCommand = false
  unless salt.commands[msg.match[1].trim()]?
    msg.send "Sorry, I don't understand this command: " + msg.match[1].trim()
    undefinedCommand |= true
  undefinedCommand

module.exports = (robot) ->

  saltApiReq = (data, callback) ->
    process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"
    robot.http(salt_api_url)
      .headers('Content-Type': 'application/json', 'X-Auth-Token': salt_token)
      .post(data) (err, res, body) ->
        if res.statusCode == 401
          callback("Unauthorized Request, This might be a permission issue or the Token is expired.")
        else
          try
            jsonBody = JSON.parse(body)
            textBody = JSON.stringify(jsonBody, null, 2)
            callback(textBody)

  robot.respond /salt\s+([\w-.]+)\s+([\w-.]+)$/i, (msg) ->
    unless (missingEnvironment msg)
      unless (wrongCommand msg)
        salt_function = salt.commands[msg.match[1].trim()]
        salt_target = msg.match[2].trim()
        if salt_target == 'all'
          salt_target = '*'

        data = JSON.stringify({
          client: 'local',
          tgt: salt_target,
          fun: salt_function,
        })

        saltApiReq data, (result) ->
          msg.send result

  robot.respond /salt\s+([\w-.]+)\s+([\w-.]+)\s+to\s+(.+)/i, (msg) ->
    unless (missingEnvironment msg)
      unless (wrongCommand msg)
        salt_function = salt.commands[msg.match[1].trim()]
        salt_args = msg.match[2].trim()
        salt_target = msg.match[3].trim()
        if salt_target == 'all'
          salt_target = '*'

        data = JSON.stringify({
          client: 'local',
          tgt: salt_target,
          fun: salt_function,
          arg: salt_args
        })

        saltApiReq data, (result) ->
          msg.send result
