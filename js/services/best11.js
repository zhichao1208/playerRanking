app.factory('bests',['$http',function($http){
  
	var cid = "17";

	var round = "7";

	var url = './json/' + cid + '_'+round+'_' + 'sofa.json';

  console.log(url);

  return $http.get(url).success(function(data){

  	console.log(data.length);
  	
    return data;
  })
  	.error(function(err){

      console.log(err);
    
    return err;
    
  });
  
}]);