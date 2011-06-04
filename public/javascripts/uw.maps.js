// UW.Maps

UW.setupNamespace("Maps");

UW.Maps.init = function(people){
  var centerLatLng = new google.maps.LatLng(20,0);
  var mapOptions = {
    zoom: 2,
    center: centerLatLng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

  $(people).each(function(i, person){
    new google.maps.Marker({
      position: new google.maps.LatLng(person.location[0], person.location[1]),
      map: map,
      title: person.name
    });
  });
}
