$(function(){
	window.onload = function(e){
		window.addEventListener('message', function(event){

			var item = event.data;
			if (item !== undefined && item.type === "info") {

				if (item.display === true) {
					$('#info').fadeIn("slow");
				} else if (item.display === false) {
					$('#info').fadeOut("slow");
				}
			}
		});

		document.addEventListener('keypress', (e) => {
			if (e.keyCode == 101 || e.keyCode == 13) {
				$.get('http://usa-info/accept', function(data) {});
			}
		});

		$("button").click(function(){
			$.get('http://usa-info/accept', function(data) {});
		});

	};
});
