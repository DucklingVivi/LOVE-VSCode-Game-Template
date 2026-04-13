local components = {}

components.emitter = require("src/emitter")(1, 4)

components.emitterup = require("src/emitter")(1, 2)


components.mirror = require("src/mirror")


return components
