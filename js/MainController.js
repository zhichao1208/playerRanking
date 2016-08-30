app.controller('MainController', ['$scope', 'leagues','players', function($scope, leagues,players) { 

  leagues.success(function(data){
   $scope.leagues =data;
  });


  players.success(function(data){
   $scope.players =data;
  });




}]);