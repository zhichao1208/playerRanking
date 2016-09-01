app.controller('MainController', ['$scope', 'leagues','players', function($scope, leagues, players) { 


$scope.allPlayers = [];
$scope.chosedLeagues =["1","9","10","13"];
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

		  var player = $scope.choesdPlayer

		  console.log(player);
 
		  $scope.labels = ["Day1","Day2","Day3"];

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

