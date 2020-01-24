$(document).on("change", '.location_select', updateMap);

function updateMap(e){
    var location_id = $(e.target).context.value;
    var locationClass = $('.location_select');
    var locationImg = $('.location_img');

    locationClass.attr('disabled', 'disabled');

    $.ajax({
        type: 'get',
        url: '/admin_panel/location',
        data: { location_id: location_id }
    }).done(function (data) {
        locationImg.attr('src', data['img_url']);
        locationClass.removeAttr('disabled');
    }).fail(function (jqXHR, ajaxOptions, thrownError) {
        console.log('server not responding...');
    });
}