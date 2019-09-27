var android = (/android/i.test(navigator.userAgent.toLowerCase()));
var ios = (/iphone|ipod/i.test(navigator.userAgent.toLowerCase()));

$(document).on('turbolinks:load',function() {

    if (window.location.href.indexOf("contact_us") > -1) {

    var uluru = {lat: 25.118757, lng: 55.207353};
    var zoom = android || ios ? 20 : 17;
    var controlSize = android || ios ? 80 : 40;
    var map = new google.maps.Map(document.getElementById('map'), {zoom: zoom, center: uluru, zoomControl: true, controlSize: controlSize });
    var marker = new google.maps.Marker({position: uluru, map: map});

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