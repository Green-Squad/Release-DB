$(document).ready(function() {
  $.fn.editable.defaults.mode = 'inline';
  $.fn.editable.defaults.onblur = 'ignore';
  $.fn.editable.defaults.ajaxOptions = {
    type : "put"
  };

  //init editables
  $('.current-release-editable').editable('disable');
  
  $('#edit-button').click(function(e) {
    $('.current-release-editable').editable('toggleDisabled');
    $('.current-release-editable').editable('show', false);
    
    
    
    if($('.hidden-field:hidden').size()) {
      $('.hidden-field').show();  
    } else {
      $('.hidden-field').hide();
    }
    
    setRequired();
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
      var html =  "<div class='panel panel-default'> " +
                  "<div><span id='close-new-release' class='pull-right fa fa-times-circle'></span><div class='clearfix'></div></div>" +
                  "<div class='panel-body' style='padding-top:0;'> " +
                  generateReleaseRowHTML("Region","<span class='new-release-editable' " + 
                    "id='region_id' " + 
                    "data-type='select' " + 
                    "data-pk='' " +
                    "data-source='/regions.json' " + 
                    "data-showbuttons='false' " + 
                    "data-placeholder='Region' "  +
                    "data-send='auto'>" +
                  "</span>");
      html += generateReleaseRowHTML("Launch Date", "<span class='new-release-editable' " + 
                "id='launch_date' " +  
                "data-type='text' " +  
                "data-pk='' " +  
                "data-placeholder='e.g. December 25, 2015' " +
                "data-showbuttons='false' " + 
                "data-send='auto'>" + 
              "</span>");
      html +=  generateReleaseRowHTML("Format", "<span class='new-release-editable' " +  
                "id='medium_id' " + 
                "data-type='select' " +  
                "data-pk='' " +  
                "data-placeholder='Format' " +
                "data-source='/media.json?category_id=" + 
                  $('.temp_information').data('category-id') +
                "' " +  
                "data-showbuttons='false' " +  
                "data-send='auto'>" + 
              "</span>");
      
      html +=  generateReleaseRowHTML("Source", "<span class='new-release-editable source' " + 
                  "id='source' " + 
                  "data-placeholder='e.g. wikipedia.org/wiki/Halo_4' " +
                  "data-type='text' " + 
                  "data-showbuttons='false' " + 
                  "data-pk=''>" + 
              "</span>");
              
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
              "</div> " +
              "</div>";
              
      $('.new-release-entry').append(html)
      $('.new-release-editable').editable('show', false);
     
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
        setRequired();
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
    $('.editable').editable('option', 'validate', function(v) {
      if($.trim(v) == '') {
          return 'This field is required';
      }
    });
  }

  bindClick = function() {
    
    $('#close-new-release').click(function(){
      $('.new-release-entry').html("");
    });
    
    $('#new-release-save').click(function() {
      $('.editableform').submit();
      var region = $('.new-release-entry #region_id').text();
      var launch_date = $('.new-release-entry #launch_date').text();
      var medium = $('.new-release-entry #medium_id').text();
      $('.new-release-editable').editable('submit', {
        url : '/releases',
        ajaxOptions : {
          type : 'post',
          dataType : 'json' //assuming json response
        },
        success : function(data, config) {
          if (data && data.id) {
           
           var html = "<div class='panel panel-default'> " +
                        "<div class='panel-body'> " +
                          generateReleaseRowHTML("Region", region) +
                          generateReleaseRowHTML("Launch Date", launch_date) +
                          generateReleaseRowHTML("Format", medium) +
                          generateReleaseRowHTML("Countdown", "<span class='date' data-launch-date='" + launch_date + "'></span>") +
                        "</div> " +
                      "</div>";
            
            $('.new-release-entry').html(html);
           
           dateToCountdown();
            //show messages
            var msg = 'Your contribution has been submitted for approval.';
            $('#msg').addClass('alert-success').addClass('alert').removeClass('alert-danger').html(msg).show();
  
            $('.new-release-entry').removeClass('new-release-entry');
            $('#release-list').prepend('<div class="new-release-entry"></div>');
            
          } else if (data && data.errors) {
            //server-side validation error, response like {"errors": {"username": "username already exist"} }
            config.error.call(this, data.errors);
          }
        },
        error : function(errors) {
          var msg = "There was an error saving your release.";
          $('#msg').removeClass('alert-success').addClass('alert').addClass('alert-danger').html(msg).show();
        }
      });
    });
    
    $('#new-product-save').click(function() {
      $('.editableform').submit();
      var product = $('.new-product-entry #name').text();
      $('.new-product-editable').editable('submit', {
        url : '/products',
        ajaxOptions : {
          type : 'post',
          dataType : 'json' //assuming json response
        },
        success : function(data, config) {
          if (data && data.id) {
            $('.new-product-entry').html(product);
            
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
          var msg = "There was an error saving your product.";
          $('#msg').removeClass('alert-success').addClass('alert').addClass('alert-danger').html(msg).show();
        }
      });
    });
  };
  
  function generateReleaseRowHTML(label, content) {
    var html = "<div class='row'> " +
                "<div class='col-sm-3 dark-color'> " +
                  label +
                  ": " +  
                "</div> " +
                "<div class='col-sm-9'> " +
                  content + 
                "</div> " +
              "</div>";
    return html;
  }
});
