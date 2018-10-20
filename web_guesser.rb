# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' # Automatically reloads the server when changed
# optionally you can require the gem 'thin' for a rack webserver

class Game
  MAX_GUESSES = 5

  attr_accessor :guesses
  attr_reader :secret_num, :has_reset, :cheat, :won

  def initialize
    @guesses = MAX_GUESSES
    @secret_num = rand(100)
    @has_reset = false
    @cheat = false
    @won = false
  end

  def guess_logic(guess)
    return :too_high if guess > @secret_num + 5
    return :high if guess > @secret_num && guess <= @secret_num + 5
    return :correct if guess == @secret_num
    return :low if guess < @secret_num && guess >= @secret_num - 5
    return :too_low if guess < @secret_num - 5
  end

  def check_guess(how_close)
    case how_close
    when :too_high then 'Way too high!'
    when :high then 'Too high!'
    when :correct then @won = true && 'You got it right! The game will reset!'
    when :low then 'Too low!'
    when :too_low then 'Way too low!'
    end
  end

  def background(how_close)
    too_high_low = %i[too_high too_low]
    return 'red' if too_high_low.include?(how_close)

    high_low = %i[high low]
    return '#F5A9A9' if high_low.include?(how_close) # light red
    return 'green' if how_close == :correct

    'white'
  end

  def too_many_guesses?(guess)
    return true if @guesses.zero? && guess != @secret_num

    false
  end

  def remove_guess
    @guesses -= 1
    @has_reset = false
    @won = false
  end

  def reset
    @has_reset = true
    @secret_num = rand(100)
    @guesses = MAX_GUESSES
    disable_cheat
  end

  def reset_message
    "You have guessed incorrectly too many times. The game has been reset and a new number generated."
  end

  def enable_cheat
    @cheat = true
  end

  def disable_cheat
    @cheat = false
  end
end

game = Game.new

# Base request to the server
get '/' do
  game.disable_cheat
  game.enable_cheat if params['cheat'] == 'true'

  game.reset if game.won
  game.remove_guess unless params['guess'].nil?


  guess = params['guess'].to_i
  game.reset if game.too_many_guesses?(guess)
  how_close = game.guess_logic(guess) unless game.has_reset
  bg_color = background(how_close)
  message = game.check_guess(how_close)


  erb :index, locals: {
    game: game,
    guess: guess,
    message: message,
    how_close: how_close,
    bg_color: bg_color
  }
end
#
# set :foo, 'bar'
# set :baz, (proc { "Hello #{foo}" })
#
# # typed in localhost:4567/foo will show 'foo is set to bar'
# get '/foo' do
#   "foo is set to #{settings.foo}"
# end
#
# # /baz will yield baz is set to bar
# get '/baz' do
#   "baz is set to #{settings.baz}"
# end
#
# # Configuring multiple settings
# set foo: 'bar', baz: (proc { "Hello #{foo}" })
