var MetraTracker = {};

MetraTracker.locateRider = function() {
  if (geo_position_js.init()) {
  	geo_position_js.getCurrentPosition(successCallback, errorCallback, { enableHighAccuracy:true });
  } else {
    // Do we care?
  }

  function successCallback(p) {
    // alert('lat='+p.coords.latitude.toFixed(2)+';lon='+p.coords.longitude.toFixed(2));
  }

  function errorCallback(p) {
    // Do we care? // alert('error='+p.code);
  }
};

