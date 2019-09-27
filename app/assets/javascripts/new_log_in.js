$(document).on('turbolinks:load',function(){
	
	$('.b_input').click(function(e) {
		let input = e.currentTarget.children[0].children[1];
		input.focus();
	});
	
	$('.b_input').focusin(function(e) {
		e.currentTarget.className = "b_input active";
	});
	
	$('.b_input').focusout(function(e) {
		let input = e.currentTarget.children[0].children[1];
		if (input.value.length == 0) {
			e.currentTarget.className = "b_input";
		}	
	});
	
	
	$('.visibility').mousedown(function(e) {
		let input = e.currentTarget.parentElement.children[1];
		input.type = "text";
	});
	
	$('.visibility').mouseup(function(e) {
		let input = e.currentTarget.parentElement.children[1];
		input.type = "password";
	});

	
});