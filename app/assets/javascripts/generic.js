$(document).ready(function(){
	$('#signin_dial').hide();

	$('#j_signin_action').click(
		function() {
			$('#signin_dial').dialog();
	});
});