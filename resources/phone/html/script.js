var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

var cursor = document.getElementById("cursor");
var cursorX = documentWidth / 2;
var cursorY = documentHeight / 2;

var loadedConversations = {};

function UpdateCursorPos() {
    cursor.style.left = cursorX;
    cursor.style.top = cursorY;
}

function Click(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
}

/*
    ================
    PHONE VARIABLES
    ================
*/

var phone = {};

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            cursor.style.display = event.data.enable ? "block" : "none";
            document.body.style.display = event.data.enable ? "block" : "none";
            if (event.data.enable) {
                phone = event.data.phone;
            }
        } else if (event.data.type == "click") {
            // Avoid clicking the cursor itself, click 1px to the top/left;
            Click(cursorX - 1, cursorY - 1);
        } else if (event.data.type == "textMessage") {
            loadedConversations = event.data.conversations;
            for (var convo in loadedConversations) {
               // first reset to prevent duplications
                // add person
                $("#text-message-app-home section").append("<div class='textMessageConvoBtn' data-id='" + loadedConversations[convo].partnerId + "'>" + loadedConversations[convo].partnerName + "</div>");
            }
        } else if (event.data.type == "messagesHaveLoaded") {
            var messages = event.data.messages;
            var size = Object.keys(messages).length;
            $("#text-message-app-home section").html(""); // make room for messages
            $("#text-message-app-home section").append("<div class='text-message-history'>");
            $("#text-message-app-home section").css("padding-right", "15px"); // set padding
            $("#text-message-app-home section").css("overflow-y", "scroll"); // set padding
            for (var i = size - 1; i >=0; i--) {
                $("#text-message-app-home section").append("<h5 style='margin-top:0;margin-bottom:0' class='text-from'>" + messages[i].from + " - <span style='font-size:10px;'>" + messages[i].timestamp + "</span></h5>")
                $("#text-message-app-home section").append("<p class='text-message'>" + messages[i].message + "</p>");
            }
            $("#text-message-app-home section").append("</div>");
            // ... then add the button for quick reply
            $("#text-home-back-btn").before("<div id='quick-reply-arrow' data-replyIdent= '"+event.data.replyIdent+"' class='quick-reply float-right'><span>&rang;</span></div>");
        }
    });

    $(document).mousemove(function(event) {
        cursorX = event.pageX;
        cursorY = event.pageY;
        UpdateCursorPos();
    });

    // handle's closing the phone gui
    document.onkeyup = function (data) {
        if (data.which == 27 || data.which == 112) { // ESC or F1
            // call lua client NUI callback in 'phone' resource with name of 'escape'
            $.post('http://phone/escape', JSON.stringify({}));
            // hide all html
            $("#icons-wrap").show();
            $("#phone-app-wrap").hide();
            $("#text-message-app-wrap").hide();
            $("#text-message-app-home section").html(""); // prevent stacking of recent convos
            $("#text-message-app-home section").css("padding-right", "0px"); // set padding
            $("#text-message-app-home section").css("overflow-y", "hidden"); // set padding
            $("#quick-reply-arrow").remove();
        }
    };

    // on text msg form submission
    $("#text-message-app-form").submit(function(){
        $.post('http://phone/sendTextMessage', JSON.stringify({
            toNumber: $("#text-toNumber").val(),
            message: $("#text-message").val(),
            fromName: phone.owner,
            fromNumber: phone.number
        }));
        $.post('http://phone/escape', JSON.stringify({}));
    });

    $( "#contacts-icon" ).click(function() {
        $("#icons-wrap").hide();
        $("#contacts-app-wrap").show();
    });

    $( "#phone-icon" ).click(function() {
        $("#icons-wrap").hide();
        $("#phone-app-wrap").show();
    });

        // show text msg conversation history
    $( "#text-message-icon" ).click(function() {
        $("#icons-wrap").hide();
        $("#text-message-app-wrap").show();
        $.post('http://phone/getMessages', JSON.stringify({
            number: phone.number
        }));
    });

    // load specific convo with person
    $('#text-message-app-home section').on('click', '.textMessageConvoBtn', function() {
        var partnerName = $(this).text();
        var partnerId = $(this).attr("data-id");
        $.post('http://phone/getMessagesFromConvo', JSON.stringify({
            partnerId: partnerId
        }));
    });

    // txt msg quick reply
    $('#text-message-app-home').on('click', '#quick-reply-arrow', function() {
        var replyIdent = $(this).attr("data-replyIdent");
        $("#text-message-app-home").hide();
        $("#text-message-app-form").show();
        // have user enter message for quick reply ...
        $("#text-message-app-form #text-toNumber").val(replyIdent);
    });

    // show form to send a new text
    $("#home-new-msg-btn").click(function() {
        $("#text-message-app-home").hide();
        $("#text-message-app-form").show();
    });

    // back to conversations
    $("#sending-text-back-btn").click(function() {
        $("#text-message-app-home").show();
        $("#text-message-app-form").hide();
        $("#text-message-app-home section").css("padding-right", "0px"); // set padding
        $("#text-message-app-home section").css("overflow-y", "hidden"); // set padding
    });

    // back btn to home screen
    $("#text-home-back-btn").click(function() {
        $("#icons-wrap").show();
        $("#text-message-app-wrap").hide();
        $("#text-message-app-home section").html(""); // prevent stacking of recent convos
        $("#text-message-app-home section").css("padding-right", "0px"); // set padding
        $("#text-message-app-home section").css("overflow-y", "hidden"); // set padding
        $("#quick-reply-arrow").remove();
    });

    /* PHONE APP BELOW */

    // 'calling' 911
    $("#911-btn").click(function() {
        $("#phone-btns").hide();
        $("#911-phone-app-form").show();
    });

    // 'calling' taxi
    $("#taxi-btn").click(function() {
        $("#phone-btns").hide();
        $("#taxi-phone-app-form").show();
    });

    // 'calling' tow
    $("#tow-btn").click(function() {
        $("#phone-btns").hide();
        $("#tow-phone-app-form").show();
    });

    // going back to phone app home from police form
    $(".phone-back-btn").click(function() {
        $("#phone-btns").show();
        // shut all forms
        $("#911-phone-app-form").hide();
        $("#tow-phone-app-form").hide();
        $("#taxi-phone-app-form").hide();
    });

    $("#phone-btns-back-btn").click(function() {
        $("#phone-app-wrap").hide();
        //$("#phone-btns").hide();
        $("#icons-wrap").show();
    });

    $("#911-phone-app-form").submit(function() {
        // send the message to police
        $.post('http://phone/send911Message', JSON.stringify({
            message: $("#911-message").val()
        }));
        // close phone
        $.post('http://phone/escape', JSON.stringify({}));
    });

    $("#ems-phone-app-form").submit(function() {
        // send the message to ems
        $.post('http://phone/sendEmsMessage', JSON.stringify({
            message: $("#ems-message").val()
        }));
        // close phone
        $.post('http://phone/escape', JSON.stringify({}));
    });

    $("#taxi-phone-app-form").submit(function() {
        // send the message to ems
        $.post('http://phone/sendTaxiMessage', JSON.stringify({
            message: $("#taxi-message").val()
        }));
        // close phone
        $.post('http://phone/escape', JSON.stringify({}));
    });

    $("#tow-phone-app-form").submit(function() {
        // send the message to ems
        $.post('http://phone/sendTowMessage', JSON.stringify({
            message: $("#tow-message").val()
        }));
        // close phone
        $.post('http://phone/escape', JSON.stringify({}));
    });

});
