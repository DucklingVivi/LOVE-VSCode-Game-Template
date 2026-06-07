local components = {}

Component = require("src.component.component")

components.emitter = require("src.component.emitter")

components.solid = require("src.component.solid")

components.receiver = require("src.component.receiver")

components.mirror = require("src.component.mirror")

components.rotatable = require("src.component.rotatable")

components.automaton = require("src.component.automaton_component")

components.dirtyable = require("src.component.dirtyable")

components.emit_constant_signal = require("src.component.emit_constant")(Signal())

components.multitile = require("src.component.multitile")

components.connector = require("src.component.connector")

components.multiblock_core = require("src.component.multiblock_core")

return components
