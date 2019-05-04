$(function () {
	var characters = [];
	var freeSlot = 0;

	window.addEventListener('message', function (event) {
		if (event.data.type == "toggleMenu") {
			var menuStatus = event.data.menuStatus;
			var menu = event.data.menu;
			// show document
			document.body.style.display = menuStatus ? "flex" : "none";
			if (menu == "") return;

			$('.create').hide();
			$('.characters').show();
			$('#select').show();
			$('#delete').show();
			$('#birth').hide();
			$("#go").hide();
			$("#spawn-select-back").hide();
			$(".spawn-select").hide();
			$("#badly-placed-spawn-select-header").hide();
			$('a[href="http://character-selection/disconnect"]').show();
			$('a[href="http://character-selection/list"]').hide();
			$('.characters #character').remove();

			// event.data.characters = event.data.data.reverse();
			event.data.characters = event.data.data;
			characters = event.data.data;

			$('#new').on('click', function () {
				$('.create').show();
				$('.characters').hide();
				$('#select').hide();
				$('#delete').hide();
				$('#birth').show();
				$('a[href="http://character-selection/disconnect"]').hide();
				$('a[href="http://character-selection/list"]').show();

				$('.option p').on("click", function () {
					clicked = this;
					$('.option p').each(function () {
						if (clicked != this) $(this).removeClass("selected");
					})
					$(this).addClass("selected");
				})

				if (typeof characters != 'undefined') {
					for (var x = 0; x < characters.length; x++) {
						freeSlot = x;
						const character = characters[freeSlot];
						if (!character.firstName) break;
					}
				}

				$('#birth').on('click', function () {
					var first_name = $('#first_name').val();
					var last_name = $('#last_name').val();
					var gender = $('.option p.selected').attr('id');

					var dob = new Date($("input[name='date_of_birth']").val());
					day = dob.getDate();
					month = dob.getMonth() + 1;
					year = dob.getFullYear();

					if (first_name.length > 2 && last_name.length > 2 && (year > 1900 || year < 2001 || !isNaN(day) || !isNaN(month) || !isNaN(year))) {
						var newCharData = {
							firstName: $("input[name='first_name']").val(),
							middleName: $("input[name='middle_name']").val(),
							lastName: $("input[name='last_name']").val(),
							dateOfBirth: $("input[name='date_of_birth']").val(),
							slot: freeSlot + 1
						}

						$.post('http://character-selection/new-character-submit', JSON.stringify(newCharData));
					} else {
						$('.notification').show()
						$('.notification').html("Uh-oh! You didn't supply enough information, please try again.")
					}
				})
			});

			if (!event.data.characters) return;

			if (event.data.characters.length == 3) {
				var t = 0;
				for (var i = 0; i < event.data.characters.length; i++) {
					if (event.data.characters[i].firstName) t++;
				}
				if (t === 3) $('#new').css("display", "none");
			}

			for (var i = 0; i < event.data.characters.length; i++) {
				if (!event.data.characters[i].firstName) continue;
				var div = document.createElement("div");
				div.id = "character"
				div.classList.add('character');
				div.dataset.selected = i;
				var first_name = document.createElement("h3");
				first_name.innerHTML = "<b>First Name:</b> " + event.data.characters[i].firstName
				div.appendChild(first_name);
				var last_name = document.createElement("h3");
				last_name.innerHTML = "<b>Last Name:</b> " + event.data.characters[i].lastName
				div.appendChild(last_name);
				var cash = document.createElement("h3");
				cash.innerHTML = "<b>Cash:</b> <span>$</span>" + (event.data.characters[i].money).formatMoney(2, '.', ',');
				cash.style = "padding-top: 25px"
				div.appendChild(cash);
				var bank = document.createElement("h3");
				bank.innerHTML = "<b>Bank:</b> <span>$</span>" + (event.data.characters[i].bank).formatMoney(2, '.', ',');
				div.appendChild(bank);
				var dob = document.createElement("h3");
				dob.innerHTML = "<b>DOB:</b> " + event.data.characters[i].dateOfBirth;
				dob.style = "padding-top: 25px";
				div.appendChild(dob);
				$('.characters').prepend(div);
			}

			$('.characters #character').on("click", function () {
				clicked = this;
				$(this).addClass("selected");
				$("button#select").removeClass("disabled");
				$("button#delete").removeClass("disabled");
				$('.characters #character').each(function () {
					if (clicked != this) $(this).removeClass("selected");
				})
			})

			var selected;
			var selected_spawn = "Paleto Bay";

			$("button#select").on('click', function () {
				/* store which character index was selected */
				var i = 0;
				$('.characters #character').each(function () {
					if (clicked == this) {
						selected = this.dataset.selected;
					}
					i++;
				});

				/* go to spawn selection screen */
				$('.characters').hide();
				$('#select').hide();
				$('#delete').hide();
				$('a[href="http://character-selection/disconnect"]').hide();

				$('.spawn-select').show();
				$('#go').show();
				$("#spawn-select-back").show();
				$("#badly-placed-spawn-select-header").show();

				$("#spawn-point--saved section").text("Property");
				$("#spawn-point--saved").show();

			})

			$("button#delete").on('click', function () {
				var i = 0, selected;
				$('.characters #character').each(function () {
					if (clicked == this) selected = this.dataset.selected
					i++;
				});

				const modal = document.getElementById('confirm');
				const deleteName = document.getElementById('confirm_name');
				const deleteChar = document.getElementById('confirm_delete');
				const cancelChar = document.getElementById('confirm_cancel');

				modal.showModal();

				var char = event.data.characters[selected];
				deleteName.innerText = `${char.firstName} ${char.lastName}`;

				deleteChar.addEventListener('click', function () {
					$.post('http://character-selection/delete-character', JSON.stringify({ slot: selected }));
					modal.close('removed');
				});

				cancelChar.addEventListener('click', function () {
					modal.close('cancled');
				});
			});

			$("button#go").on('click', function() {
				if (!$(this).hasClass("disabled")) {

					$.post('http://character-selection/select-character', JSON.stringify({
						character: event.data.characters[selected],
						slot: selected,
						spawn: selected_spawn
					}));

				}
			});

			$(".spawn-select .spawn-point").on('click', function() {
				$('.spawn-select .spawn-point').each(function () {
					$(this).css("border", "2px solid #ddd");
				})
				$(this).css("border", "2px solid #308bcd");
				$("button#go").removeClass("disabled");
				selected_spawn = $(this).text();
			});

			$("#spawn-select-back").on('click', function() {
				/* go to characters screen */
				$('.spawn-select').hide();
				$('#go').hide();
				$("#spawn-select-back").hide();
				$("#badly-placed-spawn-select-header").hide();

				$('.characters').show();
				$('#select').show();
				$('#delete').show();
				$('a[href="http://character-selection/disconnect"]').show();
			});

		} else if (event.data.type == "error") {
			document.getElementsByClassName('notification')[0].style.display = "block";
		} else if (event.data.type == "delete") {
			if (event.data.status !== "fail") return;
			$('.notification').show()
			$('.notification').html("Can't delete a character whose age is less than three days.")
		}
	});

	Number.prototype.formatMoney = function (c, d, t) {
		var n = this,
			c = isNaN(c = Math.abs(c)) ? 2 : c,
			d = d == undefined ? "." : d,
			t = t == undefined ? "," : t,
			s = n < 0 ? "-" : "",
			i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
			j = (j = i.length) > 3 ? j % 3 : 0;
		return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
	};
});
