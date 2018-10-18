# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' # Automatically reloads the server when changed

number = rand(100)

# Base request to server
get '/' do
  erb :index, locals: { number: number }
end
