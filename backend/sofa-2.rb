require "json"
require 'net/http'

def getJson(url)
source = url
resp = Net::HTTP.get_response(URI.parse(source))
data = resp.body
return JSON.parse(data)
end # => def getJson


def getPlayersData(league)

players = []



leagueInfoUrl = "http://www.sofascore.com/u-tournament/#{league["cid"]}/season/#{league["sid"]}/json?_=#{league["custumId"]}"

puts leagueInfoUrl

roundMatches =  getJson(leagueInfoUrl)["events"]

puts totalRounds =  roundMatches["rounds"].length

puts roundPositionIndex = roundMatches["roundMatches"]["data"]["roundPositionIndex"]

finishedMatches = roundMatches["roundMatches"]["tournaments"][0]["events"]

if  finishedMatches.find_all{|match| match["status"]["type"]=="finished"}.empty?

roundPositionIndex = roundPositionIndex-1

rounds = "http://www.sofascore.com/u-tournament/#{league["cid"]}/season/#{league["sid"]}/matches/round/#{roundPositionIndex}"

finishedMatches =  getJson(rounds)["roundMatches"]["tournaments"][0]["events"]



end


finishedMatches.find_all{|match| match["status"]["type"]=="finished"}.each do |match|

puts statisticsUrl = "http://www.sofascore.com/event/#{match["id"]}/statistics/players/json?_=#{match["customId"]}"

matchInfo = {"round"=>match["roundInfo"]["round"],
			"status"=>match["status"]["type"],
			 "winnerCode"=>match["winnerCode"],
			 "mcustomId"=>match["customId"],
			  "mid"=>match["id"],
			 "slug"=>match["slug"],
			 "home"=>{"name"=>match["homeTeam"]["name"],"tid"=>match["homeTeam"]["id"],"score"=>match["homeScore"]["current"],"img"=>"http://www.sofascore.com/images/team-logo/football_#{match["homeTeam"]["id"]}.png"},
			 "away"=>{"name"=>match["awayTeam"]["name"],"tid"=>match["awayTeam"]["id"],"score"=>match["awayScore"]["current"],"img"=>"http://www.sofascore.com/images/team-logo/football_#{match["awayTeam"]["id"]}.png"}}


statisticsInfo = getJson(statisticsUrl)

puts statisticsInfo["players"].length

statisticsInfo["players"].each do |player|

player["team"]["img"] = "http://www.sofascore.com/images/team-logo/football_#{player["team"]["id"]}.png"	


forward = {"goals"=>if !player["groups"]["attack"]["items"]["goals"].has_key?("raw") then 0 else player["groups"]["attack"]["items"]["goals"]["raw"] end,
			"assists"=>if !player["groups"]["attack"]["items"]["goalAssist"].has_key?("raw") then 0 else player["groups"]["attack"]["items"]["goalAssist"]["raw"] end,
			"shots"=>if !player["groups"]["attack"]["items"]["totalScoringAttempts"].has_key?("raw") then 0 else player["groups"]["attack"]["items"]["totalScoringAttempts"]["raw"] end,
			"minutes"=>if !player["groups"]["summary"]["items"]["minutesPlayed"].has_key?("raw") then 0 else player["groups"]["summary"]["items"]["minutesPlayed"]["raw"] end,
			"rating"=>player["groups"]["summary"]["items"]["rating"]["raw"].to_f } 

midfield = {"goals"=>if !player["groups"]["attack"]["items"]["goals"].has_key?("raw") then 0 else player["groups"]["attack"]["items"]["goals"]["raw"] end,
			"assists"=>if !player["groups"]["attack"]["items"]["goalAssist"].has_key?("raw") then 0 else player["groups"]["attack"]["items"]["goalAssist"]["raw"] end,
			"minutes"=>if !player["groups"]["summary"]["items"]["minutesPlayed"].has_key?("raw") then 0 else player["groups"]["summary"]["items"]["minutesPlayed"]["raw"] end,
			
			"totalDuels"=>if !player["groups"]["duels"]["items"]["totalDuels"].has_key?("raw") then 0 else player["groups"]["duels"]["items"]["totalDuels"]["raw"] end,


			"totalClearance"=>player["groups"]["defence"]["items"]["totalClearance"]["value"].to_i,
			"outfielderBlock"=>player["groups"]["defence"]["items"]["outfielderBlock"]["value"].to_i,
			"interceptionWon"=>if !player["groups"]["defence"]["items"]["interceptionWon"].has_key?("raw") then 0 else player["groups"]["defence"]["items"]["interceptionWon"]["raw"] end,
			"totalTackle"=>if !player["groups"]["defence"]["items"]["totalTackle"].has_key?("raw") then 0 else player["groups"]["defence"]["items"]["totalTackle"]["raw"] end,	

			"totalPass"=>if !player["groups"]["passing"]["items"]["totalPass"].has_key?("raw") then 0 else player["groups"]["passing"]["items"]["totalPass"]["raw"] end,
			"keyPass"=>if !player["groups"]["passing"]["items"]["keyPass"].has_key?("raw") then 0 else player["groups"]["passing"]["items"]["keyPass"]["raw"] end,

			"rating"=>player["groups"]["summary"]["items"]["rating"]["raw"].to_f } 

defender = {
			"goals"=>if !player["groups"]["attack"]["items"]["goals"].has_key?("raw") then 0 else player["groups"]["attack"]["items"]["goals"]["raw"] end,
			"assists"=>if !player["groups"]["attack"]["items"]["goalAssist"].has_key?("raw") then 0 else player["groups"]["attack"]["items"]["goalAssist"]["raw"] end,

			"totalClearance"=>player["groups"]["defence"]["items"]["totalClearance"]["value"].to_i,
			"outfielderBlock"=>player["groups"]["defence"]["items"]["outfielderBlock"]["value"].to_i,
			"interceptionWon"=>if !player["groups"]["defence"]["items"]["interceptionWon"].has_key?("raw") then 0 else player["groups"]["defence"]["items"]["interceptionWon"]["raw"] end,
			"totalTackle"=>if !player["groups"]["defence"]["items"]["totalTackle"].has_key?("raw") then 0 else player["groups"]["defence"]["items"]["totalTackle"]["raw"] end,

			"totalPass"=>if !player["groups"]["passing"]["items"]["totalPass"].has_key?("raw") then 0 else player["groups"]["passing"]["items"]["totalPass"]["raw"] end,
			"keyPass"=>if !player["groups"]["passing"]["items"]["keyPass"].has_key?("raw") then 0 else player["groups"]["passing"]["items"]["keyPass"]["raw"] end,
			"totalCross"=>if !player["groups"]["passing"]["items"]["totalCross"].has_key?("raw") then 0 else player["groups"]["passing"]["items"]["totalCross"]["raw"] end,
			"totalLongBalls"=>if !player["groups"]["passing"]["items"]["totalLongBalls"].has_key?("raw") then 0 else player["groups"]["passing"]["items"]["totalLongBalls"]["raw"] end,

			"rating"=>player["groups"]["summary"]["items"]["rating"]["raw"].to_f } 	


if !player["groups"]["goalkeeper"].nil?

goalkeeper = {
				"saves"=>if !player["groups"]["goalkeeper"]["items"]["saves"].has_key?("raw") then 0 else player["groups"]["goalkeeper"]["items"]["saves"]["raw"] end,
			"punches"=>player["groups"]["goalkeeper"]["items"]["punches"]["value"].to_i,
			"goodHighClaim"=>if !player["groups"]["goalkeeper"]["items"]["goodHighClaim"].has_key?("raw") then 0 else player["groups"]["goalkeeper"]["items"]["goodHighClaim"]["raw"] end,
		"rating"=>player["groups"]["summary"]["items"]["rating"]["raw"].to_f } 	

else

goalkeeper = {}										

end

playerStatus = {}

case player["groups"]["summary"]["items"]["position"]["value"]

	when "F"

		playerStatus = forward

	when "M"	

		playerStatus = midfield

	when "D"	

		playerStatus = defender
		
	when "G"	

		playerStatus = goalkeeper	
		
	end



players << {"info"=>{	"pid"=>player["player"]["id"],
						"name"=>player["player"]["name"],
						"shirtNumber"=>player["extra"]["shirtNumber"],
						"position"=>player["groups"]["summary"]["items"]["position"]["value"],
						"rating"=>player["groups"]["summary"]["items"]["rating"]["value"].to_f,
						"minutesPlayed"=>player["groups"]["summary"]["items"]["minutesPlayed"]["value"].to_f,
						"img"=>"http://www.sofascore.com/images/player/image_#{player["player"]["id"]}.png"},
		 	"league"=>league,
		 	"match"=>matchInfo,
		 	"status"=>playerStatus,
		 	"team"=>player["team"],
		 	"round"=>roundPositionIndex}


end # => line up home


end # => finishedMatches.each do |match|

players = players.flatten




return {"round"=>roundPositionIndex,"players"=>players}

end # => def getPlayersdata


def checkUpdate(league)



end # => check updata
/body/


pl_sofa = {"cid"=>"17",
		"sid"=>"11733",
		"custumId"=>"147384925",
		"season"=>"Premier League 16/17"}





roundStart = 1

playersData = getPlayersData(pl_sofa)

	json = JSON.generate(playersData["players"])

	File.open("../json/#{pl_sofa["cid"]}_#{playersData["round"]}_sofa_test.json","wb") do |f|
	f.write(json)
	end








