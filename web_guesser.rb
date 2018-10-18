# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

# generate random number
r_num = rand 100

# Base request to server
get '/' do
  "The secret number is #{r_num}"
end
