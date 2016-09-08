app.controller('MainController', ['$scope','leagues','players', function($scope, leagues, players) { 


$scope.allPlayers = [];
$scope.chosedLeagues =["9"];
$scope.players=[];



  leagues.success(function(data){
   $scope.leagues =data;
  });

  players.success(function(data){
   $scope.allPlayers =data;
   $scope.players =data;
  });

      $scope.hoverIn = function(){
        this.hover = true;
    };

    $scope.hoverOut = function(){
        this.hover = false;
    };


$scope.leagueList = function(league){	

	var index =$scope.chosedLeagues.indexOf(league.cid)

	if (index == -1)

	{$scope.chosedLeagues.push(league.cid);}

	else

	{
	$scope.chosedLeagues.splice(index,1);

	};

	console.log($scope.chosedLeagues);	

};




$scope.choesdPlayer = {};

$scope.choose = function(player){	

	$scope.choesdPlayer = {};
 	
 		$scope.choesdPlayer = player;

 		$scope.chart();

};


$scope.chart = function(){	

		  var player = $scope.choesdPlayer;

		  var teams = $scope.choesdPlayer["last5MatchesInfo"].map(function(match) {

		  				if( match["team_home"]!==$scope.choesdPlayer["team"])
						  {return match["team_home"];}
						else{

							return match["team_away"];
						};
						});

		  console.log(player);

		   $scope.datasets = [{
		   pointBorderWidth: 1,
            pointHoverRadius: 5,
		   }];


 
		  $scope.labels = teams;

		  $scope.series = ["votes"];

		  $scope.data = [
		    player["last5Votes"]
		  ];

		  $scope.onClick = function (points, evt) {
		    console.log(points, evt);
		  };

		  $scope.datasetOverride = [{ yAxisID: 'votes' }];

		  $scope.options = {
		    scales: {
		      yAxes: [
		        {
		          id: 'votes',
		          type: 'linear',
		          display: true,
		          position: 'left'
		        }
		      ]
		    }
		  };

		};

  $scope.propertyName = 'lastAvg';
  $scope.reverse = true;

  $scope.sortBy = function(propertyName) {
    $scope.reverse = ($scope.propertyName === propertyName) ? !$scope.reverse : false;
    $scope.propertyName = propertyName;
  };

}]);

