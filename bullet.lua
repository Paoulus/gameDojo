local bullet = {}

function bullet:new(pos_x,pos_y)
	bulletDirection.x = pos_x - love.mouse.getX() 
	bulletDirection.y = pos_y - love.mouse.getY() 

	bulletDirection:normalizeInplace()
	bulletDirection = bulletDirection * -25

	--initialization
	self.body = love.physics.newBody(world,pos_x + 50,pos_y + 50,"dynamic")
	self.sprite = love.graphics.newImage("Textures/bullet_sprite.png")
	self.shape = love.physics.newRectangleShape(1,3)
	self.fixture = love.physics.newFixture(self.body,self.shape)

	self.body:setAngle(bulletDirection:angleTo() + 1.5)

	--change this later 
	self.body:applyLinearImpulse(bulletDirection.x,bulletDirection.y)
	return self
end

function bullet:draw()
	love.graphics.draw(self.sprite,self.body:getX(),self.body:getY(),self.body:getAngle(),0.16,0.16)
end

return bullet