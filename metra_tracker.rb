
module MetraTracker
  MAX_LATITUDE  =  42.5858333
  MAX_LONGITUDE = -87.5594444
  MIN_LATITUDE  =  41.4594444
  MIN_LONGITUDE = -88.6175
  
  class << self
    def tell_me_what_is_up(params)
      store_in_mongo(params)
      Response.new(in_bounds?(params))
    end

    private
    
    def in_bounds?(params)
      params["latitude"].to_f  < MAX_LATITUDE  &&
      params["latitude"].to_f  > MIN_LATITUDE  &&
      params["longitude"].to_f < MAX_LONGITUDE &&
      params["longitude"].to_f > MIN_LONGITUDE
    end

    def store_in_mongo(params)
      require 'uri'
      require 'mongo'

      uri = URI.parse(ENV['MONGOHQ_URL'])
      conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
      db = conn.db(uri.path.gsub(/^\//, ''))
      requests = db.collection('requests')
      requests.insert(params)
    end
  end
  
  class Response
    def initialize(in_bounds)
      @in_bounds = in_bounds
    end
    
    def in_bounds?
      @in_bounds
    end
    
    def out_of_bounds?
      not in_bounds?
    end
    
    def to_s
      case
      when in_bounds?
        "Cool, you're in Chicagoland. More info coming soon!"
      when out_of_bounds?
        "You are not in Chicagoand."
      else
        "Some eerily informative info coming soon..."
      end
    end
  end
end

