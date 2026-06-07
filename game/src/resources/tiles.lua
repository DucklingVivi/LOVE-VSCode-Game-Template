return function(resources, tile_builder)
	tile_builder(1,"Debug4"):build()
	tile_builder(2,"Debug4"):color(1,0,0):build()
	tile_builder(3,"Debug4"):color(0,1,0):build()
	tile_builder(4,"Debug4"):color(0,0,1):build()
	tile_builder(5,"Debug4"):color(1,1,0):build()
	tile_builder(6,"Debug4"):color(1,0,1):build()
	tile_builder(7,"Debug4"):color(0,1,1):build()
	tile_builder(8,"Debug4"):color(0.5,0.5,0.5):build()
	tile_builder(9,"Debug4"):color(1,0.5,0):build()
	tile_builder(10,"Debug4"):color(0.5,1,0):build()


	-- Emitter
	tile_builder(11,"emitter")
	:color(.5,1,0)
	:with_component(resources.components.dirtyable)
	:with_component(resources.components.emitter)
	:with_component(resources.components.rotatable)
	:with_component(resources.components.emit_constant_signal)
	:build()


	-- Mirror
	tile_builder(12,"mirror")
	:color(0.85,0.85,1)
	:with_component(resources.components.mirror)
	:with_component(resources.components.rotatable)
	:build()



	-- Receiver
	tile_builder(13,"emitter")
	:color(0,1,1)
	:with_component(resources.components.solid)
	:with_component(resources.components.receiver)
	:with_component(resources.components.rotatable)
	:build()

	tile_builder(14,"automaton")
	:color(1,0.5,1)
	:with_component(resources.components.dirtyable)
	:with_component(resources.components.automaton)
	:with_component(resources.components.solid)
	:with_component(resources.components.receiver)
	:with_component(resources.components.rotatable)
	:with_component(resources.components.emitter)
	:build()

	tile_builder(15,"multitile")
	:color(1,1,1)
	:with_component(resources.components.dirtyable)
	:with_component(resources.components.multitile)
	:with_component(resources.components.solid)
	:build()

	tile_builder(16,"emitter") --Connector
	:color(1,1,0)
	:with_component(resources.components.connector)
	:with_component(resources.components.rotatable)
	:build()

	tile_builder(17,"Debug4") --Multiblock core
	:color(1,0.5,0)
	:with_component(resources.components.dirtyable)
	:with_component(resources.components.multiblock_core)
	:build()

end
