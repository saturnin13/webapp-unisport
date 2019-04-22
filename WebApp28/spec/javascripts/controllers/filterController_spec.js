'use strict';

describe("feedModule Controllers,", function() {

    beforeEach(module('feedModule'));

    var element, mainScope, filterScope;

    beforeEach(inject(function ($controller, $rootScope, $compile) {
        mainScope = $rootScope.$new();
        $controller('feedPageController', {$scope: mainScope});
        filterScope = mainScope.$new();
        element = $compile('<div class="date" data-provide="datepicker"></div>')(filterScope);
        $controller('filterController', {
            $scope: filterScope,
            $element: element
        });
      }));

      describe("correct initialisation,", function() {

        //TODO implement this test when sport retrieval done
        // it("should initialise sport of university by requesting sports from the database", function() {
        //   expect(scope.filterLocation).toBe("");
        // });

      });

      describe("correctly managed university input,", function() {

          it("should update the filterLocation value if calling inputUniversityUpdated with empty string", function() {
            mainScope.filterLocation = "value";
            filterScope.inputUniversityUpdated("");
            expect(mainScope.filterLocation).toBe("");
            filterScope.inputUniversityUpdated("");
            expect(mainScope.filterLocation).toBe("");
          });

        it("should not update the filterLocation value if calling inputUniversityUpdated with non empty string", function() {
          mainScope.filterLocation = "value";
          filterScope.inputUniversityUpdated("Imperial");
          expect(mainScope.filterLocation).toBe("value");
          filterScope.inputUniversityUpdated("UCL");
          expect(mainScope.filterLocation).toBe("value");
          filterScope.inputUniversityUpdated("Corentin");
          expect(mainScope.filterLocation).toBe("value");
          filterScope.inputUniversityUpdated("Test");
          expect(mainScope.filterLocation).toBe("value");
        });

        it("should update the filterLocation value if calling universitySelected with defined parameter", function() {
          mainScope.filterLocation = "value";
          filterScope.universitySelected({"title":"paul"});
          expect(mainScope.filterLocation).toBe("paul");
          filterScope.universitySelected({"title":"le"});
          expect(mainScope.filterLocation).toBe("le");
          filterScope.universitySelected({"title":"bouffon"});
          expect(mainScope.filterLocation).toBe("bouffon");
        });

        it("should not update the filterLocation value if calling universitySelected with undefined parameter", function() {
          mainScope.filterLocation = "value";
          filterScope.universitySelected(undefined);
          expect(mainScope.filterLocation).toBe("value");
        });

      });

      //TODO testing for the datepicker

});
