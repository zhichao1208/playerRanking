require "json"
require 'net/http'


source = "http://feedmonster.iliga.de/feeds/il/en/competitions/9/1612/matches/482994.json"
resp = Net::HTTP.get_response(URI.parse(source))
data = resp.body

matchData = JSON.parse(data)

puts matchData