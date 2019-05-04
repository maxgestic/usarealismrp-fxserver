$(function() {
  window.addEventListener('message', function(event) {
    if (event.data.type == "enableui") {
      document.body.style.display = event.data.enable ? "block" : "none";
      if (event.data.enable) {
        if (event.data.blindfold) {
          $("#blindfold").show();
        } else {
          $("#blindfold").hide();
        }
      }
    }
  });

  document.onkeyup = function (data) {
    if (data.which == 27) { // Escape key
      $.post('http://usa_rp/escape', JSON.stringify({}));
    }
  };
});
