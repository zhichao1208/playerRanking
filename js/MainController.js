app.controller('MainController', ['$scope', 'leagues', function($scope, leagues) { 
  leagues.success(function(data){
   $scope.leagues =data;
  });
}]);