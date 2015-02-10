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
    
    $('.new-release-entry').html('');
    
    if($('.hidden-field:hidden').size()) {
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
      var html =  "<div>" +
                  "<span class='new-release-editable' " + 
                    "id='region_id' " + 
                    "data-type='select' " + 
                    "data-pk='' " +
                    "data-source='/regions.json' " + 
                    "data-showbuttons='false' " + 
                    "data-placeholder='Region' "  +
                    "data-send='auto'>" +
                  "</span>" +
                  " / ";
      html += "<span class='new-release-editable' " + 
                "id='launch_date' " +  
                "data-type='text' " +  
                "data-pk='' " +  
                "data-placeholder='Release Date' " +
                "data-showbuttons='false' " + 
                "data-send='auto'>" + 
              "</span> " + 
              " / ";
      html += "<span class='new-release-editable' " +  
                "id='medium_id' " + 
                "data-type='select' " +  
                "data-pk='' " +  
                "data-placeholder='Format' " +
                "data-source='/media.json?category_id=" + 
                  $('.temp_information').data('category-id') +
                "' " +  
                "data-showbuttons='false' " +  
                "data-send='auto'>" + 
              "</span> ";
      
      html += "<span class='hidden-field'> / " +
                "<span class='new-release-editable source' " + 
                  "id='source' " + 
                  "data-placeholder='Source URL' " +
                  "data-type='text' " + 
                  "data-showbuttons='false' " + 
                  "data-pk=''>" + 
                "</span>" + 
              "</span> ";
              
      html += "<div style='display:none'>" + 
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
              "</div> ";
              
      html += "<button id='new-release-save' class='btn btn-default'>" + 
                "Save" +
              "</button>" +
              "</div> ";
              
      $('.new-release-entry').append(html)
      $('.new-release-editable').editable();
      $('.new-release-editable').editable('show', false);
      $('.hidden-field').show();
      bindClick();
      setRequired();
    }
  });
  
  $('#add-product-button').click(function() {
    if ($('.new-product-entry').empty()) {
      var html =  "<div class='row' style='max-width: 500px'>" +
                  "<div class='col-md-2' style='margin-bottom:5px'>Name:</div>" + 
                  "<div class='col-md-10' style='margin-bottom:5px'>" +
                  "<span class='new-product-editable' " + 
                    "id='name' " + 
                    "data-type='text' " +
                    "data-pk='' " +
                    "data-placeholder='Name' " +
                    "data-showbuttons='false' " +
                    "data-send='auto'>" +
                  "</span> " +
                  "</div>";
       
       if ($('.temp_information').data('category-id')) {
         html +=  "<div style='display:none;'> " +
                    "<span class='new-product-editable' " +
                      "id='category_id' " +
                      "data-type='select' " +
                      "data-pk='' " +
                      "data-value='" +
                        $('.temp_information').data('category-id') +
                      "' " +
                      "data-showbuttons='false' " +
                      "data-send='auto'>" +
                    "</span>" +
                  "</div> ";
        } else {
          html += "<div id='remove-category'>" +
                    "<div class='col-md-2' style='margin-bottom:5px'>Category:</div>" + 
                    "<div class='col-md-10' style='margin-bottom:5px'>" +
                    "<span class='new-product-editable' " +
                      "id='category_id' " +
                      "data-type='select' " +
                      "data-pk='' " +
                      "data-placeholder='Category' " +
                      "data-id='1233' " +
                      "data-source='/categories.json' " +
                      "data-showbuttons='false' " +
                      "data-send='auto'>" +
                    "</span>" +
                  "</div> ";
        }
        
        html += "<div class='col-md-12' style='margin-bottom: 10px'>" +
                "<button id='new-product-save' class='btn btn-default'>" + 
                  "Save" +
                "</button>" +
                "</div>" +
                "</div>" +
                "</div>";

        $('.new-product-entry').append(html);
        $('.new-product-editable').editable();
        $('.new-product-editable').editable('show', false);
        bindClick();
      }
      setTimeout(function() {
        $('.editable-container').find('input').first().focus();
      }, 150);
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
      $('.editableform').submit();
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
    
    $('#new-product-save').click(function() {
      value = $('.editable-container').find('input').first().val();
      $('.editableform').submit();
      $('.new-product-editable').editable('submit', {
        url : '/products',
        ajaxOptions : {
          type : 'post',
          dataType : 'json' //assuming json response
        },
        success : function(data, config) {
          if (data && data.id) {
            $('.new-product-entry').html(value);
            
            //show messages
            var msg = 'Your contribution has been submitted for approval.';
            $('#msg').addClass('alert-success').addClass('alert').removeClass('alert-danger').html(msg).show();

            $('.new-product-entry').addClass('list-group-item');
            $('.new-product-entry').removeClass('new-product-entry');
            $('#product-list').prepend('<div class="new-product-entry"></div>');

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
