'use strict';

describe("feedPageController,", function() {

  beforeEach(module('feedModule'));
  var scope, feedPageController;

  beforeEach(inject(function ($controller, $rootScope) {
        scope = $rootScope.$new();
        feedPageController = $controller('feedPageController', {
            $scope: scope
        });
    }));


    describe("correct initialisation,", function() {
      it("should initialise filter of university to be empty", function() {
        expect(scope.filterLocation).toBe("");
      });

      it("should initialise filter of sport to be empty", function() {
        expect(scope.filterSport).toBe("");
      });

      it("should initialise filter of date to be empty", function() {
        expect(scope.filterDate).toBe("");
      });
    });

    it("should return the scope of the feedcontroller when getFeedScope called", function() {
      expect(scope.getFeedScope()).toEqual(scope);
    });


    describe("correctly initialised,", function() {
      it("should retrieve events on initialisation", function() {
        spyOn(scope, 'getEvents');
        scope.init();
        expect(scope.getEvents).toHaveBeenCalled();
      });

      it("should retrieve universities on initialisation", function() {
        spyOn(scope, 'getUniversities');
        scope.init();
        expect(scope.getUniversities).toHaveBeenCalled();
      });
    });
    

    describe("correctly interact with database,", function() {

      var $httpBackend;
      beforeEach(inject(function (_$httpBackend_) {
        $httpBackend = _$httpBackend_;
      }));

      afterEach (function () {
        $httpBackend.verifyNoOutstandingExpectation();
        $httpBackend.verifyNoOutstandingRequest();
      });

      it("should retrieve events after getEvents is called", function() {
        expect(scope.universities).toEqual([]);
        $httpBackend.expectGET('/events.json').respond([{test: 'firstValue'}, {test: 'SecondValue'}]);
        scope.getEvents();
        $httpBackend.flush();
        expect(scope.events).toEqual([{test: 'firstValue'}, {test: 'SecondValue'}]);
      });

      it("should retrieve universities after getUniversities is called", function() {
        expect(scope.universities).toEqual([]);
        $httpBackend.expectGET('/university_mails.json').respond([{test: 'firstValue'}, {test: 'SecondValue'}]);
        scope.getUniversities();
        $httpBackend.flush();
        expect(scope.universities).toEqual([{test: 'firstValue'}, {test: 'SecondValue'}]);
      });
    });
});
