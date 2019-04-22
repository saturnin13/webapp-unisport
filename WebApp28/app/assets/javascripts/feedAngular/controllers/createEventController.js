'use strict'

var feedControllers = angular.module('feedControllers');

//TODO create service to put shared data
// Controller of the pop up to create a new event
feedControllers.controller('createEventController', ['$scope', '$http',
  function($scope, $http) {

    $scope.getFeedScope = function() {
         return $scope.$parent.getFeedScope();
    };

    $scope.displayErrors = function(creationEventForm) {
      return creationEventForm.$invalid
            && ((creationEventForm.sport.$touched && creationEventForm.sport.$invalid)
            || (creationEventForm.peopleComing.$touched && creationEventForm.peopleComing.$invalid)
            || (creationEventForm.location.$touched && creationEventForm.location.$invalid)
            || (creationEventForm.endTime.$touched && creationEventForm.endTime.$invalid)
            || (creationEventForm.startTime.$touched && creationEventForm.startTime.$invalid)
            || (creationEventForm.locationField.$touched && creationEventForm.locationField.$invalid)
            || (creationEventForm.phoneNumber.$touched && creationEventForm.phoneNumber.$invalid))
            && ($scope.displayErrorSportEmpty(creationEventForm)
            || $scope.displayErrorSportinvalid(creationEventForm)
            || $scope.displayErrorStartBiggerThanEnd(creationEventForm)
            || $scope.displayErrorPeopleEmpty(creationEventForm)
            || $scope.displayErrorUniversityLocationEmpty(creationEventForm)
            || $scope.displayErrorUniversityLocationInvalid(creationEventForm)
            || $scope.diplayErrorLocationRequired(creationEventForm)
            || $scope.displayErrorPhoneEmpty(creationEventForm)
            || $scope.diplayErrorPhoneTooShort(creationEventForm)
            || $scope.diplayErrorPhoneTooLong(creationEventForm)
            || $scope.displayErrorPhoneInvalidFormat(creationEventForm));
    }

    $scope.displayErrorSportEmpty = function(creationEventForm) {
      return creationEventForm.sport.$touched
            && creationEventForm.sport.$error.required
            && creationEventForm.sport.$isEmpty($scope.event.sport);
    }

    $scope.displayErrorSportinvalid = function(creationEventForm) {
      return creationEventForm.sport.$touched
            && creationEventForm.sport.$error.required
            && !creationEventForm.sport.$isEmpty($scope.event.sport);
    }

    $scope.displayErrorStartBiggerThanEnd = function(creationEventForm) {
      return (creationEventForm.endTime.$touched || creationEventForm.startTime.$touched)
            && $scope.validTimeInputed();
    }

    $scope.displayErrorPeopleEmpty = function (creationEventForm) {
      return creationEventForm.peopleComing.$touched
            && creationEventForm.peopleComing.$error.required;
    }

    $scope.displayErrorUniversityLocationEmpty = function(creationEventForm) {
      return creationEventForm.location.$touched
            && creationEventForm.location.$error.required
            && creationEventForm.location.$isEmpty($scope.event.university_location);
    }

    $scope.displayErrorUniversityLocationInvalid = function(creationEventForm) {
      return creationEventForm.location.$touched
            && creationEventForm.location.$error.required
            && !creationEventForm.location.$isEmpty($scope.event.university_location);
    }

    $scope.diplayErrorLocationRequired = function(creationEventForm) {
      return creationEventForm.locationField.$touched
            && creationEventForm.locationField.$error.required;
    }

    $scope.displayErrorPhoneEmpty = function(creationEventForm) {
      return creationEventForm.phoneNumber.$touched
            && creationEventForm.phoneNumber.$error.required;
    }

    $scope.diplayErrorPhoneTooShort = function(creationEventForm) {
      return creationEventForm.phoneNumber.$touched
            && !creationEventForm.phoneNumber.$error.required
            && creationEventForm.phoneNumber.$error.minlength;
    }

    $scope.diplayErrorPhoneTooLong = function(creationEventForm) {
      return creationEventForm.phoneNumber.$touched
            && !creationEventForm.phoneNumber.$error.required
            && creationEventForm.phoneNumber.$error.maxlength;
    }

    $scope.displayErrorPhoneInvalidFormat = function(creationEventForm) {
      return creationEventForm.phoneNumber.$touched
              && !creationEventForm.phoneNumber.$error.required
              && creationEventForm.phoneNumber.$error.pattern;
    }

      // Initialisation of all event characteristics
      $scope.event = {
        "sport": "",
        "date": "",
        "start_time": "",
        "end_time": "",
        "university_location": "",
        "location": "",
        "needed": "",
        "additional_info": "",
        "level": "0",
        "phone": ""
      };
      $scope.selectedLevelString = "Any level";
      $scope.updateLevelValue = function () {
        var levelValue = 0;
        if($scope.selectedLevelString == "Any level") {
          levelValue = 0;
        } else if ($scope.selectedLevelString == "Beginner") {
          levelValue = 1;
        } else if ($scope.selectedLevelString == "Intermediate") {
          levelValue = 2;
        } else if ($scope.selectedLevelString == "Advanced") {
          levelValue = 3;
        }
        $scope.event.level = levelValue;
      }

      $scope.$watch('event', function(newValue, oldValue) {
        if(parseInt(newValue.needed) < 1) {
          $scope.event.needed = 1;
        }
      }, true);

      // Creating a new event
      $scope.createEvent = function() {
        $http({
          method: 'POST',
          url: '/events.json',
          data: $scope.event
        }).then(function(response) {
          $scope.getFeedScope().getEvents();
        },
        function(response) {
          // TODO: Error handling to do
          alert("Failed to add events");
        });
      };

      $scope.creationSportUpdated = function (userInput) {
        if (userInput != undefined) {
          $scope.event.sport = userInput;
        }
      }

      $scope.creationSportSelected = function (selectedInfo) {
          if(selectedInfo != undefined) {
            $scope.event.sport = selectedInfo.title;
          }
      };

      $scope.creationLocationUpdated = function (userInput) {
        if (userInput != undefined) {
          $scope.event.university_location = userInput;
        }
      }

      $scope.creationLocationSelected = function (selectedInfo) {
          if(selectedInfo != undefined) {
            $scope.event.university_location = selectedInfo.title;
          }
      };

      $('#creationDatePicker').datepicker().on('clearDate', function(e) {
        $scope.$apply(function () {$scope.event.date = "";});
      });
      $('#creationDatePicker').datepicker().on('changeDate', function(e) {
        $scope.event.date = moment(e.date).format("dddd DD MMMM YYYY");
        if(!$scope.$$phase) {
          $scope.$apply();
        }
      });
      // Initialize date
      $("#creationDatePicker").datepicker("setDate", new Date());

      // Event when opened start time selaction
      $('#datetimepickerStart').on('dp.show', function(e) {
        // Close manually the dateTimePicker because it is not automatic (bug)
        $('#creationDatePicker').datepicker('hide');
      });

      // Event when opened start time selaction
      $('#datetimepickerEnd').on('dp.show', function(e) {
        // Close manually the dateTimePicker because it is not automatic (bug)
        $('#creationDatePicker').datepicker('hide');
      });

      // Update start time when change input start time
      $('#datetimepickerStart').on('dp.change', function(e) {
        $scope.event.start_time = e.date.format("HH:mm");
        $scope.$apply();
      });

      // Update end time when change input end time
      $('#datetimepickerEnd').on('dp.change', function(e) {
        $scope.event.end_time = e.date.format("HH:mm");
        $scope.$apply();
      });

      $('#datetimepickerStart').on('dp.show', function(e) {
        angular.element(document.getElementsByClassName("glyphicon-chevron-up")).addClass("fa fa-chevron-up").removeClass('glyphicon-chevron-up');
        angular.element(document.getElementsByClassName("glyphicon-chevron-down")).addClass("fa fa-chevron-down").removeClass('glyphicon-chevron-down');
      });

      $('#datetimepickerEnd').on('dp.show', function(e) {
        angular.element(document.getElementsByClassName("glyphicon-chevron-up")).addClass("fa fa-chevron-up").removeClass('glyphicon-chevron-up');
        angular.element(document.getElementsByClassName("glyphicon-chevron-down")).addClass("fa fa-chevron-down").removeClass('glyphicon-chevron-down');
      });

      $scope.openEndTimePicker = function() {
        $('#datetimepickerEnd').data("DateTimePicker").toggle();
      }

      $scope.openStartTimePicker = function() {
        $('#datetimepickerStart').data("DateTimePicker").toggle();
      }

      $scope.validTimeInputed = function () {
        return !moment($scope.event.end_time, 'HH:mm').isAfter(moment($scope.event.start_time, 'HH:mm'));
      }
 }]);
