/注释：today 需要更改/

now = Time.new
puts  @today = now.strftime("%Y-%m-%d")
tomorrow = (now + (60 * 60 * 24)).strftime("%Y-%m-%d")
puts @last2Month = (now - 5184000).strftime("%Y-%m-%d")
@lastWeek = (now - (60 * 60 * 24 * 7)).strftime("%Y-%m-%d")
@last2Week = (now - (60 * 60 * 24 * 14)).strftime("%Y-%m-%d")
@yesterday= (now - (60 * 60 * 24 )).strftime("%Y-%m-%d")



require 'CSV'
require "json"
require 'net/http'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/match'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/team-report'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/ids'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/player'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/best11'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/best11_season'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/competition'
require_relative '/Users/jackli/Desktop/onedata/Working/Model/league'


leagueList = Competition.new.euro2016Backup

allData = []

leagueList.each do |l|

league = League.new(l["cid"],l["sid"])

puts "players-#{l["cid"]}.json"

playerJson = File.read("/Users/jackli/Desktop/onedata/seasoReview/players-#{l["cid"]}.json",
  :external_encoding => 'iso-8859-1',
  :internal_encoding => 'utf-8'
)

playerData=JSON.parse(playerJson)

/team best Player/

sid = l["sid"]

mdid = league.nowDay["nowDay"]

playerData.each do |player|

	player["data"]["info"]["sid"] = sid
	player["data"]["info"]["mdid"] = mdid

end


allData << playerData 

end


allData = allData.flatten


info = ["id","position","name"]
voted = ["radio","lastMatchDay","avgMatchDay"]
factor = ["important"]

attack = ["Attack","goals","assists","totalShots","shotsOnTarget","totalCrosses","successfulCrosses","gamesPlayed"]
general = ["General","touches","duelsTotal","duelsWon","totalPasses","passingAccuracy","foulsWon","foulsConceded","offsides"]
defence = ["Defence","clearances","interceptions","tacklesWon","blocks","aerialDuelsTotal","aerialDuelsWon"]
keeper = ["Keeper","savesTotal","cleanSheets","savesFromPenalty","savesCaught","savesParried"]

infoCN = ["id","位置","姓名"]
votedCN = ["支持率","本轮得票","平均得票"]

matchInfoCN = ["赛果","球队","主队","比分","比分","客队"]
factorCN = ["关键表现"]

attackCN = ["进攻数据","进球","助攻","射门","射正","传中","成功传中","参赛场次"]
generalCN = ["一般数据","触球","一对一对抗","成功一对一对抗","传球","传球成功率","犯规","被犯规","越位"]
defenceCN = ["防守数据",	"解围","拦截","争抢获得球权","封堵","头球争顶","成功头球争顶"]
keeperCN = ["守门员数据","扑救","零失球（1为无失球）","扑点球","扑救得球","扑救挡出"]


best = Best11.new(allData)

bestS = Best11Season.new(allData)
goalKeepers =bestS.bestGoalKeeper(10)


forwards = best.bestForwards(10)
attackMidfielders = best.bestAttackMidfield(10)
defenceMidfielders =best.bestDefenceMidfield(10) 
defenders =best.bestDefender(10) 
sideDefenders =best.bestSideDefender(10) 

others = best.bestOther(10)

playersList = forwards + attackMidfielders + defenceMidfielders + defenders +sideDefenders+ goalKeepers +others

/find the winner/


CSV.open("/Users/jackli/Desktop/onedata/seasoReview/all-#{@today}-1.csv", "wb") do |csv|


# => Title & CN
#	csv << (infoCN +attackCN + generalCN + defenceCN + keeperCN).flatten

# => (matchInfoCN + infoCN + factorCN+ attackCN + generalCN + defenceCN + keeperCN).flatten

keys  = (info +attack + general + defence + keeper ).flatten

csv << keys.flatten


# => Forward

/all/

playersList.each do |player|


# => important

array = keys.map do |key|

	if (key == "position" || key == "name"|| key == "id")

	player["data"]["info"][key]

	elsif (key == "Attack" || key == "General" || key == "Defence"|| key == "Keeper")
	
	["++"]

	else

		if player["data"].has_key?("stats")
			

	   player["data"]["stats"][key].to_f

		end

	end # => if key == "position"

end	# => keys.map do |key|

csv << array.flatten

end	# => bestForwards(5,playerData).each do |player|

end # => CSV.open("best11Of#{range["name"]}.csv", "wb") do |csv|


