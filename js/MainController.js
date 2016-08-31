app.controller('MainController', ['$scope', 'leagues','players', function($scope, leagues, players) { 

  leagues.success(function(data){
   $scope.leagues =data;
  });

  players.success(function(data){
   $scope.players =data;
  });

  var player =  $scope.players[0];

   console.log(player);

  $scope.labels = ["January", "February", "March", "April", "May", "June", "July"];

  $scope.series = ['Series A'];

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




}]);

