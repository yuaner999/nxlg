var app=angular.module('app',[]).controller('ctrl',function  ($scope) {
	//用户名等等用户信息
	$scope.user={
		photo:"../../../images/indexphoto_07.png",
		name:"",
		info:[]
	};
	$scope.user.info=[];
	//加载菜单
	$scope.loadMenu = function () {
		//右上角显示	 当前用户的名字
		remotecallasync("index_user",'',function (data){
			if(data.result){
				$scope.user.name=data.result;
				$scope.$apply();
				init();
			}else{
				parent.pMsg("无法获取该用户的详细信息");
			}
		},function (data) {
			parent.pMsg("无法获取当前用户姓名");
		});
		//此处必须，1、异步  2、$apply 3、init()，缺一不可，否则出错。
		remotecallasync("index_loadMenu",'',function (data){
			$scope.moptions = data;
			$scope.$apply();
			init();
		},function (data) {
			parent.pMsg("菜单栏加载父菜单失败");
			console.log(data);
		});
	}
	$scope.loadMenu();
	//消息弹窗
	$scope.infohover=function (item,buer) {
		if(buer){
			item.hover=true;
		}else{
			item.hover=false;
		}
	};
	//quan读了
	$scope.allinfo=function () {
		remotecall("messageManage_readall","",function (data) {
			if(data){
				setTimeout(function () {
					$scope.user.info=[];
					$scope.$apply();
				},1000);
				parent.pMsg("设置消息全部已读成功");
				init();
			}else {
				parent.pMsg("设置消息全部已读失败");
			}
		},function(data){
			parent.pMsg("设置消息全部已读失败");
			console.log(data);
		});
	};
	//已读//单个标注为已读
	$scope.ainfo=function (i) {
		var messageIds =new Array(i.messageId);
		remotecall("messageManage_read",{messageIds:messageIds},function (data) {
			if(data){
				parent.pMsg("消息已读");
				remotecall("index_loadMessage",{},function (data) {
					if(data.length>=0){
						$scope.user.info = data;
					}
				},function (data) {
					console.log(data);
				});
				$scope.$apply();
			}else {
				parent.pMsg("设置消息已读失败");
			}
		},function (data) {
			parent.pMsg("设置消息已读失败");
			console.log(data);
		});

	};
	//站内信按钮的事件
	// $scope.flagbtn=true;
	$scope.hoverbtn=function  (num) {
		// alert(num);
		if(num==0){
			// $scope.flagbtn=false;
			$('#information').stop(true).fadeIn(400);
		}else if(num==1){
			// scope.flagbtn=true;
			$('#information').stop(true).fadeOut(400);
		};
	};
	//iframe框架的 地址"system/"+
	$scope.iframe={
		src:null
	};
	$scope.changeframesrc=function  (src) {
		if(src){
			$('.welcome').remove();
			$scope.iframe.src=src;
		}
	}
	//定时查询消息
	setInterval(function () {
		remotecall("index_loadMessage",{},function (data) {
			if(data.length>=0){
				$scope.user.info = data;
			}else {
				parent.pMsg("添加失败");
			}
		},function (data) {
			console.log(data);
		});
	},180000);
	//首次加载消息
	remotecall("index_loadMessage",{},function (data) {
		if(data.length>=0){
			$scope.user.info = data;
		}else {
			parent.pMsg("添加失败");
		}
	},function (data) {
		console.log(data);
	});
});
$(function  () {
	init();
});

function init() {
	//导航hover
	$('.leftnav>ul>li ol li').hover(function  () {
		$(this).find('b').addClass('hover');
	},function  () {
		$(this).find('b').removeClass('hover');
	});
	$('.leftnav>ul>li ol li').click(function  () {
		$('.hoverbest').removeClass('hoverbest');
		$(this).find('b').addClass('hoverbest');
	});
    $('.leftnav>ul>li div>span').off('click')
	$('.leftnav>ul>li div>span').on("click",function  () {
		var parents=$(this).parent().parent();
		if(parents.find('ol').css('display')=='none'){
			parents.find('ol').slideDown(200);
			parents.siblings().find('ol').slideUp();
		}else{
			parents.find('ol').slideUp(200);
		};

		var idx=parents.index();
		var afterh=69;
		$('.leftnav>ul .after').animate({top:afterh*idx+'px'},200);
	});
}
