//= require jquery
//= require turbolinks
//= require rails-ujs
// = require new_home.js
// = require new_about.js
// = require new_community.js
// = require new_contact_us.js
// = require new_loyalty.js
// = require new_sale.js

$(document).on('turbolinks:load',function(){


    var navigation_list = [
        { page: 0, location : "index" },
        { page: 1, location : "about" },
        { page: 2, location : "loyalty" },
        { page: 2, location : "pay_it_forward" },
        { page: 3, location : "sale" },
        { page: 4, location : "community" },
        { page: 5, location : "contact_us" },
    ];

    var side_menu_list = [
        { page: 0, location : "index" },
        { page: 1, location : "about" },
        { page: 2, add:3, location : "loyalty" },
        { page: 2, add:4, location : "pay_it_forward" },
        { page: 5, location : "sale" },
        { page: 6, location : "community" },
        { page: 7, location : "contact_us" },
    ];

    navigation_list.map(function (item) {
        if (window.location.pathname.includes(item.location)) {
            let navbar = $('.navbar .desktop a');
            navbar[item.page].className = "tab active";
        }
    });

    side_menu_list.map(function (item) {
        if (window.location.pathname.includes(item.location)) {
            let sideMenu = $('.side_menu a');
            sideMenu[item.page].className = "tab active";

            if (item.page === 2) {
                sideMenu[item.add].className = "tab additional additional_active";
            }
        }
    });

	
	var isShow = false;
	
	$('.hamburger').click(function() {
		
		if (isShow) {
			$('.side_menu').hide();
			$('.hamburger').removeClass('is-active');
		} else {
			$('.side_menu').show();
			$('.side_menu').css({ display: 'flex' });
			$('.hamburger').addClass('is-active');
		}
		
		isShow = !isShow;
	});
	
	var android = (/android/i.test(navigator.userAgent.toLowerCase()));
	var ios = (/iphone|ipod/i.test(navigator.userAgent.toLowerCase()));
	
	if (android) { $('.b_ios').hide(); }
	if (ios) { $('.b_android').hide(); }
	
//=============================================================================
	
	var isShowDownload = false;

	$(window).scroll(function() {

	    var wLoc = window.location.pathname;
        if (wLoc.includes("/index") || wLoc.includes("/log_in") || wLoc.includes("/reset_password")) { return }

		var header = $('.b_header').position().top + 100;
		var bottom = $('.bottom').position().top - 800;

		var topPos = $(window).scrollTop();

		if (topPos > header && topPos < bottom ) {
			showingBadge(true)
		} else {
			showingBadge(false);
		}

	});

	function showingBadge(isShow) {

		if (!isShowDownload && isShow) {
			$('.b_donwnload').animate({ bottom: 0 }, 200);
			isShowDownload = !isShowDownload;
		} else if ( isShowDownload && !isShow ) {
			$('.b_donwnload').animate({ bottom: -200}, 200);
			isShowDownload = !isShowDownload;
		}
	}
	
//=============================================================================
	
	$('#loyalty').mouseover(function() { $('.navbar .desktop .context_menu').css({ display: "flex" }) });
	$('#loyalty').mouseout(function() { $('.navbar .desktop .context_menu').hide(); });
	$('.navbar .desktop .context_menu').mouseover(function() { $('.navbar .desktop .context_menu').css({ display: "flex" }) });
	$('.navbar .desktop .context_menu').mouseout(function() { $('.navbar .desktop .context_menu').hide(); });
	
});