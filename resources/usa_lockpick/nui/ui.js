$(document).ready(function(){
 window.addEventListener( 'message', function( event ) {
        var item = event.data;
        if ( item.showPlayerMenu == 'open' ) {
            $('body').css('background-color','transparent');
            $('#divp').css('display','block');
        } else { // Hide the menu
            $('#divp').css('display', 'none');
            $('body').css('background-color','transparent important!');
            $("body").css("background-image","none");
        }
 } );
});
