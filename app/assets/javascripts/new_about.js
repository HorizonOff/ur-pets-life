$(document).on('turbolinks:load',function() {
	
	var comments = $('.mobile_view').children().length;
	var itemWidth = $('.mobile_view').children().first().width();
	
	var startTouch;
	var startContent;
	
	function touchLenght() { return startTouch - window.event.changedTouches[0].clientX; }	
	function doScroll(xPos) { $('.mobile_view').scrollLeft(xPos); }
	function autoScroll(xPos) { $('.mobile_view').animate({ scrollLeft: xPos }, 500); }
	
	$('.mobile_view').on('touchstart', function(e) { 
		startTouch = window.event.changedTouches[0].clientX;
		startContent = $('.mobile_view').scrollLeft()
	});
	
	$('.mobile_view').on('touchend', function(e) { 
		
		var side = touchLenght();
		if (side >= 200) {autoScroll(startContent + itemWidth + 140)}
		if (side <= -200) {autoScroll(startContent - itemWidth - 140)}
		if (side <= 200 && side >= - 200) {autoScroll(startContent)}
		
	});
	
	$('.mobile_view').on('touchmove', function(e) {
		doScroll(startContent + touchLenght()); 
	});
	
// ===================================================================================
	
	var isCloseContainer = true;
	
	$('#view_all').click(function() {
		$('#view_all').text(isCloseContainer ? "View less" : "View all");
		$('.close').animate({ height: isCloseContainer ? 7415 : 1520 }, 800);
		isCloseContainer = !isCloseContainer;
	});
	
// ===================================================================================
	
	$('.long_comment .more').click(function() { 
		$('.long_comment .hide').show(); 
		$('.long_comment .more').hide();
	});
	
	$('.long_comment .hide_more').click(function() {
		$('.long_comment .hide').hide(); 
		$('.long_comment .more').show();
		$('.long_comment .hide_more').hide();
	});
		
});