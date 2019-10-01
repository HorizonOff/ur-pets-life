$(document).on('turbolinks:load',function(){
    var pets_container = $('#pets_container');

	function removeActiveElement() {
		$('#pets_container .active').removeClass("active");
		$('#info_container .active').removeClass("active");
	}
	
	function changeActiveElement() {
		let container = pets_container.children();
		for (let i = 0; i < container.length; i++){
			let item = container[i];
			if (item.className === "loyalty_item active") {
				let lol = $('#info_container').children()[i];
				lol.className = "loyalty_info active";
			}
		}
	}
	
	$('.loyalty_item').click(function(e) {
		removeActiveElement();
		e.currentTarget.className = "loyalty_item active";
		changeActiveElement();
	});
	
	
//	-----------------------------------------------------
	var itemWidth = pets_container.children().first().width();
		
	function autoScrollLoyalty(isLeft) {

		let position = pets_container.scrollLeft();
		let side = isLeft ? -itemWidth - 20 : itemWidth + 20;
		
		let container = pets_container.children();
		let currentElement = (position + side)/itemWidth;
		let indexElement = Math.round(currentElement);
		
		if (indexElement > container.length - 1) {
			indexElement = container.length - 1;
		} else if ( indexElement < 0 ) {
			indexElement = 0;
		}
		
		removeActiveElement();
		let item = container[indexElement];
		item.className = "loyalty_item active";

        pets_container.animate({ scrollLeft: position + side }, 500);
		
		changeActiveElement();
	}

	$('#left_loyalty').click(function() { autoScrollLoyalty(true) });
	$('#right_loyalty').click(function() { autoScrollLoyalty(false) });
	
	
//	-----------------------------------------------------
	
	var startTouch;
	var startContent;
	
	function touchLenght() { return startTouch - window.event.changedTouches[0].clientX; }

    pets_container.on('touchstart', function(e) {
		startTouch = window.event.changedTouches[0].clientX;
		startContent = pets_container.scrollLeft()
	});

    pets_container.on('touchend', function(e) {
		
		var side = touchLenght();
		
		if (side >= 200) { autoScrollLoyalty(false); }
		if (side <= -200) { autoScrollLoyalty(true); }
		
	});
	
	
});