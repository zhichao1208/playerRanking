app.factory('players',['$http',function($http){
  
	cid = "1"
	url = './json/' + cid + '.json'


  return $http.get(url).success(function(data){
    
    return data;
  })
  	.error(function(err){
    
    return err;
    
  });
  
}]);