$(document).on("change", ".changed_subtotal", _.debounce(getCalculatedPrice, 500));
$(document).on("change", '.item_change', getOrderQuantity);

function getCalculatedPrice(){
    var admin_discount = $('#order_admin_discount').val();
    var redeem_points = $('#order_RedeemPoints').val();
    var user_id = $('#user_id').val();
    var order_items = [];

    $('.order_item').each(function () {
        var item_id = $(this).find('.item_id').val();
        var quantity = $(this).find('.quantity').val();
        order_items.push({item_id: item_id, quantity: quantity});
    });

    $.ajax({
        type: 'get',
        url: '/admin_panel/calculating_price',
        data: { item: { admin_discount: admin_discount, RedeemPoints: redeem_points, user_id: user_id, order_items: [ order_items ] }}
    }).done(function (data) {
        $('.subtotal_price')[0].innerHTML = data['subtotal'];
        $('.total_price')[0].innerHTML = data['total'];
    }).fail(function (jqXHR, ajaxOptions, thrownError) {
        console.log('server not responding...');
    });
}

function getOrderQuantity(e){
    var $self = $(e.target);
    var parent = $self.closest('.order_item');
    var curNumField = parent.find('.max_quantity');
    var item_id = $self.context.value;
    curNumField.attr("disabled", "disabled");

    $.ajax({
        type: 'get',
        url: '/admin_panel/max_quantity',
        data: { item: { item_id: item_id } }
    }).done(function (data) {
        curNumField.attr({
            "max" : data['quantity']
        });
        curNumField.removeAttr("disabled");
    }).fail(function (jqXHR, ajaxOptions, thrownError) {
        console.log('server not responding...');
    });
}
