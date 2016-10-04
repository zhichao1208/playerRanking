require "json"
require 'net/http'

def getJson(url)
source = url
resp = Net::HTTP.get_response(URI.parse(source))
data = resp.body
return JSON.parse(data)
end # => def getJson

pl_sofa = {"cid"=>"17",
		"sid"=>"11733",
		"custumId"=>"147384925",
		"season"=>"Premier League 16/17"}



round = 'http://www.sofascore.com/u-tournament/17/season/11733/matches/round/5'

league = {"cid"=>'17',"sid"=>'11733'}

match = 'http://www.sofascore.com/event/7090039/json?_=147377447'

lineup = 'http://www.sofascore.com/event/7090033/lineups/json?_=147377474'

player = 'http://www.sofascore.com/event/7090033/player/74577/statistics/json?_=NsU'


playerDetail ='http://www.sofascore.com/player/173827/details/json?_=GsNhb'

roundStart = 1

leagueInfo = pl_sofa

leagueInfoUrl = "http://www.sofascore.com/u-tournament/#{pl_sofa["cid"]}/season/#{pl_sofa["sid"]}/json?_=#{pl_sofa["custumId"]}"

puts leagueInfoUrl

roundMatches =  getJson(leagueInfoUrl)["events"]

puts totalRounds =  roundMatches["rounds"].length

puts roundPositionIndex = roundMatches["roundMatches"]["data"]["roundPositionIndex"]

finishedMatches = roundMatches["roundMatches"]["tournaments"][0]["events"]


finishedMatches.find_all{|match| match["status"]["type"]=="finished"}.each do |match|

lineUpUrl = "http://www.sofascore.com/event/#{match["id"]}/lineups/json?_=#{match["customId"]}"

matchInfo = {"round"=>match["roundInfo"]["round"],
			"status"=>match["status"]["type"],
			 "winnerCode"=>match["winnerCode"],
			 "mcustomId"=>match["customId"],
			  "mid"=>match["id"],
			 "slug"=>match["slug"],
			 "home"=>{"name"=>match["homeTeam"]["name"],"tid"=>match["homeTeam"]["id"],"score"=>match["homeScore"]["current"],"img"=>"/images/team-logo/football_#{match["homeTeam"]["id"]}.png"},
			 "away"=>{"name"=>match["awayTeam"]["name"],"tid"=>match["awayTeam"]["id"],"score"=>match["awayScore"]["current"],"img"=>"/images/team-logo/football_#{match["awayTeam"]["id"]}.png"},
			 "lineUpUrl"=>lineUpUrl}


lineUpInfo = getJson(matchInfo["matchUrl"])

players = []

/line up home/

lineUpInfo["homeTeam"]["lineupsSorted"].each do |player|

statusData = getJson("http://www.sofascore.com/event/#{match["id"]}/player/#{player["player"]["id"]}/statistics/json?_=#{match["customId"]}")

statusOfMatch = statusData["groups"]
heatmap = statusData["heatmap"]

players << {"Info"=>{	"pid"=>player["player"]["id"],
						"name"=>player["player"]["name"],
						"shirtNumber"=>player["shirtNumber"],
						"positionName"=>player["positionName"],
						"rating"=>player["rating"]
						"img"=>"http://www.sofascore.com/images/player/image_#{player["player"]["id"]}.png"	},
		 	"league"=>leagueInfo,
		 	"match"=>matchInfo,
		 	"team"=>matchInfo["home"],
		 	"status"=>statusOfMatch,
		 	"heatmap"=>heatmap
			}


end # => player	

end # => finishedMatches.each do |match|






