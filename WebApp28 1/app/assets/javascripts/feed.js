//= require application
//= require moment
//= require angucomplete-alt
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.uk.js
//= require bootstrap-datetimepicker
//= require bootstrap-sass-official/assets/javascripts/bootstrap/collapse
//= require bootstrap-sass-official/assets/javascripts/bootstrap/transition
//= require angular-animate
//= require bootstrap-toggle
//= require feedAngular/app.js
//= require feedAngular/controllers/feedController.js
//= require feedAngular/controllers/createEventController.js
//= require feedAngular/controllers/eventListController.js
//= require feedAngular/controllers/filterController.js
//= require feedAngular/directives.js
//= require feedAngular/filters.js
//= require feedAngular/services.js
//= require_self

$(function () {
  $('#datetimepickerStart').datetimepicker({
    format: 'H:mm'
  });
});

$(function () {
  $('#datetimepickerEnd').datetimepicker({
    format: 'H:mm'
  });
});
