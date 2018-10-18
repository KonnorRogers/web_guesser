# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' # Automatically reloads the server when changes are made

# generate random number
r_num = rand 100

# Base request to server
get '/' do
  "The SECRET NUMBER is #{r_num}"
end
