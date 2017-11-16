//table按钮+
app.directive('tableBtn',function  () {
	return {
		restrict:'E',
		template:'<button class="tablebtn" ng-transclude></button>',
		replace:true,
		transclude:true
	}
});
//分页指令
app.directive('paging',function  () {
	return {
		restrict:'E',
		template:'<ul class="tablenav">'+
					'<div class="paging">'+
						'<button>'+
							'<img src="images/pagingprev_07.png"/>'+
							'<span>上一页</span>'+
						'</button>'+
						'<button>'+
							'<img src="images/pagingprev_07.png"/>'+
						'</button>'+
						'<ul class="clearfix">'+
							'<li class="sele">1</li>'+
							'<li>2</li>'+
							'<li>3</li>'+
							'<li>4</li>'+
						'</ul>'+
						'<button>'+
							'<img src="images/pagingnext_07.png"/>'+
						'</button>'+
						'<button>'+
							'<img src="images/pagingnext_07.png"/>'+
							"<span>下一页</span>"+
						"</button>"+
					"</div>"+
				'</ul>',
		replace:true
	}
});
//紫色导航指令
app.directive('tableNav',function  () {
	return {
		restrict:'EA',
		template:'<ul class="table-nav" ng-transclude></ul>',
		replace:true,
		transclude:true
	}
})