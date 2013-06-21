function AppListCtrl($scope, $http) {
  $http.get('api/apps').success(function(data) {
    $scope.apps = data;
  });
}
