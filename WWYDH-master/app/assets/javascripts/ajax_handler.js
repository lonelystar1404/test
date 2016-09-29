$(function() {
  // hide it first
  $("#spinner").hide();

  // when an ajax request starts, show spinner
  $(document).ajaxStart(function(){
    $("#spinner").fadeIn("fast");
  });

  // when an ajax request complets, hide spinner
  $(document).ajaxStop(function(){
    $("#spinner").fadeOut("fast");
  });
});
