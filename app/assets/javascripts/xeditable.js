$(document).ready(function() {
  $.fn.editable.defaults.mode = 'inline';
  $.fn.editable.defaults.ajaxOptions = {
    type : "put"
  };

  //init editables
  $('.editable').editable('disable');
  $('.new-release-editable').editable();
  $('.new-release-entry').hide();

  $('#edit-button').click(function(e) {
    $('.editable').editable('toggleDisabled');
    //$('.editable').editable('show', false);
    
    $('.new-release-entry').toggle();
    $('.new-release-editable').editable('toggleDisabled');
    //$('.new-release-editable').editable('show', false);
    
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
      url : '/releases',
      ajaxOptions : {
        type : 'post',
        dataType : 'json' //assuming json response
      },
      success : function(data, config) {
        if (data && data.id) {
          //record created, response like {"id": 2}
          //change editable options
          $(this).editable('option', 'pk', data.id);
          $(this).editable('option', 'url', '/releases/' + data.id);
          $(this).editable('option', 'type', 'put');

          //remove unsaved class
          $(this).removeClass('editable-unsaved');

          //show messages
          var msg = 'New release created!';
          $('#msg').addClass('alert-success').removeClass('alert-error').html(msg).show();

          //hide new release button
          $('#new-release-save').hide();
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
