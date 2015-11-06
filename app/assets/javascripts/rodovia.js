var pointLayer;

var base_layer;
var centeroid;

var viewOverall;

var map;
var select_points;

function displayFeatureInfo(map, pixel) {
  var feature = map.forEachFeatureAtPixel(pixel, function(feature, layer) {
    return feature;
  });

  if (feature) {
    $.get("/rodovias/" + feature.get("id"), function(data){
      $("#information").html(data);
    });
  }

  if(select_points){

    map.removeLayer(pointLayer);

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
  }
}

function createVector(color, object){
  var item = new ol.layer.Vector({
     style: new ol.style.Style({
        stroke: new ol.style.Stroke({
          color: color,
          width: 5
        }),
        fill: new ol.style.Fill({
          color: 'rgba(0, 0, 255, 0.1)'
        })
      }),
    source: new ol.source.GeoJSON({
      projection: 'EPSG:3857',
      object: object
    }),
  });
  return item;
}

function createPoint(color, object){
  var item = new ol.layer.Vector({
    source: new ol.source.GeoJSON({
      projection: 'EPSG:3857',
      object: object
    }),
  });
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

  map.on("moveend", function(da){
    // load rodovias by zoom
    region = map.getView().calculateExtent(map.getSize());
  })


})
