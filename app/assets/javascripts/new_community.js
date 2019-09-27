$(document).on('turbolinks:load',function() {
	
	var itemsCount = $('.corusel').children().length;
	var currentPage = 0;
		
	function scrollGallery(isRight) {
		
		var width = $('.gallery').width() + 30;
		var step = (width * currentPage);
		var xScrool = isRight ? width + step : step - width;
		
		var isScroll = isRight ? currentPage + 2 > itemsCount : currentPage - 1 < 0;
		if (isScroll) { return }
		
		$('.corusel').animate({ scrollLeft: xScrool }, 400);
		currentPage = isRight ? currentPage + 1 : currentPage - 1;
		
		changePoint()

	}
	
	function changePoint() {
		var e = $('.page').children();
		e.each(element => {
			if (element == currentPage) {
				e[element].className ="point active";
			} else {
				e[element].className = "point";
			}
		});
	}
	
	changePoint()
	
	$('.left').click(function() { scrollGallery(false); });
	$('.right').click(function() { scrollGallery(true); });
	
//-------------------------------------------------------------------
	
	var startTouch;
	var startContent;
	
	function touchLenght() { return startTouch - window.event.changedTouches[0].clientX; }	
	function doScroll(xPos) { $('.corusel').scrollLeft(xPos); }
	function autoScrollComunity(xPos) { $('.corusel').animate({ scrollLeft: xPos }, 500); }
	
	$('.corusel').on('touchstart', function(e) { 
		startTouch = window.event.changedTouches[0].clientX;
		startContent = $('.corusel').scrollLeft()
	});
	
	$('.corusel').on('touchend', function(e) { 
		
		var side = touchLenght();
		if (side >= 200) {scrollGallery(true)}
		if (side <= -200) {scrollGallery(false)}
		if (side <= 200 && side >= - 200) {autoScrollComunity(startContent)}
		
	});
	
	$('.corusel').on('touchmove', function(e) {
		doScroll(startContent + touchLenght()); 
	});
		
});