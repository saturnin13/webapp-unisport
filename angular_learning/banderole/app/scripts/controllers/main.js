'use strict';

/**
 * @ngdoc function
 * @name angularLearningApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the angularLearningApp
 */

var app = angular.module("app", []);

app.controller("SomeController", function($scope){
  $scope.expanders = [
    {title: 'Titre 1',
      text: 'Contenu 1'},
    {title: 'Titre 2',
      text: 'Contenu 2'},
    {title: 'Titre 3',
      text: 'Contenu 3'}
  ];
});

app.directive("accordion", function(){
  return{
    restrict: 'EA',
    replace: true,
    transclude: true,
    template: "<div ng-transclude></div>",
    controller: function(){
      var expanders = [];
      this.gotOpened = function(selectedExpander){
        expanders.forEach(function(expander){
          if(selectedExpander != expander){
            expander.showMe = false;
          }
        });
      };
      this.addExpander = function(expander){
        expanders.push(expander);
      };
    }
  };
});

app.directive("expander", function(){
  return {
    restrict: 'EA',
    replace: true,
    transclude: true,
    require: '^?accordion',
    scope: {title: '=expanderTitle'},
    template: '<div>' +
    '<div class="title" ng-click="toggle()">{{title}}</div>' +
    '<div class="body" ng-show="showMe" ng-transclude></div>' +
    '</div>',
    link: function(scope, element, attrs, accordionController){
      scope.showMe = false;
      accordionController.addExpander(scope);
      scope.toggle = function toggle(){
        scope.showMe = !scope.showMe;
        accordionController.gotOpened(scope);
      };
    }
  };
});
