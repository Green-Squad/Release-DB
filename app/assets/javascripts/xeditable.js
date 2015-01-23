$(document).ready(function() {
  $.fn.editable.defaults.mode = 'inline';
  $.fn.editable.defaults.ajaxOptions = {
    type : "PUT"
  };
  $('.editable').editable('disable');
  $('#edit-button').click(function(e) {
    $('.editable').editable('toggleDisabled');
    $('.editable').editable('show', false);
    e.stopPropagation();
  });

  $('.editable').last().on('shown', function(e, editable) {
    if (arguments.length == 2) {
      setTimeout(function() {
         $('.editable-container').find('input').first().focus();
      }, 0);
    }
   
  });
});
