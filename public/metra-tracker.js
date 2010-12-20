var MetraTracker = {};

MetraTracker.locateRider = function(onTime, updatePage) {
  if (geo_position_js.init()) {
  	geo_position_js.getCurrentPosition(successCallback(onTime, updatePage), errorCallback, { enableHighAccuracy:true });
  } else {
    // Do we care?
    // alert('unable to init');
  }

  function successCallback(onTime, updatePage) {
    return function(p) {
      $.ajax({
        url: "/status",
        type: "POST",
        data: $.extend(p.coords, {late: !onTime}),
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
    // Do we care?
    // alert('error='+p.code);
  }
};

