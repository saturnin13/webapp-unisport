'use strict';

/* Controllers */

var feedControllers = angular.module('feedControllers', []);

feedControllers.controller('feedController', ['$scope',
  function($scope){

    // Get all feeds elements when created
    $scope.events = [{},{}];
  }]);
