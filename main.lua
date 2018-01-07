table = require("table")
camera = require("Libraries/camera")
vector = require("Libraries/vector")
tilemap = require("tilemap")

bullets = {}
world = {}
player = {}

bullet_class = {}
enemy = {}

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


function bullet_class:draw()
	love.graphics.draw(self.sprite,self.body:getX(),self.body:getY(),self.body:getAngle(),0.16,0.16)
end

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

function new_bullet(pos_x,pos_y)
	local o = {};

	local x = player.body:getX()
	local y = player.body:getY()

	bulletDirection.x = player.body:getX() - love.mouse.getX()
	bulletDirection.y = player.body:getY() - love.mouse.getY()

	bulletDirection:normalizeInplace()
	bulletDirection = bulletDirection * -25

	--initialization
	o.body = love.physics.newBody(world,x + 50,y + 50,"dynamic")
	o.sprite = love.graphics.newImage("Textures/bullet_sprite.png")
	o.shape = love.physics.newRectangleShape(1,3)
	o.fixture = love.physics.newFixture(o.body,o.shape)

	setmetatable(o, {__index = bullet_class})
	
	o.body:setAngle(bulletDirection:angleTo() + 1.5)


	--change this later 
	o.body:applyLinearImpulse(bulletDirection.x,bulletDirection.y)

	return o;
end

function love.load()
	speed = 300;

	shootingTimer = 0;
	timeBetweenShots = 0.4
	
	--no gravity in a top view of the world (the gravity is along the Z axis)
	world = love.physics.newWorld(0, 0, true)

	cam = camera.new(x,y)

	--vector used for bullet computation
	bulletDirection = vector:new(1,1)


	player.sprite = love.graphics.newImage("Textures/CompletedBlueGuy.png")
	player.body = love.physics.newBody(world,0,0,"kinematic")
	player.shape = love.physics.newRectangleShape(10,10)
	player.fixture = love.physics.newFixture(player.body,player.shape)

	player:setPosition(0,0)
end

function love.update(dt)
	world:update(dt)
		
	local dx = player.body:getX() - cam.x 
	local dy = player.body:getY() - cam.y
	cam:move(dx,dy)

	--standard WASD movement
	if love.keyboard.isDown("w") then
	   player:move(0,-speed * dt)
	end
	if love.keyboard.isDown("d") then
	   player:move(speed * dt,0)
	end
	if love.keyboard.isDown("s") then
	   player:move(0,speed * dt)
	end
	if love.keyboard.isDown("a") then
	   player:move(-speed * dt,0)
	end
	
	--shooting 
	if love.mouse.isDown(1) then
			--spawn bullet amd insert it in the table of all bullets
		if shootingTimer == 0 then
			table.insert(bullets,new_bullet(x,y))
			shootingTimer = shootingTimer + love.timer.getDelta()
		else
			shootingTimer = shootingTimer + love.timer.getDelta()
			if(shootingTimer > timeBetweenShots) then
				table.insert(bullets,new_bullet(x,y))
				shootingTimer = 0
			end
		end
	else
		shootingTimer = 0
	end
end

function love.draw()
	draw_map()

	--draw all the bullets
	for _,k in pairs(bullets) do 
		k:draw();
	end
	
	--draw the player
	player:draw()
end