app.controller('MainController', ['$scope', 'players', function($scope, players) { 
  players.success(function(data){
   $scope.players =data;
  });
}]);