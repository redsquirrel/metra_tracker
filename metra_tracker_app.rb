require 'sinatra'
require 'metra' # https://github.com/blakesmith/metra_schedule
require 'metra_tracker'


get "/" do
  erb :index
end

get "/status" do
  MetraTracker.tell_me_what_is_up(params)  
end
