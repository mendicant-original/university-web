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

  var image = new google.maps.MarkerImage('images/marker.png',
      new google.maps.Size(40, 40),
      new google.maps.Point(0,0),
      new google.maps.Point(15, 36));

  var shadow = new google.maps.MarkerImage('images/marker-shadow.png',
      new google.maps.Size(40, 40),
      new google.maps.Point(0,0),
      new google.maps.Point(15, 36));

  $(points).each(function(p, point){
    new google.maps.Marker({
      position:  new google.maps.LatLng(point[0],point[1]),
      map:       map,
      shadow:    shadow,
      icon:      image
    });
  });
}
