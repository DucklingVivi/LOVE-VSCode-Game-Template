local components = {}

components.emitter = require("src.component.emitter")

components.solid = require("src.component.solid")

components.receiver = require("src.component.receiver")

components.mirror = require("src.component.mirror")

components.rotatable = require("src.component.rotatable")

components.automaton = require("src.component.automaton_component")

components.dirtyable = require("src.component.dirtyable")

return components
