'use strict'

var feedControllers = angular.module('feedControllers');

// Controller for the filters
feedControllers.controller('filterController', ['$scope', '$http',
  function($scope, $http) {

      // Bind the clear button from the datepicker to the event list
      $('#dateFilter').datepicker().on('clearDate', function(e) {
        $scope.getFeedScope().$apply(function () {$scope.getFeedScope().filterDate = "";});
      });

      // Manage change in university value in the autocomplete filter for university
      $scope.inputSportUpdated = function (userInput) {
        if (userInput == "") {
          $scope.getFeedScope().filterSport = "";
        }
        // TODO remove hardcoding
        // Check whether the input is the user uni to automatically toggle the button
      };
      $scope.sportSelected = function (selectedInfo) {
          if(selectedInfo != undefined) {
            $scope.getFeedScope().filterSport = selectedInfo.title;
          }
      };

      // Manage change in university value in the autocomplete filter for university
      $scope.inputUniversityUpdated = function (userInput) {
        if (userInput == "") {
          $scope.getFeedScope().filterLocation = "";
        }
        // TODO remove hardcoding
        // Check whether the input is the user uni to automatically toggle the button
      };
      $scope.universitySelected = function (selectedInfo) {
          if(selectedInfo != undefined) {
            $scope.getFeedScope().filterLocation = selectedInfo.title;
          }
      };

      // TODO do unit test and remove hardcoding
      // Manage the toggle of university
      $(function() {
        $("#universityToggle").change(function() {
          // If ot already in $digest or $apply
          if(!$scope.$$phase) {
            if($(this).prop("checked")) {
              $scope.getFeedScope().filterUniversity = "";
            } else {
              $scope.getFeedScope().filterUniversity = $scope.getFeedScope().profileData.university_name;
            }
            $scope.$apply();
          }
        })
      })

      // Decide if toggle should be shown
      $scope.showToggle = function() {
        return $scope.getFeedScope().profileData.university_name != "";
      };
}]);
