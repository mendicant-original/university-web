// UW.Maps

UW.setupNamespace("Maps");


UW.Maps.showInfoWindow = function(position, people) {
  // set vertical position of content and pointer
  var pointer_y      = position.y - 35,
      content_height = 80 * Math.min(3, people.length),
      content_top    = pointer_y - (content_height / 2);

  $('#info_window #pointer').css({top: pointer_y + "px"});
  $('#info_window #content').css({height: content_height + 'px',
                                     top: content_top    + 'px'});

  $('#info_window #content').toggleClass('scrollable', people.length > 3);

  // render person template with people data into content area
  $('#info_window #content').html("");
  $.each(people, function(idx, person) {
    $("#person-template").tmpl(person).appendTo("#info_window #content");
  });

  // set left/right position of entire infowindow
  $('#info_window').removeClass('left').removeClass('right');

  var left = (position.x + 30) + "px";
  if (position.x > 465) {
    $('#info_window').addClass('right');
    left = (position.x - 320) + "px";
  } else {
    $('#info_window').addClass('left');
  }

  $('#info_window').
    css({left: left}).
    fadeIn('fast');
}

UW.Maps.hideInfoWindow = function() {
  $('#info_window').hide() // fadeOut seems to have problems here
}

UW.Maps.init = function(points){
  var markers = [];
  var centerLatLng = new google.maps.LatLng(20,0);
  var mapOptions = {
    zoom: 2,
    center: centerLatLng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

  var image = new google.maps.MarkerImage('images/marker.png',
      new google.maps.Size(40, 40),
      new google.maps.Point(0,0),
      new google.maps.Point(15, 36));

  var shadow = new google.maps.MarkerImage('images/marker-shadow.png',
      new google.maps.Size(40, 40),
      new google.maps.Point(0,0),
      new google.maps.Point(15, 36));

  // this "overlay" is just to give us an API to get pixel coordinates
  // from lat/lng values
  var translate = new google.maps.OverlayView();
  translate.draw = function() {};
  translate.setMap(map);

  $.each(points, function(latlng, people){
    latlng = latlng.split(',');

    var marker = new google.maps.Marker({
      position:  new google.maps.LatLng(latlng[0], latlng[1]),
      map:       map,
      shadow:    shadow,
      icon:      image
    });
    markers.push(marker);

    google.maps.event.addListener(marker, 'click', function(e) {
      var pos  = translate.getProjection().
        fromLatLngToContainerPixel(marker.getPosition());

      UW.Maps.showInfoWindow(pos, people);
    });

  });

  google.maps.event.addListener(map, 'click',        UW.Maps.hideInfoWindow);
  google.maps.event.addListener(map, 'zoom_changed', UW.Maps.hideInfoWindow);
  google.maps.event.addListener(map, 'dragstart',    UW.Maps.hideInfoWindow);
}
