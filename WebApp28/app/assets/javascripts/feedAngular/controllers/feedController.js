'use strict'

var feedControllers = angular.module('feedControllers', []);

feedControllers.controller('feedPageController', ['$scope', '$http', '$filter',
  function($scope, $http, $filter) {

    $scope.getFeedScope = function() {
         return $scope;
    };

    $scope.displayErrorsJoinPopUp = function(joinEventForm) {
      return joinEventForm.$invalid
            && (joinEventForm.numberOfPeople.$touched && joinEventForm.numberOfPeople.$invalid)
            || (joinEventForm.phoneNumber.$touched && joinEventForm.phoneNumber.$invalid);
    }

    // Initialisation of the pahe
    $scope.init = function() {
      // Get all events to display on feed
      $scope.getEvents();

      // Get all universities for autocomplete
      $scope.getUniversities();

      // Get all universities for autocomplete
      $scope.getSports();

      // Get all user info for autocomplete
      $scope.getProfileData();
    };

    // Get all feeds elements and universities when created
    $scope.events = [];
    $scope.universities = [];
    $scope.sports = [];
    $scope.profileData = "";
    // Initialising filters
    $scope.filterLocation = "";
    $scope.filterSport = "";
    $scope.filterDate = "";
    $scope.filterUniversity = "";

    // TODO put in a service interaction with database
    // Get all events from database
    $scope.getEvents = function() {
      $http({
        method: 'GET',
        url: '/events.json'
      }).then(function(response) {
        $scope.events = response.data;
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to retrieve events");
      });
    };

    // Get all universities name from database
    $scope.getUniversities = function() {
      $http({
        method: 'GET',
        url: '/university_mails.json'
      }).then(function(response) {
        $scope.universities = response.data;
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to get all universities");
      });
    };

    // Get sports and add All Sports to the beggining of the list
    $scope.getSports = function() {
      $http({
        method: 'GET',
        url: '/sports.json'
      }).then(function(response) {
        $scope.sports = response.data;
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to retrieve sports");
      });
    };

    // Get all information from a user from database
    $scope.getProfileData = function () {
      $http({
        method: 'GET',
        url: '/feed/user_info.json'
      }).then(function(response) {
        $scope.profileData = response.data[0];
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to retrieve profile data");
      });
    };

    $scope.askForTelephone = function() {
      return $scope.profileData.telephone_number == undefined;
    }
  }]);
