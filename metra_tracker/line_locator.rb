module MetraTracker
  module LineLocator
    class << self
      def locate(params)
        closest_edge = LineLocator::EDGES.min do |edge_a, edge_b|
          da = distance_from_an_edge(
            edge_a.station_a.lat.to_f,
            edge_a.station_a.lng.to_f,
            edge_a.station_b.lat.to_f,
            edge_a.station_b.lng.to_f,
            params["latitude"].to_f,
            params["longitude"].to_f
          )

          db = distance_from_an_edge(
            edge_b.station_a.lat.to_f,
            edge_b.station_a.lng.to_f,
            edge_b.station_b.lat.to_f,
            edge_b.station_b.lng.to_f,
            params["latitude"].to_f,
            params["longitude"].to_f
          )
          da <=> db
        end

        [
          distance_from_an_edge(
            closest_edge.station_a.lat.to_f,
            closest_edge.station_a.lng.to_f,
            closest_edge.station_b.lat.to_f,
            closest_edge.station_b.lng.to_f,
            params["latitude"].to_f,
            params["longitude"].to_f
          ),
          closest_edge.line        
        ]
      end

      # via http://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment#2233538
      def distance_from_an_edge(x1,y1, x2,y2, x3,y3)
        px = x2-x1
        py = y2-y1

        something = px*px + py*py

        u = ((x3 - x1) * px + (y3 - y1) * py) / something

        if u > 1
          u = 1
        elsif u < 0
          u = 0
        end

        x = x1 + u * px
        y = y1 + u * py

        dx = x - x3
        dy = y - y3

        stuff = dx*dx + dy*dy
        Math.sqrt(stuff)
      end
    end
    
    
    class Station
      attr_reader :name, :lat, :lng
      def initialize(name, lat, lng)
        @name = name
        @lat = lat
        @lng = lng
      end
    end
    
    class Edge
      attr_reader :line, :station_a, :station_b
      def initialize(line, station_a, station_b)
        @line = line
        @station_a = station_a
        @station_b = station_b
      end
    end    

    geo_file = File.join(File.dirname(__FILE__), "..", "analysis", "geocodes.csv")
    geo_data = FasterCSV.read(geo_file)

    EDGES = []
    MetraSchedule::TrainData::LINES.each do |line_key, data|
      next if line_key == :me # Electric line is not well geocoded yet

      stations = data[:stations]
      i = 0
      loop do
        station_a = stations[i]
        geo_datum_a = geo_data.find {|s, lat, lng| s == station_a.to_s }

        station_b = stations[i+1]
        until geo_datum_b = geo_data.find {|s, lat, lng| s == station_b.to_s }
          i += 1
          station_b = stations[i+1]
        end

        EDGES << Edge.new(
          data[:name],
          Station.new(station_a, geo_datum_a[1], geo_datum_a[2]),
          Station.new(station_b, geo_datum_b[1], geo_datum_b[2])
        )

        break if i == stations.size - 2
        i += 1
      end
    end
  end
end