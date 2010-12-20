require 'uri'
require 'mongo'

module MetraTracker
  module Mongo
    def store(params)
      uri = URI.parse(ENV['MONGOHQ_URL'])
      conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
      db = conn.db(uri.path.gsub(/^\//, ''))
      requests = db.collection('requests')
      requests.insert(params.merge("created_at" => Time.now))
    end
  end
end