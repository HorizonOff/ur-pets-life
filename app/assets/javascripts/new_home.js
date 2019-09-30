$(document).on('turbolinks:load', function(){
	
	var android = (/android/i.test(navigator.userAgent.toLowerCase()));
	var ios = (/iphone|ipod/i.test(navigator.userAgent.toLowerCase()));
	
	if (android) { $('#android').css({ display : 'block' }); }
	if (ios) { $('#ios').css({ display : 'block' }); }
	
//	=============================================================================
		
	var itemsCount = $('#brands .container').children().length;
	var currentPage = 0;
		
	function scrollGallery(isRight) {
				
		var width = $('#brands .container .item').width() + 20;
		var step = (width * currentPage);
		var xScrool = isRight ? width + step : step - width;
		
		var isScroll = isRight ? currentPage + 2 > itemsCount : currentPage - 1 < 0;
		if (isScroll) { return }
		
		$('#brands .container').animate({ scrollLeft: xScrool }, 400);
		currentPage = isRight ? currentPage + 1 : currentPage - 1;
		
	}
		
	$('#brands_left').click(function() { scrollGallery(false); });
	$('#brands_right').click(function() { scrollGallery(true); });

// ====================================================================================
	
	var startTouch;
	var startContent;
	
	function touchLenght() { return startTouch - window.event.changedTouches[0].clientX; }	
	function doScroll(xPos) { $('#brands .container').scrollLeft(xPos); }
	function autoScroll(xPos) { $('#brands .container').animate({ scrollLeft: xPos }, 500); }
	
	$('#brands .container').on('touchstart', function(e) {
		startTouch = window.event.changedTouches[0].clientX;
		startContent = $('#brands .container').scrollLeft()
	});
	
	$('#brands .container').on('touchend', function(e) {
		
		var side = touchLenght();
		if (side >= 200) { currentPage += 2; scrollGallery(true)}
		if (side <= -200) { currentPage -= 2; scrollGallery(false)}
		if (side <= 200 && side >= - 200) {autoScroll(startContent)}
		
	});
	
	$('#brands .container').on('touchmove', function(e) {
		doScroll(startContent + touchLenght()); 
	});
	
	
// ====================================================================================
    if (window.location.href.indexOf("index") > -1) {
        var isShow = false;
        var isRotateArrow = false;
        var nextItem;
        var pageSections = [
            {name: 'Return To Top', pos: 0},
            {name: 'What\'s Up', pos: $('#whats_up_section').position().top - 80},
            {name: 'Loyalty Program', pos: $('#loyalty_section').position().top - 90},
            {name: 'Connects Pets Owner', pos: $('#connect_section').position().top - 90},
            {name: 'One Time Set Up', pos: $('#start_section').position().top + 600 }
        ];
        var minShow = pageSections[1].pos;

        function scrollPageTo(yPos) { $('html, body').animate({ scrollTop: yPos }, 400);}


        $('#scroll').click(function() { scrollPageTo(pageSections[1].pos) });

        function showingDownload(topPos) {
            if (isShow == false && topPos >= minShow) {
                isShow = true;
                $('.download').animate({ bottom: 0 }, 400);
            } else if (isShow && topPos <= minShow) {
                isShow = false;
                $('.download').animate({ bottom: -200 }, 400);
            }
        }

        function currentPosition(topPos) {
            var current = pageSections.filter(e => e.pos <= topPos).length - 1;
            nextItem = current + 1 > pageSections.length - 1 ? 0 : current + 1;
            var btnText = nextItem == 0 ? pageSections[nextItem].name : "Next: " + pageSections[nextItem].name;
            $('#text').text(btnText);

            if (nextItem == 0 && !isRotateArrow) {
                isRotateArrow = true;
                rotateArrow(-180);
            } else if (nextItem != 0 && isRotateArrow) {
                isRotateArrow = false;
                rotateArrow(0)
            }
        }

        function rotateArrow(degris){
            $('#arrow').animate({deg: degris}, {  duration: 200, step: function(now) {
                    $('#arrow').css({ transform: 'rotate(' + now + 'deg)' })
                }
            });
        }

        $(window).scroll(function() {
            var topPos = $(window).scrollTop();
            currentPosition(topPos);
            showingDownload(topPos);
        });

        $('#next_scroll').click(function() {
            scrollPageTo(pageSections[nextItem].pos + 10);
        });
    }

    // ====================================================================================


	var isCloseContainer = true;

	$('#view_all_home').click(function() {
		$('#view_all_home').text(isCloseContainer ? "Hide" : "View all");
		$('.close').animate({ height: isCloseContainer ? 2700 : 1410 }, 800);
		isCloseContainer = !isCloseContainer;
	});
});