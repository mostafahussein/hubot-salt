# hubot-salt

[![Version npm](https://img.shields.io/npm/v/hubot-salt.svg?style=flat-square)](https://www.npmjs.com/package/hubot-salt)
[![npm Downloads](https://img.shields.io/npm/dm/hubot-salt.svg?style=flat-square)](https://www.npmjs.com/package/hubot-salt)

A hubot script for managing salt minions

See [`src/salt.coffee`](src/salt.coffee) for full documentation.

## Installation

Make sure that you have [Salt REST CHERRYPY](https://docs.saltstack.com/en/latest/ref/netapi/all/salt.netapi.rest_cherrypy.html) up and running first.

In hubot project repo, run:

`npm install hubot-salt --save`

Then add **hubot-salt** to your `external-scripts.json`:

```json
["hubot-salt"]
```

## Sample Interaction

### Ping a minion

```
user1>> hubot salt ping minion_001
hubot>> {
  "return": [
    {
      "minion_001": true
    }
  ]
}
```

### Execute a state on a minion

```
user1>> hubot, salt apply screen-formula to minion_001
hubot>> {
  "return": [
    {
      "minion_001": {
        "pkg_|-install_screen_|-screen_|-installed": {
          "comment": "Package screen is already installed",
          "name": "screen",
          "start_time": "05:55:03.835201",
          "result": true,
          "duration": 28456.433,
          "__run_num__": 0,
          "changes": {}
        }
      }
    }
  ]
}
```
