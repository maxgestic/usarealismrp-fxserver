var disableMouseScroll = true

var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

var rebook = false

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
            if (event.data.rebook){
                $("#heading").text("REBOOKING INFO:");
                if (event.data.values != null){
                    $("#id").val(event.data.values.id);
                    $("#charges").val("Rebooking For: ");
                    $("#sentence").val(event.data.values.time);
                    $("#security").val(event.data.values.security);
                    $("#fine").val("0");
                }
                $(".hideOnRebook").css("display", "none");
            }
            else{
                $("#heading").text("INTAKE INFO:");
                $(".hideOnRebook").css("display", "");
            }
            rebook = event.data.rebook;
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://usa_jail/escape', JSON.stringify({}));
            $("#jail-form-wrap").show();
            $("#chargesWrap").hide();
        } else if (data.which == 8) { // BACKSPACE
            $("#jail-form-wrap").show();
            $("#chargesWrap").hide();
        }
    };

    $("#jail-form").submit(function(e) {
        e.preventDefault(); // Prevent form from submitting
		
		var gender = "undefined";
		
		gender = $("input[type='radio']:checked").val();

        if (!rebook){
            $.post('http://usa_jail/submit', JSON.stringify({
                id: $("#id").val(),
                sentence: $("#sentence").val(),
                charges: $("#charges").val(),
                fine: $("#fine").val(),
    			gender: gender,
                security: $("#security").val()
            }));
        }else{
            $.post('http://usa_jail/resubmit', JSON.stringify({
                id: $("#id").val(),
                sentence: $("#sentence").val(),
                charges: $("#charges").val(),
                fine: $("#fine").val(),
                security: $("#security").val()
            }));
        }

        $("#id").val("");
        $("#name").val("");
        $("#sentence").val("");
        $("#fine").val("");
        $("#charges").val("");
        $("#medications").val("");
        $("#disorders").val("");
        $("#security").val("low");

    });

    // show list of criminal/vehicle/hs codes
    $("#chargesList").click(function(){
        $("#jail-form-wrap").hide();
        $("#chargesWrap").show();
    });

    $("#backButton").click(function(){
        $("#chargesWrap").hide();
        $("#jail-form-wrap").show();
    });

});
