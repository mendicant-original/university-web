// UW.Maps

UW.setupNamespace("Maps");


UW.Maps.init = function(points){
  var centerLatLng = new google.maps.LatLng(20,0);
  var mapOptions = {
    zoom: 2,
    center: centerLatLng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

  UW.Maps.markerIcon = new google.maps.MarkerImage('/images/marker.png',
      new google.maps.Size(40, 40),
      new google.maps.Point(0,0),
      new google.maps.Point(15, 36));

  UW.Maps.markerIconReversed = new google.maps.MarkerImage('/images/marker-reversed.png',
      new google.maps.Size(40, 40),
      new google.maps.Point(0,0),
      new google.maps.Point(15, 36));

  UW.Maps.markerShadow = new google.maps.MarkerImage('/images/marker-shadow.png',
      new google.maps.Size(40, 40),
      new google.maps.Point(0,0),
      new google.maps.Point(15, 36));

  UW.Maps.markers = [];

  $.each(points, function(latlng, people){
    var point = latlng.split(',');

    var marker = new google.maps.Marker({
      position:  new google.maps.LatLng(point[0],point[1]),
      map:       map,
      shadow:    UW.Maps.markerShadow,
      icon:      UW.Maps.markerIcon
    });
    UW.Maps.markers.push(marker);

    google.maps.event.addListener(marker, 'click', function(e) {
      UW.Maps.highlight(people);
      marker.setIcon(UW.Maps.markerIconReversed);
    });
  });

  google.maps.event.addListener(map, 'click',        UW.Maps.clearHighlight);
  google.maps.event.addListener(map, 'zoom_changed', UW.Maps.clearHighlight);
  google.maps.event.addListener(map, 'dragstart',    UW.Maps.clearHighlight);
}

UW.Maps.highlight = function(people) {
  UW.Maps.resetMarkers();
  $('.alumnus').removeClass('highlight')
  $(people).each(function() {
    $('#alumnus-' + this).addClass('highlight')
  });
};

UW.Maps.clearHighlight = function() {
  UW.Maps.resetMarkers();
  $('.alumnus').addClass('highlight')
};

UW.Maps.resetMarkers = function() {
  $.each(UW.Maps.markers, function() { this.setIcon(UW.Maps.markerIcon) });
};
