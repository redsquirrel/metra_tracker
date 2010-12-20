require 'open-uri'
require 'metra'
require 'json'

metra = Metra.new
stops = []

MetraSchedule::TrainData::LINES.map do |key, value|
  line = metra.line(key)
  line.load_schedule
  # puts line.name

  line.trains.each do |train|
    stops << train.stops.map {|stop| stop.station}
  end
end

success = 0
all_stops = stops.flatten.uniq
all_stops.each do |stop|
  stop_name = stop.to_s.gsub(/_/, "+")
  format = "json"
  json = open("http://maps.googleapis.com/maps/api/geocode/#{format}?address=#{stop_name}+metra+station&sensor=false")

  unless response = JSON.parse(json.read)
    # puts "No response for #{stop}"
    next
  end
  unless results = response["results"]
    # puts "No results for #{stop}"
    next
  end

  found = false
  results.each do |result|
    if result['address_components'].any?{|ac|ac["long_name"] == "Illinois"}
      location = result["geometry"]["location"]
      types = result['types']
      puts "#{stop},#{location['lat']},#{location['lng']}"
      success += 1
      found = true
      break
    end
  end
  unless found
    puts "Could not find an Illinois result for #{stop}: #{results.inspect}"
  end
end
puts "Geocoding Success Rate: #{success/all_stops.size.to_f}"