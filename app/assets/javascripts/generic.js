$(document).ready(function(){
	$('#signup_dial').hide();

	$('#j_signup_action').click(
		function() {
			$('#signup_dial').dialog();
	});
});