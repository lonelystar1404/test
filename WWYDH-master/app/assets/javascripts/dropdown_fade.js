$(function() {

  var dropdown_toggle = $('#dropdown_toggle');
  var dropdown_menu = $('#dropdown_toggle > .dropdown-menu');

  dropdown_toggle.click(function() {
    if (dropdown_menu.css('display') == 'none') {
      dropdown_menu.fadeIn(250);
    }
    else {
      dropdown_menu.fadeOut(250);
    }
  });

  dropdown_toggle.focusout(function() {
    dropdown_menu.fadeOut(250);
  });

});
