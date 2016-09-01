app.controller('MainController', ['$scope', 'leagues','players', function($scope, leagues, players) { 


$scope.players = [];

  leagues.success(function(data){
   $scope.leagues =data;
  });

  players.success(function(data){
   $scope.players =data;
  });


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





}]);

