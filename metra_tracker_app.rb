require 'sinatra'
require 'metra' # https://github.com/blakesmith/metra_schedule
require 'metra_tracker'


get "/" do
  erb :index
end

post "/status" do
  MetraTracker.tell_me_what_is_up(params).to_s
end
