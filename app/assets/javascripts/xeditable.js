$(document).ready(function() {
  $.fn.editable.defaults.mode = 'inline';
  /* $.fn.editable.defaults.ajaxOptions = {
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

  $('#new-release-save').click(function() {
  $('.new-release-editable').editable('submit', {
  url : '/releases/new',
  ajaxOptions : {
  dataType : 'json' //assuming json response
  }
  });
  });
  */
  //init editables
  $('.new-release-editable').editable();

  $('#new-release-save').click(function() {
    $('.new-release-editable').editable('submit', {
      url : '/releases',
      ajaxOptions : {
        dataType : 'json' //assuming json response
      },
      success : function(data, config) {
        console.log(data)
        if (data && data.id) {//record created, response like {"id": 2}
          //remove unsaved class
          $(this).removeClass('editable-unsaved');
          //show messages
          var msg = 'New release created!';
          $('#msg').addClass('alert-success').removeClass('alert-error').html(msg).show();
          $('#new-release-save').hide();
          $('.new-release-editable').data('send', 'always');
          $('.new-release-editable').data('url', '/releases/' + data.id);
        } else if (data && data.errors) {
          //server-side validation error, response like {"errors": {"username": "username already exist"} }
          config.error.call(this, data.errors);
        }
      },
      error : function(errors) {
        var msg = '';
        if (errors && errors.responseText) {//ajax error, errors = xhr object
          msg = errors.responseText;
        } else {//validation error (client-side or server-side)
          $.each(errors, function(k, v) {
            msg += k + ": " + v + "<br>";
          });
        }
        $('#msg').removeClass('alert-success').addClass('alert-error').html(msg).show();
      }
    });
  });
});
