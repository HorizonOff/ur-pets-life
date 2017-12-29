function init_map(){
  var marker
  var center_location = check_center_for_start();
  var geocoder = new google.maps.Geocoder();
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 12,
    center: center_location || {lat: 25.276987, lng: 55.296249 }
  });

  if (center_location)
    placeMarker(center_location);

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

  function check_center_for_start(){
    var lat = $("input[name*='latitude']").val();
    var lng = $("input[name*='longitude']").val();
    if (lat && lng){
      return {lat: parseFloat(lat), lng: parseFloat(lng)};
    }
  };

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

  $('.check_geocoder').on('change', function(){
    check_fields();
  });
  $('input.flat#building_type').on('ifClicked', function(event){
    check_fields();
  });
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

function remove_location_params(){
  $("input[name*='latitude']").val(null)
  $("input[name*='longitude']").val(null)
}

function set_location_params(location){
  $("input[name*='latitude']").val(location.lat)
  $("input[name*='longitude']").val(location.lng)
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
