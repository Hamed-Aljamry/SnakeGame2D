require 'ruby2d'

set background: 'navy'
set fps_cap: 20
# Width = 640 / 20 = 32
# Height = 400 / 20 = 24

GRID_SIZE = 20
GRID_WIDTH = Window.width / GRID_SIZE
GRID_HEIGHT = Window.height / GRID_SIZE

class Snake
  attr_writer :direction
  def initialize
    @positions = [[2,0], [2,1], [2,2], [2,3]]
    @direction = 'down'
    @growing = false
  end
#heayyasdjbak
  def draw
    @positions.each do |position|
      Square.new(x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE, size: GRID_SIZE - 1, color: 'white')
    end
  end

  def move
    if !@growing
      @positions.shift
    end
    case @direction
    when 'down'
      @positions.push(new_coords(head[0], head[1] + 1))
    when 'up'
      @positions.push(new_coords(head[0], head[1] - 1))
    when 'left'
      @positions.push(new_coords(head[0] - 1, head[1]))
    when 'right'
      @positions.push(new_coords(head[0] + 1, head[1]))
    end
    @growing = false
  end

  def can_change_direction_to?(new_direction)
    case @direction
    when 'up' then new_direction != 'down'
    when 'down' then new_direction != 'up'
    when 'left' then new_direction != 'right'
    when 'right' then new_direction != 'left'
    end
  end

  def x
    head[0]
  end

  def y
    head[1]
  end

  def grow
    @growing = true
  end

  def hit_itself?
    @positions.uniq.length != @positions.length
  end

  private

  def new_coords(x, y)
    [x % GRID_WIDTH, y % GRID_HEIGHT]
  end

  def head
    @positions.last
  end
end
class Game
  def initialize
    @score = 0
    @ball_x = rand(GRID_WIDTH)
    @ball_y = rand(GRID_HEIGHT)
    @finished = false
  end

  def draw
    unless finished?
      Square.new(x: @ball_x * GRID_SIZE, y: @ball_y * GRID_SIZE, size: GRID_SIZE, color: 'yellow')
    end
    Text.new(text_message, color: 'green', x: 10, y: 10, size: 25)
  end

  def snake_hit_ball?(x, y)
    @ball_x == x && @ball_y == y
  end

  def record_hit
    @score += 1
    @ball_x = rand(GRID_WIDTH)
    @ball_y = rand(GRID_HEIGHT)
  end

  def finish
    puts 'finishing game'
    @finished = true
  end

  def finished?
    @finished
  end

  private

  def text_message
    if finished?
      "Game over! Your score was #{@score}. Press 'R' to restart."
    else
      "Score: #{@score}"
    end
  end

                    # def new_text_message
                    #   if @score >= 10
                    #     puts 'Not bad fella!, lets see if you can beat that ;)'
                    #   else
                    #     puts 'Thats it?! do better >:('
                    #   end
                    # end
end
snake = Snake.new
game = Game.new

update do
  clear
  unless game.finished?
    snake.move
  end
  snake.draw
  game.draw

  if game.snake_hit_ball?(snake.x, snake.y)
    game.record_hit
    snake.grow
  end

  game.finish if snake.hit_itself?
end

on :key_down do |event|
  if ['up','down','left','right'].include?(event.key)
    if snake.can_change_direction_to?(event.key)
      snake.direction = event.key
    end
  elsif event.key == 'r'
    snake = Snake.new
    game = Game.new
  end
end
show
#test test ets
