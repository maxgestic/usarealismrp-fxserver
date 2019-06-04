<template>
	<div id="screen">
		<div id="app-list">
			<router-link to="/phone">
				<div class="app-button-container">
					<img src="https://www.yourenergysolutions.com/wp-content/uploads/2018/11/Phone-Icon.png" alt="Phone Icon" height="150">
					<span>Phone</span>
				</div>
			</router-link>
			<!--
			<router-link to="/messages"></router-link>
			<router-link to="/contacts"></router-link>
			<router-link to="/settings"></router-link>
			-->
		</div>
		<div id="app-content">
			<router-view></router-view>
		</div>
  </div>
</template>

<script>
export default {

}
</script>

<style>
  *, *::before, *::after {
  	box-sizing: border-box;
  }

	#screen {
		min-height: 60vh;
		min-width: 25vw;
		background-color: lightgray;
	}
</style>
