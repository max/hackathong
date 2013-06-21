angular.module('apiServices', ['ngResource']).
  factory('App', function($resource){
    return $resource('api/apps/:appId', {}, {
      query: {method:'GET', params:{appId:'apps'}, isArray:true}
    });
  }).
  factory('Apps', function($resource){
    return $resource('api/apps', {}, {
      query: {method:'GET', isArray:true}
    });
  });
