$(function () {
    $(document).ready(function() {
        window.addEventListener('message', function(event) {    
            switch(event.data.action) {
                case "update":
                    $('#name').html("AXON BODY | " + event.data.name );
                    $('#time').html(event.data.date);
                    $('#job').html(event.data.job);   
                    break;
                case "loadui":
                    $(".container").show();    
                    var top = "25" + 'px';
                    var right = "25" + 'px';
   
                    $('.container').css({
                        position:'absolute',
                        top:top,
                        right:right
                    });
                    
                    break;
                
                case "closeui":
                    $(".container").hide();
                    break;
                
                default:
            };
        });
    });
})