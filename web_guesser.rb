# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' # Automatically reloads the server when changed

def guess_logic(guess)
  if guess > SECRET_NUMBER + 5
    :too_high
  elsif guess > SECRET_NUMBER && guess <= SECRET_NUMBER + 5
    :high
  elsif guess == SECRET_NUMBER
    :correct
  elsif guess < SECRET_NUMBER && guess >= SECRET_NUMBER - 5
    :low
  elsif guess < SECRET_NUMBER - 5
    :too_low
  end
end

def check_guess(how_close)
  case how_close
  when :too_high
    'Way too high!'
  when :high
    'Too high!'
  when :correct
    'You got it right!'
  when :low
    'Too low!'
  when :too_low
    'Way too low!'
  end
end

def background(how_close)
  too_high_low = %i[too_high too_low]
  return 'red' if too_high_low.include?(how_close)

  high_low = %i[high low]
  return '#F5A9A9' if high_low.include?(how_close) # light red
  return 'green' if how_close == :correct
end

set :secret_number, (proc { rand(100) })

SECRET_NUMBER = settings.secret_number
# Base request to server
get '/' do
  guess = params['guess'].to_i
  how_close = guess_logic(guess)
  message = check_guess(how_close)
  bg_color = background(how_close)

  erb :index, locals: {
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
