pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
size = 4
sx = 16 * size
sy = 8 * size

frame_counter = 0
move_delay = 3
game_over = false

score = 0

function _init()
	snake = {
		allow_move = true,
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
	if snake.direction == 0 then
		head.x -= snake.speed
	end
	if snake.direction == 1 then
		head.x += snake.speed
	end
	if snake.direction == 2 then
		head.y -= snake.speed
	end
	if snake.direction == 3 then
		head.y += snake.speed
	end
end

function check_collision(a, b)
	return a.x == b.x and a.y == b.y
end

function every(table, func)
	for i = 1, #table do
		if not func(table[i]) then
			return false
		end
	end
	return true
end

function spawn_food()
	local x = flr(rnd(31))
	local y = flr(rnd(31))
	if x == 0 then x += size end
	if y == 0 then y += size end
	x *= size
	y *= size
	local do_not_collide = true
	repeat
		do_not_collide = every(snake.parts, function (part)
			return part.x == x and part.y == y
		end)
	until not do_not_collide
	food.x = x
	food.y = y
end

function _update()
	if not game_over then
		frame_counter += 1

		local new_dir = snake.direction
		if btn(0) and snake.direction ~= 1 and snake.allow_move then
			new_dir = 0
			snake.allow_move = false
		end
		if btn(1) and snake.direction ~= 0 and snake.allow_move then
			new_dir = 1
			snake.allow_move = false
		end
		if btn(2) and snake.direction ~= 3 and snake.allow_move then
			new_dir = 2
			snake.allow_move = false
		end
		if btn(3) and snake.direction ~= 2 and snake.allow_move then
			new_dir = 3
			snake.allow_move = false
		end
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
					snake.allow_move = true
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

		local head = snake.parts[1]

		if head.x < size or head.x > 127 - size or head.y < size or head.y > 127 - size then
			game_over = true
		end

		if check_collision(head, food) then
			score += 1
			spawn_food()

			local last_part = snake.parts[#snake.parts]
			local new_part = {
				x = last_part.x,
				y = last_part.y
			}
			add(snake.parts, new_part)
			if score % 5 ~= 0 then
				sfx(0)
			else
				sfx(1)
			end
		end

		for i = 2, #snake.parts do
			local part = snake.parts[i]
			if check_collision(head, part) then
				game_over = true
				break
			end
		end
	end
end

function _draw()
	cls()
	if game_over then
		print("game over", 12 * size, 16 * size)
	else
		line(0, 0, 127, 0, 7)
		line(0, 0, 0, 127, 7)
		line(0, 127, 127, 127, 7)
		line(127, 0, 127, 127, 7)

		local offset = size - 1
		line(offset, offset, 127 - offset, offset, 7)
		line(offset, offset, offset, 127 - offset, 7)
		line(offset, 127 - offset, 127 - offset, 127 - offset, 7)
		line(127 - offset, offset, 127 - offset, 127 - offset, 7)

		sspr(18, 2, 4, 4, food.x, food.y)
		for i = 1, #snake.parts do
			local part = snake.parts[i]
			sspr(10, 2, 4, 4, part.x, part.y)
		end
		print("score: "..score, 2 * size, 2 * size)
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000033000000bb00000363000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000003333000084b80008b33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000003333000088880000b33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000330000008800000363000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000000000000000505005050050500505005050050500505005050050500505007050090500a0500a0500a050030000000000000000000000000000000000000000000000000000000000000000000000000
000100000750000150021500415007150091500b1500c1500e1501015008500075000550002500021000110001100001000010009100091000a1000b1000c1000d1000e1000f1001110013100000000000000000
__music__
04 41424344

