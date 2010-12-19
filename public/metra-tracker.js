var MetraTracker = {};

MetraTracker.locateRider = function(curious) {
  if (geo_position_js.init()) {
  	geo_position_js.getCurrentPosition(successCallback(curious), errorCallback, { enableHighAccuracy:true });
  } else {
    // Do we care?
  }

  function successCallback(updatePage) {
    return function(p) {
      $.ajax({
        url: "/status",
        data: p.coords,
        success: function(data, textStatus, request) {
          updatePage({success: true, data: data});
        }, 
        error: function(request, textStatus, errorThrown) {
          updatePage({failed: true})
        }
      });
    };
  }

  function errorCallback(p) {
    // Do we care? // alert('error='+p.code);
  }
};

