local components = {}

components.emitter = require("src/emitter")(1, 4)

components.solid = require("src/solid")

components.receiver = require("src/receiver")

components.mirror = require("src/mirror")

components.rotatable = require("src/rotatable")


return components
