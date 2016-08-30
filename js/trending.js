app.factory('players',['$http',function($http){
  
  return $http.get('./json/leagueList.json').success(function(data){
    
    return data;
  })
  	.error(function(err){
    
    return err;
    
  });
  
}]);