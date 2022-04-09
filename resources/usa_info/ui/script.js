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
				$.get('http://usa_info/accept', function(data) {});
			}
		});

		$("button#close").click(function(){
			$.get('http://usa_info/accept', function(data) {})
		});

		$("button#commands").click(function() {
			ShowCommandListPage()
		})

		$("button#rules").click(function() {
			ShowRulesPage()
		})

		$("button.homeBtn").click(function() {
			ShowHomePage()
		})

		function ShowCommandListPage() {
			$("#help-and-rules").hide()
			$("#command-doc").show()
		}

		function ShowRulesPage() {
			$("#help-and-rules").hide()
			$("#rules-doc").show()
		}

		function ShowHomePage() {
			$("#command-doc,#rules-doc").hide()
			$("#help-and-rules").show()
		}

	};
});
