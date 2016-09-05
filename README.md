# hubot-salt

A hubot script for managing salt minions

See [`src/salt.coffee`](src/salt.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-salt --save`

Then add **hubot-salt** to your `external-scripts.json`:

```json
["hubot-salt"]
```

## Sample Interaction

```
user1>> hubot salt ping minion_001
hubot>> Shell: {
  "return": [
    {
      "minion_001": true
    }
  ]
}
```
