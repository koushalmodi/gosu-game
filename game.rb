require 'gosu'

class Player
  attr_reader :x, :y, :width, :height

  def initialize
    @x = 320
    @y = 400
    @width = 50
    @height = 50
    @speed = 5
  end

  def move_left
    @x -= @speed if @x > 0
  end

  def move_right
    @x += @speed if @x < 640 - @width
  end

  def draw
    Gosu.draw_rect(@x, @y, @width, @height, Gosu::Color::BLUE, 1)
  end
end

class Star
  attr_reader :x, :y, :size

  def initialize
    @x = rand(640)
    @y = 0
    @size = 20
    @speed = rand(2..5)
  end

  def fall
    @y += @speed
  end

  def off_screen?
    @y > 480
  end

  def draw
    Gosu.draw_rect(@x, @y, @size, @size, Gosu::Color::YELLOW, 1)
  end
end

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Ruby Gosu Game - Catch the Stars!"
    
    @player = Player.new
    @stars = []
    @score = 0
    @font = Gosu::Font.new(20)
  end

  def update
    @player.move_left if Gosu.button_down?(Gosu::KB_LEFT)
    @player.move_right if Gosu.button_down?(Gosu::KB_RIGHT)

    # Generate new stars randomly
    @stars.push(Star.new) if rand(100) < 2

    @stars.each(&:fall)
    @stars.reject! do |star|
      if (star.x - @player.x).abs < 30 && (star.y - @player.y).abs < 30
        @score += 10
        true
      elsif star.off_screen?
        true
      else
        false
      end
    end
  end

  def draw
    @player.draw
    @stars.each(&:draw)
    @font.draw_text("Score: #{@score}", 10, 10, 1, 1, 1, Gosu::Color::WHITE)
  end
end

GameWindow.new.show
