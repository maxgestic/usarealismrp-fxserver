/* 
-- ██████╗░██╗░░░██╗██████╗░███████╗██╗░░░██╗███████╗░██████╗████████╗███╗░░██╗██╗██╗░░██╗
-- ██╔══██╗██║░░░██║██╔══██╗██╔════╝██║░░░██║██╔════╝██╔════╝╚══██╔══╝████╗░██║██║██║░██╔╝
-- ██████╦╝██║░░░██║██████╔╝█████╗░░╚██╗░██╔╝█████╗░░╚█████╗░░░░██║░░░██╔██╗██║██║█████═╝░
-- ██╔══██╗██║░░░██║██╔══██╗██╔══╝░░░╚████╔╝░██╔══╝░░░╚═══██╗░░░██║░░░██║╚████║██║██╔═██╗░
-- ██████╦╝╚██████╔╝██║░░██║███████╗░░╚██╔╝░░███████╗██████╔╝░░░██║░░░██║░╚███║██║██║░╚██╗
-- ╚═════╝░░╚═════╝░╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝╚═════╝░░░░╚═╝░░░╚═╝░░╚══╝╚═╝╚═╝░░╚═╝*/

var orangejob_lib = new Vue({
    el: ".orangejob_lib",
    data: {
	active: false,
	style: 0,
	buy: 40,
	sale: 30,
    },
    methods:{
        gostyle: function(index) {
            this.style = index;
        },
		btnsell: function() {
			$.post('https://Burevestnik_orangejob_lib/bur_sell_orangejob_lib', JSON.stringify({}));
			//console.log('SELL')
		},
		btnbuy: function() {
			$.post('https://Burevestnik_orangejob_lib/bur_buy_orangejob_lib', JSON.stringify({}));
			//console.log('BUY')
		},
		exit() {
			this.active = false;
			$.post('https://Burevestnik_orangejob_lib/bur_exit_orangejob_lib', JSON.stringify({}));
			$('body').hide();
			document.location.reload();
			return;
		},
		open(){
			this.active = true;
			$('body').show();
		},
    }
});

window.addEventListener('message', function(event) {
	var item = event.data;
	if (item.showUI) {
		orangejob_lib.open()
  	}
});

document.onkeyup = function (data){
	if (data.which == 27) {
    	orangejob_lib.exit()
	}
};