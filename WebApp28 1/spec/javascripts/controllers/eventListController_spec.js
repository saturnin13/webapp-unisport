'use strict';
describe("Testing Jasmine", function() {

  beforeEach(module('feedModule'));
  var mainScope, eventListScope, eventListController;

  beforeEach(inject(function ($controller, $rootScope) {
        mainScope = $rootScope.$new();
        $controller('feedPageController', {$scope: mainScope});
        eventListScope = mainScope.$new();
        eventListController = $controller('eventListController', {
            $scope: eventListScope
        });
        eventListScope.init();
    }));

  describe("correctly interact with database,", function() {
      var $httpBackend;
      beforeEach(inject(function (_$httpBackend_) {
        $httpBackend = _$httpBackend_;
        $httpBackend.expectGET('/events.json').respond([{test: 'fakeData'}]);
        $httpBackend.expectGET('/university_mails.json').respond();
        $httpBackend.expectGET('/sports.json').respond();
        $httpBackend.expectGET('/feed/user_info.json').respond([{test: 'fakeData'}]);
      }));

      afterEach (function () {
        $httpBackend.verifyNoOutstandingExpectation();
        $httpBackend.verifyNoOutstandingRequest();
      });

      // TODO this test
      // it("should post to database when joinEvent is called", function() {
      //   $httpBackend.expectPOST('/event_participants.json').respond();
      //   eventListScope.joinEvent();
      //   $httpBackend.flush();
      // });

    });
});
