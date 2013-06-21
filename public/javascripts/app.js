angular.module('hackathong',['apiServices']);

function AppListCtrl($scope, Apps) {
  $scope.apps = Apps.query();
}
