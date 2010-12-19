
module MetraTracker
  def self.tell_me_what_is_up(params)
    store_in_mongo(params)
    # TODO Respond with magically, nearly suspicious, information about their train ride
    "In the future, this will be an eerily informative message. Check back soon!"
  end
  
  def self.store_in_mongo(params)
    require 'uri'
    require 'mongo'

    uri = URI.parse(ENV['MONGOHQ_URL'])
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    db = conn.db(uri.path.gsub(/^\//, ''))
    requests = db.collection('requests')
    requests.insert(params)
  end
end

