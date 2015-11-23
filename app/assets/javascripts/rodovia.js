var pointLayer;
var pointLayerShift;

var base_layer;
var centeroid;

var viewOverall;

var map;
var select_points;
var shiftDown = false;
var vectors   = {};

this.onkeydown = function(evt){
    var evt2 = evt || window.event;
    var keyCode = evt2.keyCode || evt2.which;       
    if(keyCode==16)
      shiftDown = true;
}
this.onkeyup = function(){
    shiftDown = false;
}
function removePointLayers(){
  map.removeLayer(pointLayer);
  map.removeLayer(pointLayerShift);
}

function getLayers(){
  return map.getLayers().getArray();
}

function displayFeatureInfo(map, pixel) {
  var feature = map.forEachFeatureAtPixel(pixel, function(feature, layer) {
    return feature;
  });

  // var default_style = new ol.style.Style({
  //   fill: new ol.style.Fill({
  //     color: 'rgba(255, 255, 255, 0.6)'
  //   }),
  //   stroke: new ol.style.Stroke({
  //     color: '#319FD3',
  //     width: 1
  //   }),
  //   text: new ol.style.Text({
  //     font: '12px Calibri,sans-serif',
  //     fill: new ol.style.Fill({
  //       color: '#000'
  //     }),
  //     stroke: new ol.style.Stroke({
  //       color: '#fff',
  //       width: 3
  //     })
  //   })
  // });


  if (feature) {
    var default_style = feature.getStyle();
    for(var key in vectors){
      if(feature.get("id") != key){
        element = vectors[key];
        var source = element.getSource();
        var feats = source.getFeatures();
        feats[0].setStyle(default_style);
      }
    };

    $.get("/rodovias/" + feature.get("id"), function(data){
      $("#information").html(data);
      feature.setStyle(new ol.style.Style({
                          stroke: new ol.style.Stroke({
                            color: "#8B0000",
                            width: 3
                          }),
                          fill: new ol.style.Fill({
                            color: 'rgba(0, 0, 255, 0.8)'
                          })
                      }));
    });


  }

  if(select_points){

    if(!shiftDown){
      map.removeLayer(pointLayer);
      map.removeLayer(pointLayerShift);

      var position     = map.getCoordinateFromPixel(pixel);
      var point        = new ol.geom.Point(position);
      var pointFeature = new ol.Feature({
        geometry: point,
        name: "Location Marker"
      });

      pointLayer = new ol.layer.Vector({
        source: new ol.source.Vector({ features: [pointFeature] })
      });
      
      npoint = point.clone().transform('EPSG:3857', 'EPSG:4326');
      coord  = npoint.getCoordinates();

      $(".coord-x-form").val(coord[0]);
      $(".coord-y-form").val(coord[1]);

      $(".coord-xb-form").val(coord[0]);
      $(".coord-yb-form").val(coord[1]);

      map.addLayer(pointLayer);
    }else{

      map.removeLayer(pointLayerShift);

      var positionShift     = map.getCoordinateFromPixel(pixel);
      var pointShift        = new ol.geom.Point(positionShift);
      var pointFeatureShift = new ol.Feature({
        geometry: pointShift,
        name: "Location Marker"
      });

      pointLayerShift = new ol.layer.Vector({
        source: new ol.source.Vector({ features: [pointFeatureShift] })
      });
      
      npointShift = pointShift.clone().transform('EPSG:3857', 'EPSG:4326');
      coord       = npointShift.getCoordinates();

      $(".coord-xb-form").val(coord[0]);
      $(".coord-yb-form").val(coord[1]);

      map.addLayer(pointLayerShift);
    }
  }
}

function createVector(color, object, id){
  // color
  if(vectors[id] === undefined) {
    var item = new ol.layer.Vector({
       style: new ol.style.Style({
          stroke: new ol.style.Stroke({
            color: "#000080",
            width: 3
          }),
          fill: new ol.style.Fill({
            color: 'rgba(0, 0, 255, 0.8)'
          })
        }),
      source: new ol.source.GeoJSON({
        projection: 'EPSG:3857',
        object: object
      }),
    });
    vectors[id] = item; 
  }
  return item;
}

function createPoint(color, object){
  var item = new ol.layer.Vector({
    source: new ol.source.GeoJSON({
      projection: 'EPSG:3857',
      object: object
    }),
  });
  vectors["pnt"] = item; 
  return item;
}

$(function(){
  select_points = false;
  $(document).on('submit', "#new_via_caracteristic", function(){
    $(".hide-success").show();
  })

  base_layer = new ol.layer.Tile({ source: new ol.source.MapQuest({layer: 'osm'})});
  centeroid = ol.proj.transform([-47.1384275, -12.1923535], 'EPSG:4326', 'EPSG:3857')


  viewOverall = new ol.View({
      center: centeroid,
      zoom: 5
  });


  map = new ol.Map({
    layers: [base_layer],
    target: 'map',
    view: viewOverall
  });

  map.getViewport().addEventListener("click", function(e) {
    displayFeatureInfo(map, map.getEventPixel(e));
  });

  map.addInteraction(new ol.interaction.Select({
    condition: ol.events.condition.mouseMove
  }));

  

  // map.on("moveend", function(da){
  //   $(".fade-loading").show();
  //   extent = map.getView().calculateExtent(map.getSize());
  //   region = ol.proj.transformExtent(extent, 'EPSG:3857', 'EPSG:4326');
  //   var url = "/?left_top="+region[0]+"&right_top="+region[1]+"&bottom_right="+region[2]+"&bottom_left="+region[3]+"&exclude="+Object.keys(vectors);
  //   $(".me").attr('href', url);
  //   $(".me").click();
  // })

  $(document).on('click', ".add-point", function(){
    var id = $(this).data('id');
    for(var key in vectors){
      if(key != id){
        element = vectors[key];
        element.setVisible(false);
      }
    };
  });

  $(document).on('click', '.close-this, .btn-create-ref', function(){
    for(var key in vectors){
      element = vectors[key];
      element.setVisible(true);
    };
  })

});