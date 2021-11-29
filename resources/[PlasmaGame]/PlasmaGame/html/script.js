var currentShop = ""
$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";
			currentShop = event.data.shop
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27) { // Escape key
			$.post('https://PlasmaGame/escape', JSON.stringify({}));
		}
	};
	
	$("#register").submit(function(event) {
		event.preventDefault(); // Prevent form from submitting

		// Verify date
		
		$.post('https://PlasmaGame/validate', JSON.stringify({
			
			sessionname: $("#sessionName").val(),
			creatorname: $("#creatorPseudo").val(),
			nbpersequip: $("#NbPersEquip").val(),
			nbmanche: $("#NbManche").val(),
			gamemode: $("#GameMode").val(),
			maps: $("#Maps").val(),
			curshop: currentShop,

		}));
	});
});
