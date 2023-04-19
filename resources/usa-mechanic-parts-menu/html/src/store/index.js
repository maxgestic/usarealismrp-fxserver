import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
	state: {
		playerName: "John Doe",
		rank: 1,
		availableParts: [],
		orderedParts: [],
		deliveredParts: [],
		itemImages: [],
		showNotification: false,
		notificationText: ""
	},
	getters: {
		menuData(state) {
			return state;
		},
	},
	mutations: {
		setMenuData(state, payload) {
			console.log("setting menu data, payload: " + JSON.stringify(payload))
			state = Object.assign(state, payload.data)
		},
	},
	actions: {},
});
