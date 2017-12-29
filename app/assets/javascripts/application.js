// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require bootstrap.min
//= require custom
//= require icheck.min
//= require select2.full
//= require moment
//= require bootstrap-datetimepicker.min
//= require underscore
//= require gmaps/google

//= require_self
//= require_tree .

$(document).on('turbolinks:load', function() {
  init_all_functions()
});

$(document).on('turbolinks:load', function() {
  init_icheck();
  init_select2();
  init_timepicker();
	init_map();
});
	
function init_icheck(){
  if ($("input.flat")[0]) {
    $('input.flat').iCheck({
      checkboxClass: 'icheckbox_flat-green',
      radioClass: 'iradio_flat-green'
    });
    $('input.flat.day_and_night').on('ifChecked', function(event){
      $('.timepicker').prop('disabled', true);
    });
    $('input.flat.day_and_night').on('ifUnchecked', function(event){
      $('.timepicker').prop('disabled', false);
    });
    $('input.flat#building_type').on('ifToggled', function(event){
      if ($(this).val() == 'building') {
        show_and_enable_inputs($('div.building'))
        hide_and_disable_inputs($('div.villa'))
      } else {
        show_and_enable_inputs($('div.villa'))
        hide_and_disable_inputs($('div.building'))
      }
    });
  }
}

function show_and_enable_inputs(element) {
  element.show()
  element.find('input:disabled').prop('disabled', false);
}

function hide_and_disable_inputs(element) {
  element.hide()
  element.find('input:enabled').prop('disabled', true);
}

function init_select2(){
  if ($('.select2')[0]) {
    $('.select2').select2({
      placeholder: 'Select specializations...',
      allowClear: true,
      width: '100%'
    });
  }
}

function init_timepicker(){
  if ($('.timepicker')[0]) {
    $('.timepicker.open').datetimepicker({
      format: 'hh:mm A'
    })
    $('.timepicker.close_time').datetimepicker({
      format: 'hh:mm A',
      useCurrent: false
    })

    $('.timepicker').on('dp.change', function(e) {
      var element = $(e.target);
      var related_element = element.parent().siblings('div').find('.timepicker');
      if (element.hasClass('open')){
        related_element.data("DateTimePicker").minDate(e.date);
      } else {
        related_element.data("DateTimePicker").maxDate(e.date);
      }
    });
  }
}

function init_map(){
  $('.check_geocoder').on('change', function(){
    check_fields();
  });
  $('input.flat#building_type').on('ifClicked', function(event){
    check_fields();
  });
  
  var marker
  var geocoder = new google.maps.Geocoder();
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 12,
    center: {lat: 25.276987, lng: 55.296249 }
  });

  service = new google.maps.places.PlacesService(map);
  map.addListener('click', function(e) {
    if (e.placeId) {
      service.getDetails({
        placeId: e.placeId
      }, function(place, status) {
        var building_name = place.name
        var address_components = place.address_components
        parse_response(address_components, building_name)
      })
    } else {
      geocodePosition(e.latLng);
    }
    placeMarker(e.latLng);
    map.setCenter(e.latLng)
  });

  function geocodePosition(pos) {
    geocoder.geocode({
      latLng: pos
    }, function(responses) {
      if (responses && responses.length > 0) {
        var address_components = responses[0].address_components
        parse_response(address_components)
        $('#geocoding_error').hide()
        var location = responses[0].geometry.location
        set_location_params(location)
      } else {
        $('#geocoding_error').show()
        remove_location_params();
      }
    });
  }

  function parse_response(address_components, building_name){
    var building_name_value
    var city = address_components.find(LocationCity)
    var area = address_components.find(LocationArea)
    var street = address_components.find(LocationStreet)
    var number = address_components.find(LocationNumber)
    if (typeof(building_name) == 'undefined'){
      parsed_building_name = address_components.find(LocationBuildingName)
      if (typeof(parsed_building_name) != 'undefined') {
        building_name_value = parsed_building_name.long_name
      }
    } else {
      building_name_value = building_name
    }
    fill_inputs(city, area, street, building_name_value, number)
  }

   function geocodeAddress(address) {
    geocoder.geocode({
      address: address
    }, function(responses, status) {
      if (responses && responses.length > 0) {
        var location = responses[0].geometry.location
        map.setCenter(location);
        placeMarker(location);
        $('#geocoding_error').hide();
        set_location_params(location)
      } else {
        remove_marker()
        $('#geocoding_error').show();
        remove_location_params();
      }
    });

    function remove_marker(){
      if (marker){
        marker.setMap(null);
        marker = null
      }
    }
  }

  function placeMarker(location) {
    if (marker) {
      marker.setPosition(location);
    } else {
      marker = new google.maps.Marker({
        position: location,
        map: map
      });
    }
  }

  function check_fields(){
    var address = retrieve_address();
    geocodeAddress(address);
  }

  function retrieve_address(){
    var address = $("input.check_geocoder[name*='city']").val()
    address = address + ', ' + $("input.check_geocoder[name*='area']").val()
    address = address + ', ' + $("input.check_geocoder[name*='street']").val()
    if ($('#building_type').val() == 'building') {
      address = address + ' ' + $("input.check_geocoder[name*='unit_number']").val()
      address = address + ', ' + $("input.check_geocoder[name*='building_name']").val()
    } else {
      address = address + ' ' + $("input.check_geocoder[name*='villa_number']").val()
    }
    return address
  }
}
function remove_location_params(){
  $("input[name*='latitude']").val(null)
  $("input[name*='langitude']").val(null)
}

function set_location_params(location){
  $("input[name*='latitude']").val(location.lat)
  $("input[name*='langitude']").val(location.lng)
}

function LocationCity(element){
  return element.types.indexOf('locality') > -1
}

function LocationArea(element){
  return element.types.indexOf('sublocality_level_1') > -1
}

function LocationStreet(element){
  return element.types.indexOf('route') > -1
}

function LocationBuildingName(element){
  return element.types.indexOf('premise') > -1
}
function LocationNumber(element){
  return element.types.indexOf('street_number') > -1
}

function fill_inputs(city, area, street, building_name, number){
  if (typeof(city) != 'undefined') {
    $("input.check_geocoder[name*='city']").val(city.long_name)
  } else {
    $("input.check_geocoder[name*='city']").val('')
  }
  if (typeof(area) != 'undefined') {
    $("input.check_geocoder[name*='area']").val(area.long_name)
  } else {
    $("input.check_geocoder[name*='area']").val('')
  }
  if (typeof(street) != 'undefined') {
    $("input.check_geocoder[name*='street']").val(street.long_name)
  } else {
    $("input.check_geocoder[name*='street']").val('')
  }
  if (typeof(building_name) != 'undefined') {
    $("input.check_geocoder[name*='building_name']").val(building_name)
    if ($('input.flat#building_type:checked').val() != 'building'){
      $('input.flat#building_type.building').iCheck('check')
    }
  } else {
    $("input.check_geocoder[name*='building_name']").val('')
    if ($('input.flat#building_type:checked').val() == 'building'){
      $('input.flat#building_type.villa').iCheck('check')
    }
  }
  if (typeof(number) != 'undefined') {
    $("input.check_geocoder[name*='unit_number']").val(number.long_name)
    $("input.check_geocoder[name*='villa_number']").val(number.long_name)
  } else {
    $("input.check_geocoder[name*='unit_number']").val('')
    $("input.check_geocoder[name*='villa_number']").val('')
  }
}
