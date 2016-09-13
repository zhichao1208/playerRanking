@lan = "en"

require_relative '/Users/jackli/Desktop/onedata/Working/Model/competition'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/team-report'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/player'

leagueList = Competition.new.season17

leagueList.each do |league|

playerData = []

teamsIDs = league["tids"]

n = teamsIDs.count

i = 1
# => get database
teamsIDs.each do |tid|

puts tid 
puts "#{i} / #{n}"

teamPlayerData = Team.new(tid,league["sid"]).playerIds.map{|pid| Player.new(pid,league["sid"]).getPlayerInfo(@lan)} 

playerData << teamPlayerData

puts "players count is #{teamPlayerData.count}"
i+=1

end # => teamsIDs.each do |tid|

playerData = playerData.flatten

json = JSON.generate(playerData)

File.open("./players-#{league["sid"]}.json","w") do |f|
  f.write(json)
end

end # => 
