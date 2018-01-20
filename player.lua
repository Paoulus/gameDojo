local player = {} 

function player:new(w)
	self.body = love.physics.newBody(w,0,0,"kinematic")
	self.shape = love.physics.newRectangleShape(3,3)
	self.fixture = love.physics.newFixture(self.body,self.shape)
	self.sprite = love.graphics.newImage("Textures/CompletedBlueGuy.png")
end

function player:move(dx,dy)
	self.body:setX(self.body:getX() + dx)
	self.body:setY(self.body:getY() + dy)
end

function player:setPosition(x,y)
	self.body:setX(x)
	self.body:setY(y)
end

function player:draw()
	love.graphics.draw(self.sprite,self.body:getX(),self.body:getY(),self.body:getAngle(),0.4,0.4)
end

function player:shootAt(x,y)
end

return player