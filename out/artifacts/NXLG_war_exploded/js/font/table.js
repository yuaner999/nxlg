//dom  事件
$(function  () {
	$('.table th button').click(function  () {
		if($(this).hasClass('revers')){
			$(this).removeClass('revers');
		}else{
			$(this).addClass('revers');
		}
	});
	$('.table-nav li').click(function  () {
		$(this).addClass('sele');
		$(this).siblings().removeClass('sele');
	});
});
