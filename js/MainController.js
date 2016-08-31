app.controller('MainController', ['$scope', 'leagues','players', function($scope, leagues, players) { 

  leagues.success(function(data){
   $scope.leagues =data;
  });

  players.success(function(data){
   $scope.players =data;


  console.log($scope.players[0]);

  var player =  $scope.players[0];

  $scope.labels = [player["name"]];

  $scope.series = [player["name"]];

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





  });





}]);

