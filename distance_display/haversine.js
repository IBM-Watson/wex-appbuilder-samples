Number.prototype.inRadians = function() {
    return this * Math.PI / 180.0;
}

var haversineDistance(lat1, lng1, lat2, lng2) {
    var R = 6371; // Radius of the Planet, set to Earth
    var deltaLat = (lat2-lat1).inRadians();
    var deltaLng = (lng2-lng1).inRadians();
    // this is the ugliest part of the formulat
    var a = (Math.sin(deltaLat/2) * Math.sin(deltaLat/2)) + (Math.cos(lat1.inRadians()) * Math.cos(lat2.inRadians()) *
							     Math.sin(deltaLng/2) * Math.sin(deltaLng/2));
    
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c; 
}
