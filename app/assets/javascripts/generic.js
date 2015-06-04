$(document).on("page:change", function(){
	$('#signin_dial').hide();

	$('#j_signin_action').click(
		function() {
			$('#signin_dial').dialog();
	});

	$('#editprofil_dial').hide();

	$('#j_editprofil_action').click(
		function() {
			$('#editprofil_dial').dialog();
	});
});