$(document).on('turbolinks:load',function() {
    if (window.location.href.indexOf("sale") > -1) {
        var url_string = window.location.href;
        var url = new URL(url_string);

        var petParam = url.searchParams.get("pet_type");
        var sortParam = url.searchParams.get("sort_type");


        if (petParam === "1") {
            $('#desktop_by_pets').children()[2].className = "active";
        } else if (petParam === "2") {
            $('#desktop_by_pets').children()[1].className = "active";
        } else {
            $('#desktop_by_pets').children()[0].className = "active";
        }

        if (sortParam === "max_price") {
            $('#sale_sort_by_price').val("Price: High to low")
        } else if (sortParam === "low_price") {
            $('#sale_sort_by_price').val("Price: Low to hight")
        } else {
            $('#sale_sort_by_price').val("Discount")
        }

        var petTypeArray = ["all", "2", "1"];
        var sortTypeArray = ["discount", "max_price", "low_price"];

        var sortByPrice = $('#sale_sort_by_price');
        sortByPrice.change(function () {
            afterChange()
        });

        var sortByPets = $('#desktop_by_pets button');
        sortByPets.click(function (e) {
            sortByPets.removeClass('active');
            e.currentTarget.className = "active";

            afterChange()
        });

        function afterChange() {

            let sortIndex = sortByPrice.prop('selectedIndex');
            let petIndex = $('#desktop_by_pets .active').index();

            let petType = petTypeArray[petIndex];
            let sortType = sortTypeArray[sortIndex];

            getSaleItems(petType, sortType)
        }

        function getSaleItems(petType, sortType) {

            window.location.href = "sale?pet_type=" + petType + "&sort_type=" + sortType;
        }
    }
});
