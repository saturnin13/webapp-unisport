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
//= require profileAngular/app.js
//= require profileAngular/controllers.js
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

$(function() {

  // We can attach the `fileselect` event to all file inputs on the page
  $(document).on('change', ':file', function() {
    var input = $(this),
        numFiles = input.get(0).files ? input.get(0).files.length : 1,
        label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
  });

  // We can watch for our custom `fileselect` event like this
  $(document).ready( function() {
      $(':file').on('fileselect', function(event, numFiles, label) {

          var input = $(this).parents('.input-group').find(':text'),
              log = numFiles > 1 ? numFiles + ' files selected' : label;

          if( input.length ) {
              input.val(log);
          } else {
              if( log ) alert(log);
          }

      });
  });

});
