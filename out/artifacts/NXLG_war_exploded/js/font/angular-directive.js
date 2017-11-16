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
// app.directive('paging',function  () {
// 	return {
// 		restrict:'E',
// 		template:'<ul class="tablenav">'+
// 					'<div class="paging">'+
// 						'<button ng-click="gotoPage(page-1)">'+
// 						'<img src="../../../images/pagingprev_07.png"/>'+
// 						'<span>上一页</span>'+
// 						'</button>'+
// 						'<button ng-click="gotoPage(1)">'+
// 						'<img src="../../../images/pagingprev_07.png"/>'+
// 						'</button>'+
// 						'<ul class="clearfix" id="PageUL">'+
// 						'<li class=" pageNumber" ng-click="gotoPage(page,$index)" ng-repeat="page in pages" ng-bind="page"></li>'+
// 						'</ul>'+
// 						'<button ng-click="gotoPage(pC)">'+
// 						'<img src="../../../images/pagingnext_07.png"/>'+
// 						'</button>'+
// 						'<button ng-click="gotoPage(page+1)">'+
// 						'<img src="../../../images/pagingnext_07.png"/>'+
// 						"<span>下一页</span>"+
// 					"</button>"+
// 					"</div>"+
// 				'</ul>',
// 		replace:true
// 	}
// });
//新分页指令
app.directive('paging',function  () {
	return {
		restrict:'E',
		template:'<ul class="tablenav">'+
					'<div class="paging">'+

						'<button ng-click="gotoPage(-1)">'+
						'<img src="../../images/pagingprev_07.png"/>'+
						'<span>上一页</span>'+
						'</button>'+
						'<button ng-click="gotoPage(1)">'+
						'<img src="../../images/pagingprev_07.png"/>'+
						'</button>'+
						'<ul class="clearfix" id="PageUL">'+
						'<li class=" pageNumber" ng-click="gotoPage(page,$index)" ng-repeat="page in pages" ng-bind="page"></li>'+
						'</ul>'+
						'<button ng-click="gotoPage(-3)">'+
						'<img src="../../images/pagingnext_07.png"/>'+
						'</button>'+
						'<button ng-click="gotoPage(-2)">'+
						"<span>下一页</span>"+
						'<img src="../../images/pagingnext_07.png"/>'+
					    "</button>"+
                        '<button ng-if="TotalPageCount!=null">'+
                        '<span ng-if="TotalDataCount!=null">共{{TotalDataCount}}条数据</span> <span>共{{TotalPageCount}}页</span>'+
                        '</button>'+
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
});