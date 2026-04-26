local components = {}

components.emitter = require("src.component.emitter")(4)

components.solid = require("src.component.solid")

components.receiver = require("src.component.receiver")

components.mirror = require("src.component.mirror")

components.rotatable = require("src.component.rotatable")


return components
