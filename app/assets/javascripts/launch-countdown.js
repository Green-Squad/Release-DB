$(document).ready(function() {
  $('.date').each(function() {
    var _this = $(this)
    launchDate = Date.parse($(this).data('launch-date'));
    if(launchDate && launchDate > Date.today()) {
      countdown(launchDate, function(ts) {
        _this.html(ts.toHTML());
      }, countdown.YEARS | countdown.MONTHS | countdown.DAYS | countdown.HOURS | countdown.MINUTES | countdown.SECONDS);
    }
  });
}); 