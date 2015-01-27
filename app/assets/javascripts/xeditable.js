$(document).ready(function() {
  $.fn.editable.defaults.mode = 'inline';
  $.fn.editable.defaults.onblur = 'ignore';
  $.fn.editable.defaults.ajaxOptions = {
    type : "put"
  };

  //init editables
  $('.editable').editable('disable');
  $('.new-release-entry').hide();
  
  $('#edit-button').click(function(e) {
    $('.editable').editable('toggleDisabled');
    $('.editable').editable('show', false);
    
    $('.new-release-entry').toggle();
    $('.new-release-editable').editable('toggleDisabled');
    $('.new-release-editable').editable('show', false);
    
    
    $('#add-release-button').toggle();
    
    if($('.hidden-field:hidden').size()) {
      console.log("showing")
      $('.hidden-field').show();  
    } else {
      $('.hidden-field').hide();
    }
    
    
    e.stopPropagation();
  });
  

  $('.editable').last().on('shown', function(e, editable) {
    if (arguments.length == 2) {
      setTimeout(function() {
        $('.editable-container').find('input').first().focus();
      }, 0);
    }
  });


  $('#add-release-button').click(function() {
    if ($('.new-release-entry').empty()) {
      $('.new-release-entry').append(
          "<div>" +
          "<span class='new-release-editable' " + 
          "id='region_id' " + 
          "data-type='select' " + 
          "data-pk='' " +
          "data-source='/regions.json' " + 
          "data-showbuttons='false' " + 
          "data-send='auto'>" +
          "</span>" +
          " / " +
          "<span class='new-release-editable' " + 
          "id='launch_date' " +  
          "data-type='text' " +  
          "data-pk='' " +  
          "data-placeholder='Release Date' " +
          "data-send='auto'>" + 
          "</span>" +
          " / " +
          "<span class='new-release-editable' " +  
          "id='medium_id' " + 
          "data-type='select' " +  
          "data-pk='' " +  
          "data-source='/media.json?category_id=" + 
          $('.temp_information').data('category-id') +
          "' " +  
          "data-showbuttons='false' " +  
          "data-send='auto'>" + 
          "</span>" +
          "<span class='hidden-field'> / " +
          "<span class='new-release-editable source' " + 
          "id='source' " + 
          "data-placeholder='source' " +
          "data-type='text' " + 
          "data-pk=''>" + 
          "</span>" + 
          "</span>" +
          "<div style='display:none'>" + 
          "<span class='new-release-editable' " +  
          "id='product_id' " + 
          "data-value='" +
          $('.temp_information').data('product-id') +
          "' " +  
          "data-pk='' " +  
          "data-showbuttons='false' " +  
          "data-send='auto' " + 
          "style='display:none'>" + 
          "</span>" +
          "</div>" +
          "<button id='new-release-save'>" + 
          "Save" +
          "</button>" +
          "</div>" 
          )
          
          $('.new-release-editable').editable();
          $('.new-release-editable').editable('show', false);
          $('.hidden-field').show();
          bindClick();
          setRequired();
      }
  });
  
  $('.editable').on('save', function(e, params) {
    var msg = 'Your contribution has been submitted for approval.';
    $('#msg').addClass('alert-success').addClass('alert').removeClass('alert-danger').html(msg).show();
});

  setRequired = function() {
    $('.source').editable('option', 'validate', function(v) {
      if($.trim(v) == '') {
          return 'This field is required';
      }
    });
  }

  bindClick = function() {
    
    $('#new-release-save').click(function() {
    console.log('clicked')
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

          $(this).removeClass('new-release-editable');
          $(this).addClass('editable');
          //show messages
          var msg = 'Your contribution has been submitted for approval.';
          $('#msg').addClass('alert-success').addClass('alert').removeClass('alert-danger').html(msg).show();

          //hide new release button
          $('#new-release-save').remove();
          
          $('.new-release-entry').removeClass('new-release-entry');
          $('#release-list').append('<div class="new-release-entry"></div>');
          
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
        $('#msg').removeClass('alert-success').addClass('alert').addClass('alert-danger').html(msg).show();
      }
    });
  });
  };
});
