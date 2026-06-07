local rendering = {}


rendering.atlasSpriteBatch = love.graphics.newSpriteBatch(Resources.atlas, 500)
rendering.worldCanvas = love.graphics.newCanvas()
rendering.bottomEdge = 0
rendering.topEdge = 0
rendering.leftEdge = 0
rendering.rightEdge = 0


return rendering
