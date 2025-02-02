pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
size = 4
sx = 112
sy = 0

frame_counter = 0
move_delay = 5

score = 0

function _init()
	snake = {
		direction = 0,
		speed = size,
		parts = {
			{ x = sx, y = sy },
			{ x = sx + size, y = sy },
			{ x = sx + size * 2, y = sy },
		}
	}
	food = {
		x = 16 * size,
		y = 16 * size,
	}
end

function update_head(head)
	if snake.direction == 3 then
		head.y += snake.speed
	end
	if snake.direction == 2 then
		head.y -= snake.speed
	end
	if snake.direction == 1 then
		head.x += snake.speed
	end
	if snake.direction == 0 then
		head.x -= snake.speed
	end
end

function check_collision()
	local head = snake.parts[1]
	return head.x == food.x and head.y == food.y
end

function _update()
	frame_counter += 1

	local new_dir = snake.direction
	if btn(3) and snake.direction ~= 2 then new_dir = 3 end
	if btn(2) and snake.direction ~= 3 then new_dir = 2 end
	if btn(1) and snake.direction ~= 0 then new_dir = 1 end
	if btn(0) and snake.direction ~= 1 then new_dir = 0 end
	snake.direction = new_dir

	if frame_counter >= move_delay then
		frame_counter = 0

		local ox = 0
		local oy = 0
		for i = 1, #snake.parts do
			local part = snake.parts[i]
			if i == 1 then
				ox = part.x
				oy = part.y
				update_head(part)
			else
				local x = part.x
				local y = part.y
				part.x = ox
				part.y = oy
				ox = x
				oy = y
			end
		end
	end

	if check_collision() then
		score += 1;
		food.x = flr(rnd(32)) * size
		food.y = flr(rnd(32)) * size

		local last_part = snake.parts[#snake.parts]
		local new_part = {
			x = last_part.x,
			y = last_part.y
		}
		add(snake.parts, new_part)
		sfx(0)
	end
end

function _draw()
	cls()
	sspr(18, 2, 4, 4, food.x, food.y)
	for i = 1, #snake.parts do
		local part = snake.parts[i]
		sspr(10, 2, 4, 4, part.x, part.y)
	end
	cursor(2 * size, 2 * size)
	print("score: "..score)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000077770000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000077770000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000077770000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000077770000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000000000000000505005050050500505005050050500505005050050500505007050090500a0500a0500a0500a0500a05000000000000000000000000000000000000000000000000000000000000000000
