require "fastercsv"

max_lat, max_lng = [-180], [-180]
min_lat, min_lng = [180], [180]

FasterCSV.foreach("geocodes.csv") do |station, lat, lng|
  if max_lat.first < lat.to_f
    max_lat = [lat.to_f, station]
  end

  if min_lat.first > lat.to_f
    min_lat = [lat.to_f, station]
  end

  if max_lng.first < lng.to_f
    puts "Moving east: #{station} #{lng}"
    max_lng = [lng.to_f, station]
  end

  if min_lng.first > lng.to_f
    min_lng = [lng.to_f, station]
  end
end

print "North: "
p max_lat

print "East: "
p max_lng

print "South: "
p min_lat

print "West: "
p min_lng
