$(function(){
	window.onload = function(e){
		window.addEventListener('message', function(event){

			var item = event.data;
			if (item !== undefined && item.type === "rules") {

				if (item.display === true) {
					$('#rules').delay(1000).fadeIn("slow");
				} else if (item.display === false) {
					$('#rules').fadeOut("slow");
				}
			}
		});

		document.addEventListener('keypress', (e) => {
			if (e.keyCode == 101 || e.keyCode == 13) {
				$.get('http://rules/accept', function(data) {});
			}
		});
	};
});
