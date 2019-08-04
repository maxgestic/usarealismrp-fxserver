//# by: minipunch
//# for USA REALISM rp
//# Phone script to make phone calls and send texts in game with GUI phone
//# requires database(s): "phones"

var phone = {};
var current_activity = "";
var loadedConversations = {};

function DeleteContact(number_to_delete) {
    var size = Object.keys(phone.contacts).length;
    for (x = 0; x < size - 1; ++x) {
        if (phone.contacts[x].number == number_to_delete) {
            phone.contacts[x] = null;
        }
    }
}

// contact actions menu
function showContactActions(index) {
    var contact = phone.contacts[index];
    $("#contacts-table-wrap").hide();
    var html = "";
    html += "<div class='contact-info' style='text-align: center;color: white;margin-bottom:0;margin-top:2em;padding:0;'>";
    html += "<p style='margin-bottom: 0;'>Name: " + contact.first + " " + contact.last + "</p>";
    html += "<p>Number: " + contact.number + "</p>";
    html += "</div>";
    html += "<ul style='margin-top:0;'>;";
    html += "<li id ='contact-action--call' data-number='" + contact.number + "'><a href='#' class='app-button'>Call</a></li>";
    html += "<li id ='contact-action--message' data-number='" + contact.number + "'><a href='#' class='app-button'>Message</a></li>";
    html += "<li id='contact-action--delete' data-number='" + contact.number + "'><a href='#' class='app-button'>Delete</a></li>";
    html += "</ul>";
    $("#contact-actions-wrap").html(html);
}

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
            if (event.data.enable) {
                phone.number = event.data.number;
                phone.owner = event.data.owner;
            }
        } else if (event.data.type == "textMessage") {
            loadedConversations = event.data.conversations;
            for (var convo in loadedConversations) {
               // first reset to prevent duplications
              // add person
              $("#text-message-app-home section").append("<div class='textMessageConvoBtn' data-id='" + loadedConversations[convo].partnerId + "'>" + loadedConversations[convo].partnerName + "</div>");
				       $("#text-message-app-home section").css("overflow-y", "scroll");
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
        } else if (event.data.type == "loadedContacts") {
            phone.contacts = event.data.contacts;
            var size = Object.keys(phone.contacts).length;
            var html = "";
            html = "<table id='contacts-table'>";
            html += "<tr>";
            html += "<td>FIRST</td>";
            html += "<td>LAST</td>";
            html += "<td>NUMBER</td>";
            html += "</tr>";
            for (var i = size - 1; i >=0; i--) {
                html += "<tr onclick='showContactActions("+i+")'>";
                html += "<td>" + phone.contacts[i].first + "</td>";
                html += "<td>" + phone.contacts[i].last + "</td>";
                html += "<td>" + phone.contacts[i].number + "</td>";
                html += "</tr>";
            }
            html += "</table>";
            $("#contacts-table-wrap").html(html);
        } 
    })

    // handle's closing the phone gui
    document.onkeydown = function (data) {
        if (data.which == 27 || data.which == 112) { // ESC or F1
            // call lua client NUI callback in 'phone' resource with name of 'escape'
            $.post('http://usa-phone/escape', JSON.stringify({}));
            // hide all html
            $("#icons-wrap").show();
            $("#phone-app-wrap").hide();
            $("#contacts-app-wrap").hide();
            $("#text-message-app-wrap").hide();
            $("#text-message-app-home section").html(""); // prevent stacking of recent convos
            $("#text-message-app-home section").css("padding-right", "0px"); // set padding
            $("#text-message-app-home section").css("overflow-y", "hidden"); // set padding
            $("#quick-reply-arrow").remove();
        }
    };

    // on text msg form submission
    $("#text-message-app-form").submit(function(){
        $.post('http://usa-phone/sendTextMessage', JSON.stringify({
            toNumber: $("#text-toNumber").val(),
            message: $("#text-message").val(),
            fromName: phone.owner,
            fromNumber: phone.number
        }));
        $.post('http://usa-phone/escape', JSON.stringify({}));
    });

    // contact action message
    $("#contacts-app-wrap").on("click", "#contact-action--call", function() {
        var attr = $(this).attr("id");
        var number = $(this).attr("data-number"); // number to call (from contact)
        let randomChannel = Math.floor((Math.random() * 2000) + 500)
        $.post('http://usa-phone/requestCall', JSON.stringify({
          phone_number: number,
          from_number: phone.number,
          channel: randomChannel
        }));
        $.post('http://usa-phone/escape', JSON.stringify({})); // shut the phone
    });

    // contact action message
    $("#contacts-app-wrap").on("click", "#contact-action--message", function() {
        var attr = $(this).attr("id");
        var number = $(this).attr("data-number");
        $("#contacts-app-wrap").hide();
        $("#text-message-app-wrap").show();
        $("#text-message-app-home").hide();
        $("#text-message-app-form").show();
        // fill in reply number
        $("#text-message-app-form #text-toNumber").val(number);
        current_activity = "contact-message";
    });

    // contact action message
    $("#contacts-app-wrap").on("click", "#contact-action--message", function() {
        var attr = $(this).attr("id");
        var number = $(this).attr("data-number");
        $("#contacts-app-wrap").hide();
        $("#text-message-app-wrap").show();
        $("#text-message-app-home").hide();
        $("#text-message-app-form").show();
        // fill in reply number
        $("#text-message-app-form #text-toNumber").val(number);
        current_activity = "contact-message";
    });

    // contact action delete
    $("#contacts-app-wrap").on("click", "#contact-action--delete", function() {
        var number_to_delete = $(this).attr("data-number");
        var confirmed = confirm("Are you sure you want to permantently delete that contact?");
        if (confirmed) {
            DeleteContact(number_to_delete);
            $.post('http://usa-phone/deleteContact', JSON.stringify({
                numberToDelete: number_to_delete,
                phone: phone.number
            }));
            $("#contact-actions-wrap").html("");
            $("#contacts-table-wrap").hide();
            $("#contacts-app-wrap").hide();
            $("#icons-wrap").show();
        }
    });

    // new contact button
    $( "#new-contact-btn" ).click(function() {
        $("#contacts-app-home section").hide();
        $("#new-contact-form").show();
    });

    // submit new contact form
    $("#new-contact-form").submit(function(){
        $.post('http://usa-phone/addNewContact', JSON.stringify({
            number: $("#new-contact--number").val(),
            first: $("#new-contact--first").val(),
            last: $("#new-contact--last").val(),
            source: phone.number
        }));
        $.post('http://usa-phone/escape', JSON.stringify({}));
    });

    // new contact form back btn
    $( "#contact-form-back-btn" ).click(function() {
        $("#new-contact-form").hide();
        $("#contacts-app-home section").show();
    });

    // contact app back btn
    $( "#contacts-back-btn" ).click(function() {
        $("#contact-actions-wrap").html("");
        $("#contacts-app-wrap").hide();
        $("#new-contact-form").hide();
        $("#icons-wrap").show();
    });

    // contacts app button
    $( "#contacts-icon" ).click(function() {
        $("#icons-wrap").hide();
        $("#contacts-app-wrap").show();
        $("#contacts-app-home section").show();
        // todo: implement below nui callback
        $.post('http://usa-phone/getContacts', JSON.stringify({
            number: phone.number
        }));
    });

    $( "#phone-icon" ).click(function() {
        $("#icons-wrap").hide();
        $("#phone-app-wrap").show();
    });

        // show text msg conversation history
    $( "#text-message-icon" ).click(function() {
        $("#icons-wrap").hide();
        $("#text-message-app-wrap").show();
        $.post('http://usa-phone/getMessages', JSON.stringify({
            number: phone.number
        }));
        current_activity = "text-message";
    });

    // load specific convo with person
    $('#text-message-app-home section').on('click', '.textMessageConvoBtn', function() {
        var partnerName = $(this).text();
        var partnerId = $(this).attr("data-id");
        $.post('http://usa-phone/getMessagesFromConvo', JSON.stringify({
            partnerId: partnerId,
            sourcePhone: phone.number
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

    // sending message back button
    $("#sending-text-back-btn").click(function() {
        if (current_activity == "text-message") {
            $("#text-message-app-home").show();
            $("#text-message-app-form").hide();
            $("#text-message-app-home section").css("padding-right", "0px"); // set padding
            $("#text-message-app-home section").css("overflow-y", "hidden"); // set padding
        } else if (current_activity == "contact-message") {
            $("#text-message-app-form").hide();
            $("#contacts-app-wrap").show();
        }
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

    // calling (p2p voice)
    $("#call-btn").click(function() {
        $("#phone-btns").hide();
        $("#call-phone-app-form").show();
    });

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

    // Send a tweet inot the twittersphere
    $("#tweet-btn").click(function() {
        $("#phone-btns").hide();
        $("#tweet-phone-app-form").show();
    });

    // going back to phone app home from police form
    $(".phone-back-btn").click(function() {
        $("#phone-btns").show();
        // shut all forms
        $("#call-phone-app-form").hide();
        $("#911-phone-app-form").hide();
        $("#tow-phone-app-form").hide();
        $("#taxi-phone-app-form").hide();
        $("#tweet-phone-app-form").hide();
    });

    $("#phone-btns-back-btn").click(function() {
        $("#phone-app-wrap").hide();
        //$("#phone-btns").hide();
        $("#icons-wrap").show();
    });

    // p2p voice (phone call)
    $("#call-phone-app-form").submit(function(event) {
        event.preventDefault()
        let randomChannel = Math.floor((Math.random() * 2000) + 500)
        $.post('http://usa-phone/requestCall', JSON.stringify({
            phone_number: $("#phone-call").val(),
            from_number: phone.number,
            channel: randomChannel
        }));
        $.post('http://usa-phone/escape', JSON.stringify({}));
    });

    $("#911-phone-app-form").submit(function() {
        // send the message to police
        $.post('http://usa-phone/send911Message', JSON.stringify({
            message: $("#911-message").val()
        }));
        // close phone
        $.post('http://usa-phone/escape', JSON.stringify({}));
    });

    $("#taxi-phone-app-form").submit(function() {
        // send the message to ems
        $.post('http://usa-phone/sendTaxiMessage', JSON.stringify({
            message: $("#taxi-message").val()
        }));
        // close phone
        $.post('http://usa-phone/escape', JSON.stringify({}));
    });

    $("#tow-phone-app-form").submit(function() {
        // send the message to ems
        $.post('http://usa-phone/sendTowMessage', JSON.stringify({
            message: $("#tow-message").val()
        }));
        // close phone
        $.post('http://usa-phone/escape', JSON.stringify({}));
    });

    $("#tweet-phone-app-form").submit(function() {
        // send the message to ems
        $.post('http://usa-phone/sendTweet', JSON.stringify({
            message: $("#tweet-message").val()
        }));
        // close phone
        $.post('http://usa-phone/escape', JSON.stringify({}));
    });

});
