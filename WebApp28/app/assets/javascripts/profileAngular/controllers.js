'use strict';

/* Controllers */

var profileControllers = angular.module('profileControllers', []);

profileControllers.controller('createdEventsController', ['$scope', '$http',
  function($scope, $http) {

    // Initialisation of the page
    $scope.init = function() {
      // Get events created to display on profile
      $scope.getCreatedEvents();
    };

    $scope.createdEvents = [];

    $scope.hasCreatedEvents = function() {
      return $scope.createdEvents.length != 0;
    }

    // Return a boolean telling if the additional info is empty
    $scope.hasAdditionalInfos = function (additional_info) {
      return additional_info.length != 0;
    };

    // Get created events from database
    $scope.getCreatedEvents = function() {
      $http({
        method: 'GET',
        url: '/profile/created_events.json'
      }).then(function(response) {
        $scope.createdEvents = response.data;
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to retrieve created events");
      });
    };

    function getCreatedEventIndex(event_id) {
      for (var i = 0; i < $scope.createdEvents.length; i++) {
        if($scope.createdEvents[i].id == event_id) {
          return $scope.createdEvents[i];
        }
      };
    }

    $scope.deleteEvent = function(event_id) {
      $http({
        method: 'DELETE',
        url: '/events/' + event_id
      }).then(function(response) {
        var eventIndex = getCreatedEventIndex(event_id);
        $scope.createdEvents.splice(eventIndex, 1);
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to delete event");
      });
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
  }
]);

profileControllers.controller('joinedEventsController', ['$scope', '$http',
  function($scope, $http) {

    // Initialisation of the page
    $scope.init = function() {
      // Get events joined to display on profile
      $scope.getJoinedEvents();
    };

    $scope.joinedEvents = [];

    $scope.hasJoinedEvents = function() {
      return $scope.joinedEvents.length != 0;
    }

    $scope.hasBeenConfirmed = function(status) {
      return status == "confirmed";
    }

    // Return a boolean telling if the additional info is empty
    $scope.hasAdditionalInfos = function (additional_info) {
      return additional_info.length != 0;
    };

    // Get created events from database
    $scope.getJoinedEvents = function() {
      $http({
        method: 'GET',
        url: '/profile/joined_events.json'
      }).then(function(response) {
        $scope.joinedEvents = response.data;
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to retrieve joined events");
      });
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
  }
]);

profileControllers.controller('participantSelectionController', ['$scope', '$http',
  function($scope, $http) {

    $scope.eventParticipants = [];

    var currentCreatedEventId = "";
    function getCreatedEventById(event_id) {
      for (var i = 0; i < $scope.createdEvents.length; i++) {
        if($scope.createdEvents[i].id == event_id) {
          return $scope.createdEvents[i];
        }
      };
    }

    function getParticipantsById(user_id) {
      for (var i = 0; i < $scope.eventParticipants.length; i++) {
        if($scope.eventParticipants[i].id == user_id) {
          return $scope.eventParticipants[i];
        }
      };
    }

    function getParticipantsIndex(user_id) {
      for (var i = 0; i < $scope.eventParticipants.length; i++) {
        if($scope.eventParticipants[i].id == user_id) {
          return i;
        }
      };
    }

    $scope.getSpaceLeft = function() {
      var createdEvent = getCreatedEventById(currentCreatedEventId);
      if(createdEvent == undefined) {
        return -1;
      }
      if (parseInt(createdEvent.needed) - parseInt(createdEvent.participants) == 0) {
        return "no";
      }
      return createdEvent.needed - createdEvent.participants;
    }

    $scope.hasEventParticipants = function() {
      return $scope.eventParticipants.length != 0;
    }

    $scope.getPlurial = function() {
      return $scope.getSpaceLeft() > 1 ? "s": "";
    }

    $scope.displayEventParticipants = function(event_id) {
      $http({
        method: 'GET',
        url: '/profile/event_join_demands.json',
        params: {
          "event_id": event_id
        }
      }).then(function(response) {
        currentCreatedEventId = event_id;
        $scope.clearEventParticipants();
        $scope.eventParticipants = $scope.eventParticipants.concat(response.data);
        $('#select_participants').modal('toggle');
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to retrieve event participants");
      });
    };

    $('#select_participants').on('hidden.bs.modal', function (e) {
      $scope.clearEventParticipants();
    });

    $scope.clearEventParticipants = function() {
      $scope.eventParticipants = [];
    };

    $scope.selectParticipant = function(user_id, user_participants) {
      $http({
        method: 'PUT',
        url: '/event_participants/' + currentCreatedEventId,
        params: {
          "user_id": user_id
        }
      }).then(function(response) {
        var participant = getParticipantsById(user_id);
        participant.confirmed = 'true';
        var createdEvent = getCreatedEventById(currentCreatedEventId);
        if(parseInt(createdEvent.needed) > parseInt(createdEvent.participants)) {
          createdEvent.participants = String(parseInt(createdEvent.participants) + parseInt(user_participants));
        }
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to retrieve joined events");
      });
    };

    $scope.removeParticipant = function (user_id) {
      $http({
        method: 'DELETE',
        url: '/event_participants/' + currentCreatedEventId,
        params: {
          "user_id": user_id
        }
      }).then(function(response) {
        var participantIndex = getParticipantsIndex(user_id);
        $scope.eventParticipants.splice(participantIndex, 1);
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to delete joined events");
      });
    };

    $scope.participantConfirmed = function(participant) {
      return participant.confirmed == 'true'
    };
  }
]);


profileControllers.controller('profileController', ['$scope', '$http',
  function($scope, $http) {

    $scope.profileData = "";

    $scope.displayErrorsProfilePopUp = function(profileInformationForm) {
      return profileInformationForm.$invalid
            && ((profileInformationForm.telephone_number.$touched && profileInformationForm.telephone_number.$invalid));
    }

    // Profile data retrieval
    $scope.getProfileData = function () {
      $http({
        method: 'GET',
        url: '/profile/user_info.json'
      }).then(function(response) {
        console.log($scope.telephoneNumber);
        $scope.profileData = response.data[0];
        $scope.firstName = $scope.profileData.first_name;
        $scope.lastName = $scope.profileData.last_name;
        $scope.telephoneNumber = $scope.profileData.telephone_number;
        $scope.description = $scope.profileData.description;
      },
      function(response) {
        // TODO: Error handling to do
        alert("Failed to retrieve profile data");
      });
    };

    // before linking phase
    // TODO only when connected as a user (do an if)
    $scope.getProfileData();
  }
]);

profileControllers.controller('createEventController', ['$scope', '$http',
  function($scope, $http) {

    $scope.getFeedScope = function() {
         return $scope.$parent.getFeedScope();
    };

    $scope.displayErrors = function(creationEventForm) {
      return creationEventForm.$invalid
            && ((creationEventForm.sport.$touched && creationEventForm.sport.$invalid)
            || (creationEventForm.peopleComing.$touched && creationEventForm.peopleComing.$invalid)
            || (creationEventForm.location.$touched && creationEventForm.location.$invalid)
            || (creationEventForm.location.$touched && creationEventForm.location.$invalid)
            || (creationEventForm.endTime.$touched && creationEventForm.endTime.$invalid)
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
          // Line removed compeare to the original
          // $scope.getFeedScope().getEvents();
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

      $scope.openEndTimePicker = function() {
        console.log($('#datetimepickerEnd'));
        $('#datetimepickerEnd').data("DateTimePicker").toggle();
      }

      $scope.openStartTimePicker = function() {
        $('#datetimepickerStart').data("DateTimePicker").toggle();
      }

      $scope.validTimeInputed = function () {
        return !moment($scope.event.end_time, 'HH:mm').isAfter(moment($scope.event.start_time, 'HH:mm'));
      }

      // From there it is not present in the original feed controller was added

      // Get all information from a user from database

      $scope.profileData = "";
      $scope.universities = [];
      $scope.sports = [];

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

      // Get all universities for autocomplete
      $scope.getUniversities();

      // Get all universities for autocomplete
      $scope.getSports();

      // Get all user info for autocomplete
      $scope.getProfileData();

      $scope.askForTelephone = function() {
        return $scope.profileData.telephone_number == undefined;
      }

 }]);
