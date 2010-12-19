require 'sinatra'
require 'metra' # https://github.com/blakesmith/metra_schedule
require 'metra_tracker'


get "/" do
  erb :index
end

MetraTracker.lines.each do |line|
  get("/" + line.line_key.to_s) do
    line.name + " is teh bom"
  end
end
