require 'sinatra'
require 'metra' # https://github.com/blakesmith/metra_schedule
require 'metra_tracker'

get "/" do
  erb :index
end