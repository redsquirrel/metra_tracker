require "fastercsv"
require "metra"
require "time"

require "metra_tracker/line_locator"
require "metra_tracker/mongo"

module MetraTracker    
  MAX_LATITUDE  =  42.5858333
  MAX_LONGITUDE = -87.5594444
  MIN_LATITUDE  =  41.4594444
  MIN_LONGITUDE = -88.6175

  class << self
    def tell_me_what_is_up(params)
      Mongo.store(params)
      Response.new(in_bounds?(params), on_line(params))
    end

    private
    
    def in_bounds?(params)
      params["latitude"].to_f  < MAX_LATITUDE  &&
      params["latitude"].to_f  > MIN_LATITUDE  &&
      params["longitude"].to_f < MAX_LONGITUDE &&
      params["longitude"].to_f > MIN_LONGITUDE
    end
    
    def on_line(params)
      return false unless in_bounds?(params)
      distance, line = LineLocator.locate(params)
      return line if distance < 0.005 # fairly arbitrary threshold
    end
  end
  
  class Response
    attr_reader :line
    def initialize(in_bounds, line)
      @in_bounds = in_bounds
      @line = line
    end
    
    def in_bounds?
      @in_bounds
    end
    
    def on_track?
      not @line.nil?
    end
    
    OUT_OF_BOUNDS = "You are not in Chicagoland. Why are you using this app?"
    NOT_ON_TRAIN = "You don't actually appear to be on a train right now."
    
    def to_s
      return OUT_OF_BOUNDS unless in_bounds?
      return NOT_ON_TRAIN unless on_track?
      "Looks like you're riding the #{@line} today, eh?"
    end
  end
end

