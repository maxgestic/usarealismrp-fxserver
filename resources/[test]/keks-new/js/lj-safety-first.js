/*
  Author: Lumberjacks
  Template: Safety First (Coming Soon)
  Version: 1.0
  URL: http://themeforest.net/user/Lumberjacks/
*/

(function($) {
  "use strict";

  $(document).ready(function (){

    // Owl Carousel
    var owl = $('.lj-carousel');

    owl.owlCarousel({
      navigation : false,
      slideSpeed : 300,
      paginationSpeed : 400,
      responsiveRefreshRate : 0,
      rewindNav: false,
      singleItem: true,
      pagination : false,
      addClassActive: true,
      autoHeight : true,
      afterMove: selectMenuItem
    });

    // Owl Carousel - keyboard nav
    var owlkey = owl.data('owlCarousel');

    $(document.documentElement).keyup(function(event) {
        // handle cursor keys
        if (event.keyCode == 37) {
            owlkey.prev();
        } else if (event.keyCode == 39) {
            owlkey.next();
        }
    });

    // Owl Carousel - select active item in menu
    function selectMenuItem(){
      var currentItem = $('.owl-item.active').index();
      $('.activePage').removeClass('activePage');
      $('#slide-' + currentItem).addClass('activePage');
    }

    // Owl Carousel - menu elements
    $('.lj-menu a').filter(function(){ return this.id.match(/slide-?/); }).click(function(e){
      var slide = parseInt(this.id.substr(this.id.length - 1));
      owl.trigger('owl.goTo',slide);
      e.preventDefault();
    })

    // Owl Carousel - disabling dragging element(s) while sliding
    $(".disable-owl-swipe").on("touchstart mousedown", function(e) {
        e.stopPropagation();
    })

    // backstretch
    $("header").backstretch([
        "img/bg-1.jpg"
      , "img/bg-2.jpg"
      , "img/bg-3.jpg"
	  , "img/bg-4.jpg"
	  , "img/bg-5.jpg"
	  , "img/bg-6.jpg"
	  , "img/bg-7.jpg"
	  , "img/bg-8.jpg"
	  , "img/bg-9.jpg"
    ],{duration: 4400, fade: 1500});

    // Header's wrapper vertical centering
    function wrapperCentering(){
      var wrapper_height = $('.wrapper').height();
      var negative_margin = -(wrapper_height / 2);
      $('.wrapper').css({'marginTop':negative_margin+'px'});
    }

    wrapperCentering();

    /* Load USARRP.NET gallery images */
	/*
    $.ajax({
      url: "https://www.usarrp.net/api/gallery/images",

      beforeSend: function( xhr ) {
        xhr.setRequestHeader ("Authorization", "Basic " + btoa("5f220a6c894e0aefc03fec8fbdbc0df4:"));
      }

    })
    .done(function( data ) {
      if ( console && console.log ) {
        //console.log( "Sample of data:", data.slice( 0, 100 ) );
        console.log("hey, ajax finished...");
      }
    });
	*/

  });

  // Preloader
  // Change delay and fadeOut speed (in miliseconds)
  $(window).load(function() {
    $(".lj-preloader").delay(4000).fadeOut(6000);
  });

})(jQuery);
