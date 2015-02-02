$(document).ready(function() {
  $('.date').each(function() {
    var _this = $(this)
    countdown(new Date($(this).data('launch-date')), function(ts) {
      _this.html(formatCountdown(ts));
    }, countdown.YEARS | countdown.MONTHS | countdown.DAYS | countdown.HOURS | countdown.MINUTES | countdown.SECONDS);

  });
  
  function formatList(ts) {
    var list = [];

    var value = ts.millennia;
    if (value) {
      list.push(value, 1);
    }

    value = ts.centuries;
    if (value) {
      list.push(value, 1);
    }

    value = ts.decades;
    if (value) {
      list.push(value, 1);
    }

    value = ts.years;
    if (value) {
      list.push(value, 1);
    }

    value = ts.months;
    if (value) {
      list.push(value, 1);
    }

    value = ts.weeks;
    if (value) {
      list.push(value, 1);
    }

    value = ts.days;
    if (value) {
      list.push(value, 1);
    }

    value = ts.hours;
    if (value) {
      list.push(value, 1);
    }

    value = ts.minutes;
    if (value) {
      list.push(value, 1);
    }

    value = ts.seconds;
    if (value) {
      list.push(value, 1);
    }

    value = ts.milliseconds;
    if (value) {
      list.push(value, 1);
    }

    return list;
  };


  function formatCountdown(ts) {
    var returnString = "";
    if (formatList(ts).length) {
      var years = ts.years;
      var months = ts.months;
      var days = ts.days;
      var hours = ts.hours;
      var minutes = ts.minutes;
      var seconds = ts.seconds;

      if (years == 1) {
        returnString += years + " year ";
      } else if (years > 1) {
        returnString += years + " years ";
      }

      if (months == 1) {
        returnString += months + " month ";
      } else if (months > 1) {
        returnString += months + " months ";
      }

      if (days == 0 || days > 1) {
        returnString += days + " days ";
      } else {
        returnString += days + " day ";
      }

      returnString += hours + ":" + minutes + ":" + seconds
    }
    return returnString;
  }
  
  

}); 