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

      # TODO Collect all possible edges, instead of just the first one we find
      edge = on_edge(params)
      line = edge && edge.line && edge.line.name
      train = on_train(edge, params) if edge
      Response.new(
        in_bounds?(params),
        line,
        edge,
        train
      )
    end

    private
    
    def in_bounds?(params)
      params["latitude"].to_f  < MAX_LATITUDE  &&
      params["latitude"].to_f  > MIN_LATITUDE  &&
      params["longitude"].to_f < MAX_LONGITUDE &&
      params["longitude"].to_f > MIN_LONGITUDE
    end
    
    def on_edge(params)
      return false unless in_bounds?(params)
      distance, edge = LineLocator.locate(params)
      return edge if distance < 0.005 # fairly arbitrary threshold
    end
    
    def on_train(edge, params)
      now = Time.now
      edge.line.on(Date.today).trains.each do |train|
        last_stop = train.stops.select { |stop| time_in_seconds(stop.time) < time_in_seconds(now) }.last
        next_stop = train.stops.find { |stop| time_in_seconds(stop.time) > time_in_seconds(now) }
        next unless last_stop && next_stop
        if ([last_stop.station, next_stop.station] - edge.stations).empty?
          return train.train_num
        end
      end
      nil
    end

    def time_in_seconds(time)
      (time.hour*60*60) + (time.min*60) + time.sec
    end
  end
  
  class Response
    attr_reader :line, :train
    def initialize(in_bounds, line, edge, train)
      @in_bounds = in_bounds
      @line = line
      @edge = edge
      @train = train
    end
    
    def in_bounds?
      @in_bounds
    end
    
    def on_track?
      not @line.nil?
    end
    
    def on_train?
      not @train.nil?
    end
    
    def between
      @edge.stations
    end
    
    OUT_OF_BOUNDS = "You are not in Chicagoland. Why are you using this app?"
    NOT_ON_TRACK = "You don't actually appear to be on a train right now."
    
    def to_s
      return OUT_OF_BOUNDS unless in_bounds?
      return NOT_ON_TRACK unless on_track?
      
      if on_train?
        "Looks like you're riding train #{@train} on the #{@line}, and you're between #{between.first} and #{between.last}."
      else
        "Looks like you're riding the #{@line} today. I wonder which train you're on..."
      end
      # TODO explain what's next, or call to action
    end
  end
end

