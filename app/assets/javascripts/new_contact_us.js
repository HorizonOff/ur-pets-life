$(document).on('turbolinks:load',function() {

    if (window.location.href.indexOf("contact_us") > -1) {

	$('.text_field').focusin(function(e) {
		var element = e.currentTarget.children[0];
		element.className = "placeholder active";
	});
	
	$('.text_field').focusout(function(e) {
		var element = e.currentTarget.children[1];
		if (element.value.length == 0) {
			var placeholder = e.currentTarget.children[0];
			placeholder.className = "placeholder";
		}
	});
	
}});