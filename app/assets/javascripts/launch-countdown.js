$(document).ready(function() {
  $('.date').each(function() {
    var _this = $(this)
    countdown(Date.parse($(this).data('launch-date')), function(ts) {
      _this.html(ts.toHTML());
    }, countdown.YEARS | countdown.MONTHS | countdown.DAYS | countdown.HOURS | countdown.MINUTES | countdown.SECONDS);

  });
}); 