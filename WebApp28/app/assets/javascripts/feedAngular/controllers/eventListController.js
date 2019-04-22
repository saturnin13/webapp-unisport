'use strict'

var feedControllers = angular.module('feedControllers');

// Controllers for the list of event
feedControllers.controller('eventListController', ['$scope', '$http', '$timeout',
  function($scope, $http, $timeout) {

    $scope.eventCreatedInfo = {
      "participants":1,
      "message":"",
      "phone":""
    }

    var showNoEventMessage = false;
    $timeout(function() {
        showNoEventMessage = true;
    }, 1500);
    $scope.showMessageNoEvents = function() {
      return showNoEventMessage;
    }

    $scope.getEventById = function(event_id) {
      for (var i = 0; i < $scope.events.length; i++) {
        if($scope.events[i].id == event_id) {
          return $scope.events[i];
        }
      };
    }

    $scope.$watch('eventCreatedInfo', function(newValue) {
      if(parseInt(newValue.participants) < 1) {
        $scope.eventCreatedInfo.participants = 1;
      }
    }, true);

    $scope.currentEventId = "";
    $scope.setEventId = function(event_id) {
      $scope.currentEventId = event_id;
    }

    // Person join an event
    function eventJoinedupdateView(event_id) {
      var currentEvent = $scope.getEventById(event_id);
      currentEvent.status = "pending";

      $scope.getFeedScope().profileData.telephone_number = $scope.eventCreatedInfo.phone;
    };

    $scope.joinEvent = function() {
      $http({
        method: 'POST',
        url: '/event_participants.json',
        data: {
          "event_id": $scope.currentEventId,
          "participants": $scope.eventCreatedInfo.participants,
          "message": $scope.eventCreatedInfo.message,
          "telephone_number": $scope.eventCreatedInfo.phone
        }
      }).then(function(response) {
        // TODO: success message
        eventJoinedupdateView($scope.currentEventId);
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to add events");
      });
    };

    // Convert date to be suitable for filtering
    $scope.convertFilterDate = function () {
      if($scope.filterDate == "") {
        return "";
      }

      var convertedDate = moment($scope.filterDate, 'dddd DD MMMM YYYY').format('YYYY/MM/DD');
      return convertedDate;
     };

     // Return a boolean telling if the additional info is empty
     $scope.hasAdditionalInfos = function (additional_info) {
       return additional_info.length != 0;
     };

     // Return true if an event has more or the needed number of participant
     $scope.isNotEventAccessible = function(e) {
       return parseInt(e.needed) <= parseInt(e.participants) || e.status != "unseen";
     };

     // Return true if event was created by user
     $scope.hasCreatedEvent = function (created) {
       return created == 'true';
     };

     $scope.eventStatus = function(event) {
       if(event.status == "confirmed") {
         return "event_confirmed";
       } else if (event.status == "pending") {
         return "event_pending";
       } else if (event.status == "unseen") {
         return "event_unseen";
       }
     };
  }]);
