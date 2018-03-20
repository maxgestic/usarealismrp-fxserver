var disableMouseScroll = true

var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://jail/escape', JSON.stringify({}));
            $("#jail-form-wrap").show();
            $("#chargesWrap").hide();
        } else if (data.which == 8) { // BACKSPACE
            $("#jail-form-wrap").show();
            $("#chargesWrap").hide();
        } else if (data.which == 13) { // ENTER
            if ($("#id").val() != "") {
                $("#jail-form").submit();
            }
        }
    };

    $("#jail-form").submit(function(e) {
        e.preventDefault(); // Prevent form from submitting
		
		var gender = "undefined";
		
		gender = $("input[type='radio']:checked").val();

        $.post('http://jail/submit', JSON.stringify({
            id: $("#id").val(),
            sentence: $("#sentence").val(),
            charges: $("#charges").val(),
            fine: $("#fine").val(),
			gender: gender
        }));

        $("#id").val("");
        $("#name").val("");
        $("#sentence").val("");
        $("#fine").val("");
        $("#charges").val("");
        $("#medications").val("");
        $("#disorders").val("");

    });

    // show list of criminal/vehicle/hs codes
    $("#chargesList").click(function(){
        $("#jail-form-wrap").hide();
        $("#chargesWrap").show();
    });

});
