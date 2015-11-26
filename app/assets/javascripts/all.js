$(document).on('click', ".segmento", function(){
  $info = $(this).closest(".item-segmento").find('.informations');
  $(".about > div").html($info.html());
  $(".about").show();
  select_points = false;
})

$(document).on('click', '.close-this', function(){
	$(".about").hide();
})

$(function(){
	$(document).on('change', '.categories, .importance-field', function(){
		$(this).closest('form').submit();
	})

	$(document).on('click', '.more-impor', function(){
		var importance_val = parseInt($(".importance-field").val());
		var importance 		 = importance_val+1;
		if(importance_val < 5){
			console.log(importance);
			$(".importance-field").val(importance);
			$(".form-filter").submit();
		}
	})
	$(document).on('click', '.less-impor', function(){
		var importance_val = parseInt($(".importance-field").val());
		var importance = importance_val-1;
		if(importance_val > 0){
			console.log(importance);
			$(".importance-field").val(importance);
			$(".form-filter").submit();
		}
	})
})