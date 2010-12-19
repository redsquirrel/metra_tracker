module MetraTracker
  def self.lines
    metra = Metra.new
    MetraSchedule::TrainData::LINES.map do |key, value|
      metra.line(key)
    end
  end
end

