// UW.Maps

UW.setupNamespace("Maps");

UW.Maps.init = function(users){
  var centerLatLng = new google.maps.LatLng(20,0);
  var mapOptions = {
    zoom: 2,
    center: centerLatLng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

  $(users).each(function(i, user){
    new google.maps.Marker({
      position: new google.maps.LatLng(user.location[0], user.location[1]),
      map: map,
      title: user.name
    });
  });
}
