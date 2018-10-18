# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' # Automatically reloads the server when changed

def check_guess(guess)
  if guess > SECRET_NUMBER + 5
    'Way too high!'
  elsif guess > SECRET_NUMBER && guess <= SECRET_NUMBER + 5
    'Too high!'
  elsif guess == SECRET_NUMBER
    'You got it right!'
  elsif guess < SECRET_NUMBER && guess >= SECRET_NUMBER - 5
    'Too low!'
  elsif guess < SECRET_NUMBER - 5
    'Way too low!'
  end
end

set :secret_number, (proc { rand(100) })

SECRET_NUMBER = settings.secret_number
# Base request to server
get '/' do
  guess = params['guess'].to_i
  message = check_guess(guess)
  erb :index, locals: { guess: guess, message: message }
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
