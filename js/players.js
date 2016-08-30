app.factory('players',['$http',function($http){
  
	var cid = "1";
	var url = './json/' + cid + '.json';


  return $http.get(url).success(function(data){
    
    return data;
  })
  	.error(function(err){
    
    return err;
    
  });
  
}]);