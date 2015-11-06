$(document).on('click', ".segmento", function(){
  $info = $(this).closest(".item-segmento").find('.informations');
  $(".about > div").html($info.html());
  $(".about").show();
  select_points = false;
})

$(document).on('click', '.close-this', function(){
	$(".about").hide();
})