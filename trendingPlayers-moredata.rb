require 'CSV'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/ids'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/competition'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/match'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/player'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/team-report'
@lan = "en"


def getVoted(mid)

source = "https://fanmatch.onefootball.com/voting/motm/#{mid}"
resp = Net::HTTP.get_response(URI.parse(source))
data = resp.body
tipstarheroData = JSON.parse(data)["data"]["playerList"]

return tipstarheroData

end

/check which league need update/


def checkLastMatchday(league)





end # => check

/update/

def update(league)

ids = Ids.new


cid = league["cid"]

tillThisArray = ids.getMatchDayIds(league["cid"],league["sid"],"tillThis")

days = tillThisArray.length

playerData = []

tillThisArray.each do |mdid|

playersOfOneMday = {}

playersOfOneMday["mdid"] = mdid["id"]

playerList=[]

mids= ids.getMatchIdsInADay(league["cid"],league["sid"],mdid["id"])

mids.each do  |mid|

playerList << getVoted(mid).each{|p|p["mid"]=mid}

end # => mids.each do  |mid|


playersOfOneMday["playerList"] =playerList

playerData << playersOfOneMday

end # => tillThisArray[-5..-1].each do |mdid|

if playerData.last["playerList"].flatten[0].nil?

playerData = playerData.reverse.drop(1).reverse

days = days-1

end

bestOfLast = playerData.last["playerList"].flatten.select{|p|p["votes"]>100}.sort_by{|p| p["votes"]}.reverse[0..15]

bestOfLast.each do |player|


player["lastVotes"] = player["votes"]

player["sortId"] = player["sortId"]

# => playerPastVotes = playerData.map{|data|data["playerList"]}.flatten.find_all{|p| p["id"]==player["id"]}.sort_by{|p|p["matchday"]["id"]}
playerPastVotes = []
/find vote by day/

  playerData.each do |day|

  playerVoteData = {} 

  if day["playerList"].flatten.find{|p| p["id"]==player["id"]}.nil?

  playerVoteData = {"id"=>player["id"],"votes"=>0}

  else

  playerVoteData = day["playerList"].flatten.find{|p| p["id"]==player["id"]}  

  end # => if day["playerList"].flatten.find{|p| p["id"]==player["id"]}.nil?

  playerPastVotes << playerVoteData

  end # => playerData.each do |day|


/end/
playerAvgVotes = playerPastVotes.map{|p| p["votes"].to_f}.reduce(:+)/days

player["avgVotes"] = playerAvgVotes

player["pastVotes"] = playerPastVotes

votes = playerPastVotes.map{|p| p["votes"].to_f}

player["pastVotesNumber"] = votes

sortIds = playerPastVotes.map{|p| p["sortId"].to_f}

player["pastSortId"] = sortIds

player["pastBestPlayer"] = sortIds.find_all{|rank| rank==1}.length

if votes.count >1
rate = votes.map.with_index{ |x, i| [x,votes[i+1]] }[0...-1].map{|a| if a[0]==0 then a[1].to_f.round(2) else ((a[1]-a[0])/a[0].to_f).round(2)end}
player["votesAvgRate"] =rate.reduce(:+)/rate.count
else
player["votesAvgRate"] = -1000
end

player["last/Avg"] = ((player["lastVotes"]/playerAvgVotes)*100).round(2)
/info/

playerInfo = Player.new(player["id"],league["sid"]).getPlayerInfo

team5Mids = Team.new(player["teamId"],league["sid"]).typeMids("pass").last(5)

last5Matches = []

team5Mids.each do |mid|

  last5Matches << Match.new(@lan,mid,league["cid"],league["sid"]).show("tid")

end

goalInfo = Match.new(@lan,playerPastVotes.last["mid"],league["cid"],league["sid"]).goals.find_all{|goal| goal["player"]["id"].to_i == player["id"].to_i}.count

player["hasGoals"] = goalInfo
player["last5MatchesInfo"] = last5Matches
player["playerInfo"] = playerInfo

if playerInfo["data"]["info"].has_key?("clubTeam")
player["team"] = playerInfo["data"]["info"]["clubTeam"]["name"]
player["teamImg"] = playerInfo["data"]["info"]["clubTeam"]["logoUrls"][0]
else
player["team"] = "noInfo"
end 

player["profileLink"]  = "https://www.onefootball.com/en-US/player/#{playerInfo["data"]["info"]["firstName"]}-#{playerInfo["data"]["info"]["lastName"]}-profile-#{playerInfo["data"]["info"]["id"]}?competitionId=#{league["cid"]}"


end # => bestOfLast.each do |player|

return trendingPlayers =  bestOfLast.find_all{|player| player["pastVotesNumber"][-2]!=0 }.sort_by{|p| p["last/Avg"]}.reverse.map{|p|

 {"name"=>p["playerInfo"]["data"]["info"]["name"],
  "link"=>p["profileLink"],
  "team"=>p["team"],
  "teamImg"=>p["teamImg"],
  "imageSrc"=>p["playerInfo"]["data"]["info"]["imageSrc"],
  "cid"=>league["cid"],
  "matchday"=>days,
  "hasGoals"=>p["hasGoals"],
  "lastAvg"=>p["last/Avg"].round(2),
  "lastVotes"=>p["lastVotes"],
  "LastSort"=>p["sortId"],
  "raisingSpeed"=>p["votesAvgRate"].round(2),
  "avgVotes"=>p["avgVotes"].round(2),
  "pastBestPlayer"=>p["pastBestPlayer"],
  "last5MatchesInfo"=>p["last5MatchesInfo"],
  "last5Votes"=>p["pastVotesNumber"]
 }

}


end # => update

/output/

leaugesList = []

playersAll = []

bl17 = Competition.new.bl17
pl17 = Competition.new.pl17
laliga17 = Competition.new.laliga17
sa17 = Competition.new.sa17

[pl17,bl17,laliga17,sa17].each do |league|


playersData = update(league)

img = "https://images.onefootball.com/icons/leagueColoredCompetition/64/"

leaguePage = "https://www.onefootball.com/en-US/competition/"


leaugesList << {"cid"=>league["cid"],
                "sid"=>league["sid"],
                "name"=>league["name"],
                "matchday"=>playersData[0]["matchday"],
                "img"=>img+league["cid"]+".png",
                "link"=>leaguePage+league["cid"]}

   playersAll <<playersData

  json = JSON.generate(playersData)

  File.open("/Users/jackli/Desktop/onedata/TrendPlayer/web/json/#{league["cid"]}.json","wb") do |f|
  f.write(json)
  end

end # => leagues


  json = JSON.generate(playersAll.flatten)

  File.open("/Users/jackli/Desktop/onedata/TrendPlayer/web/json/players.json","wb") do |f|
  f.write(json)
  end




  list = JSON.generate(leaugesList)

  File.open("/Users/jackli/Desktop/onedata/TrendPlayer/web/json/leagueList.json","wb") do |f|
  f.write(list)
  end

