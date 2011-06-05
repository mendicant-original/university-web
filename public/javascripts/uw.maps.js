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

  $(points).each(function(p, point){
    new google.maps.Marker({
      position: new google.maps.LatLng(point[0],point[1]),
      map: map
    });
  });
}
