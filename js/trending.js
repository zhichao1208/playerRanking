app.factory('players',['$http',function($http){
  
  return $http.get('Users/jackli/Desktop/onedata/TrendPlayer/web/json/leagueList.json').success(function(data){
    
    return data;
  })
  	.error(function(err){
    
    return err;
    
  });
  
}]);