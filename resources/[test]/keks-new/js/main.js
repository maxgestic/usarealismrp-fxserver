(function($) {
  "use strict";

  $(document).ready(function (){

    // backstretch
    $(".carousel-bg").backstretch([
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

    /* BEGIN HOWL RADIO PLAYER */
    var Radio = function(station) {
      var self = this;
      self.station = station;
      self.isPlaying = false;
    };

    Radio.prototype = {
      play: function() {
        var self = this;
        var sound;

        var data = self.station;

        // If we already loaded this track, use the current one.
        // Otherwise, setup and load a new Howl.
        if (data.howl) {
          sound = data.howl;
        } else {
          sound = data.howl = new Howl({
            src: data.src,
            html5: true, // A live stream can only be played through HTML5 Audio.
            format: ['mp3', 'aac']
          });
        }

        // Begin playing the sound.
        sound.play();

        //sound.volume(0.1);
        sound.fade(0.0, 0.1, 5000);

        self.isPlaying = true;
      },
      stop: function() {
        var self = this;

        // Get the Howl we want to manipulate.
        var sound = self.station.howl;

        // Stop the sound.
        if (sound) {
          sound.stop();
        }
      },
      toggle: function() {
        var self = this;

        // Get the Howl we want to manipulate.
        var sound = self.station.howl;

        // Stop the sound.
        if (sound) {
          if (self.isPlaying)
            sound.volume(0.0);
          else
            sound.volume(0.1);
          self.isPlaying = !self.isPlaying;
        }
      }
    };

	var src;

	if (Math.random() > 0.5)
		src = 'http://ice1.somafm.com/beatblender-128-mp3'; // dance / house
	else
		src = 'http://tunein4.streamguys1.com/hhbeafree5'; // hip hop

    // Setup our new radio and pass in the stations.
    var radio = new Radio({
      src: src,
      volume: 0.35,
      howl: null
    });

    radio.play();

    $("body").on("click", function() {
      radio.toggle();
    });

  });

})(jQuery);
