table = require("table")

bullets = {}
world = {}

bullet_class = {}

function bullet_class:draw()
	love.graphics.draw(self.sprite,self.body:getX(),self.body:getY(),0,0.2,0.2)
end

--get the position of the mouse
--get the direction from the player to the mouse
--use that as the impulse vector
function new_bullet(pos_x,pos_y)
	local o = {};
	
	--initialization
	o.body = love.physics.newBody(world,pos_x,pos_y,"dynamic")
	o.sprite = love.graphics.newImage("bullet_sprite.png")
	o.shape = love.physics.newRectangleShape(5,5)
	o.fixture = love.physics.newFixture(o.body,o.shape)

	setmetatable(o, {__index = bullet_class})
	
	--change this later 
	o.body:applyLinearImpulse(1,1)

	return o;
end


function love.load()
	circle = love.graphics.newImage("CompletedBlueGuy.png");
	x = 0;  --global variable
	y = 0;
	speed = 300;

	shootingTimer = 0;
	
	--no gravity in a top view of the world (the gravity is along the Z axis)
	world = love.physics.newWorld(0, 0, true)
end


function love.update(dt)
	world:update(dt)
		
	--standard WASD movement
	if love.keyboard.isDown("w") then
	 y = y - (speed * dt)
	end
	if love.keyboard.isDown("d") then
	 x = x + (speed * dt)
	end
	if love.keyboard.isDown("s") then
	 y = y + (speed * dt)
	end
	if love.keyboard.isDown("a") then
	 x = x - (speed * dt)
	end
	
	if love.mouse.isDown(1) then
		--spawn bullet amd insert it in the table of all bullets
		shootingTimer = shootingTimer + love.timer.getDelta()
		if(shootingTimer < 1) then
			table.insert(bullets,new_bullet(x,y))
			shootingTimer = 0
		end
	else 
		shootingTimer = 0;
	end
end

function love.draw()
	--rudimental camera; transalte the coordinates to keep the player in center
	width, height = love.graphics.getDimensions()
	local xTranslation = x - width / 2 ;
	local yTranslation = y - height / 2;
	love.graphics.translate(-xTranslation,-yTranslation)

	--draw the player
	love.graphics.draw(circle,x,y,0,0.6)
	
	--draw all the bullets
	for _,k in pairs(bullets) do 
		k:draw();
	end
end