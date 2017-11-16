var app=angular.module('app',[]).controller('ctrl',function  ($scope) {
	remotecallasync("userCenter",'',function (data){
		if(data.result){
			$scope.user=data.result;
			$scope.user.UCphone=plusxing(data.UCphone,3,4);
			$scope.user.UCemail=plusxing(data.UCemail,3,4);
			//加载图片
			$('#HeadIcon').attr("src",serverimg(data.UCimage));
			$scope.$apply();
		}else{
			parent.pMsg(data.errormessage);
		}
	},function (data) {
		parent.pMsg("无该用户信息");
	});
	//上传图片
	$scope.uploadIcon = function (selector) {
		imguploadandpreview(selector, '1', function (data) {
			var img_id=data.fid;
			preUserCenterEditImage(img_id);
		})
	}
	//修改手机号
	$scope.editPhone=function(){
		location.href='editPhone.form';
	}
	//修改邮箱
	$scope.editEmail=function(){
		location.href='editEmail.form';
	}
});


//中间省略不显示
function plusxing(str,frontlen,endlen){
	if(str==null||str=="") return str;
	var xing=str.substring(frontlen,str.length-endlen);
	var r=str.replace(xing,"*******");
	return r;
}
//更新用户头像
function preUserCenterEditImage(img_id) {
	remotecallasync("userCenter_editImage",{'img_id':img_id},function (data){
		if(data.result){
			parent.pMsg('更新图片成功');
		}else{
			parent.pMsg(data.message);
		}
	},function (data) {
		parent.pMsg("无该用户信息");
	});
}