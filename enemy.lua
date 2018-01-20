function enemy:new()
	local e = {}
	e.body = love.physics.newBody(world,0,0)
	e.shape = love.physics.newRectangleShape(4,4)
	e.fixture = love.physics.newFixture(e.body,e.fixture)
	e.sprite = love.graphics.newImage("Textures/enemy.png")

	setmetatable(e,self)
end

function enemy:move(dx,dy)
	e.body.setX(self.body:getX() + dx)
	e.body.setY(self.body:getY() + dy)
end

function enemy:setPosition(x,y)
	e.body.setX(x)
	e.body.setY(y)
end

function enemy:draw()
	love.graphics.draw(self.sprite,self.body:getX(),self.body:getY(),self.body:getAngle(),0.4,0.4)
end