// JavaScript Document

$(document).ready(function() {




	$('.proslider').slick({
  slidesToShow: 6,
  slidesToScroll: 6,
  arrows: true,
  dots: false,
  autoplay: true,
  responsive: [
    {
      breakpoint: 1024,
      settings: {
        slidesToShow: 4,
        slidesToScroll: 1,
      }
    },
    {
      breakpoint: 600,
      settings: {
        slidesToShow: 2,
        slidesToScroll: 1
      }
    },
    {
      breakpoint: 480,
      settings: {
        slidesToShow: 1,
        slidesToScroll: 1
      }
    }
    // You can unslick at a given breakpoint now by adding:
    // settings: "unslick"
    // instead of a settings object
  ]
});


		//*****************************
    // Responsive Slider
    //*****************************
    var respsliders = {
      1: {slider : '.multiple-items'}

    };
    $.each(respsliders, function() {
        $(this.slider).slick({
            arrows: false,
            dots: true,
            autoplay: true,
            settings: "unslick",
            responsive: [
                {
                  breakpoint: 2000,
                  settings: "unslick"
                },
                {
                  breakpoint: 767,
                  settings: {
                    unslick: true
                  }
                }
            ]
        });

});

	});
