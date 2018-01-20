table = require("table")
Camera = require("Libraries/camera")
vector = require("Libraries/vector")
tilemap = require("tilemap")
bullet = require("bullet")
player = require("player")

--coderdojo's inferno 

world = {}

bullet_class = {}
enemy = {}

function love.load()
	speed = 300;
	bullets = {}
	shootingTimer = 0;
	timeBetweenShots = 0.4
	
	--no gravity in a top view of the world (the gravity is along the Z axis)
	world = love.physics.newWorld(0, 0, true)

	cam = Camera(x,y)

	--vector used for bullet computation
	bulletDirection = vector:new(1,1)

	p = player:new(world)
end

function love.update(dt)
	world:update(dt)
		
	local dx = player.body:getX() - cam.x 
	local dy = player.body:getY() - cam.y
	

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
			table.insert(bullets,bullet:new(player.body:getX(),player.body:getY()))
			shootingTimer = shootingTimer + love.timer.getDelta()
		else
			shootingTimer = shootingTimer + love.timer.getDelta()
			if(shootingTimer > timeBetweenShots) then
				table.insert(bullets,bullet:new(player.body:getX(),player.body:getY()))
				shootingTimer = 0
			end
		end
	else
		shootingTimer = 0
	end

	cam:move(dx,dy)
end

function love.draw()
	cam:attach()

	draw_map()

	--draw all the bullets
	for _,k in pairs(bullets) do 
		k:draw();
	end
	
	--draw the player
	player:draw()
	local mouseX = love.mouse:getX();
	local mouseY = love.mouse:getY();
	cam:detach()
end