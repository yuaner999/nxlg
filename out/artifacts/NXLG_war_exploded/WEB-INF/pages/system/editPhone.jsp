<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/13
  Time: 15:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <style>
        body{
            font-size: 14px;
        }
        .section{
            background: #fff;
            margin:4% 37% 1%;
        }
        .form{
            margin-left: 40px;
            margin-top:100px;
            font-size: 14px;
            font-weight: 500;
        }
        .user{
            margin-bottom: 17px;
            position: relative;
        }
        .form li span{
            display: inline-block;
            width:  100px;
        }
        .form li input{
            height:25px;
            padding:0 5px;
            width: 165px;
            border:1px solid #c5add7;
            display: inline-block;
        }
        #v_container{
            position: relative;
            left:275px;
            top:-28px;
            width: 100px;
            height: 30px;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<div class="section">
    <div>
        <ul class="form" id="first">
            <li class="user">
                <span>原手机号</span>
                <input type="text" ng-model="user.UCphone">
            </li>
            <li class="user"id="checkcode">
                <span>图片验证码</span>
                <input id="code_input" type="text" value="">
                <div id="v_container"></div>
            </li>
            <div>
                <button style="width:200px;margin-left:-20px;height:25px;background: #c5add7;color: #fff;border:1px solid #c5add7" ng-click="sendPhone()">给手机发送验证码</button>
                <button style="width:100px;margin-left:50px;height:25px;background: #c5add7;color: #fff;border:1px solid #c5add7" ng-click="previous()">返回</button>
            </div>
        </ul>
        <ul class="form" id="then">
            <li class="user">
                <span>手机验证码</span>
                <input type="text" ng-model="user.code">
            </li>

            <li class="user">
                <span>新手机号</span>
                <input type="text" ng-model="user.newphone">
            </li>
            <div>
                <button style="width:210px;margin-left:35px;margin-top:30px;height:25px;background: #c5add7;color: #fff;border:1px solid #c5add7" ng-click="Edit()">确认</button>
            </div>
        </ul>
    </div>
</div>
</body>
</html>
<script>
    //验证码gVerify.js
    var verifyCode = new GVerify("v_container");

    var app = angular.module('app', []);
    app.controller('ctrl', function($scope) {
        $("#first").show();
        $("#then").hide();
        //该用户信息
        loading();
        remotecallasync("userCenter",'',function (data){
            closeLoading();
            $scope.user=data.result;
            $scope.user.userphone=data.UCphone;
        },function (data) {
            closeLoading();
            parent.pMsg("无法获取当前用户姓名");
        });
        $scope.previous=function(){
            location.href='userCenter.form';
        }
        //给手机号发验证码
        $scope.sendPhone=function(){
            //手机号不为空
             if($scope.user.UCphone==''){
             	showmsgpc("手机号为空，不能发送验证码");
             	return;
             }
             //图片验证码
            var res = verifyCode.validate(document.getElementById("code_input").value);
            if(!res){
                showmsgpc("图片验证码错误");
                return;
            }
            if($scope.user.UCphone==$scope.user.userphone){
                //给手机发验证码，1、操作两个表 2、与用户类型无关。
                loading();
                remotecallasync("sendcheckcode_phone",$scope.user, function (data) {
                    closeLoading();
                    if(data.result) {
                        showmsgpc("手机验证码已发送，请查看您的手机");
                        setTimeout(function () {
                            $("#first").hide();
                            $("#then").show();
                            remotecallasync("userCenter",'',function (data){
                                $scope.user=data.result;
                                $scope.user.codePhone=data.result.codePhone;
                            },function (data) {
                                parent.pMsg("无法获取当前手机验证码");
                            });
                        },2000);
                    }else{
                        showmsgpc(data.errormessage);
                    }
                })
            }else{
                showmsgpc("手机号错误");
            }
        };
        //确认
        $scope.Edit=function () {
            if($scope.user.newphone==""){
                showmsgpc("新手机号不能为空");
                return;
            }
            if(!_phone($scope.user.newphone)){
                showmsgpc("请输入正确的新手机号");
                return;
            }
            if($scope.user.code==""){
                showmsgpc("验证码不能为空");
                return;
            }
            var code="您的验证码是"+$scope.user.code;
            if(code.toString()!=$scope.user.codePhone.toString()){
                showmsgpc("验证码不正确");
                return;
            }
            loading();
            remotecallasync("userCenter_editPhone",{typeName:$scope.user.typeName,studentId:$scope.user.studentId,teacherId:$scope.user.teacherId,adminId:$scope.user.adminId,newphone:$scope.user.newphone}, function (data) {
                closeLoading();
                if(data.result){
                    showmsgpc("修改成功");
                    setTimeout(function () {
                        location.href='userCenter.form';
                    },1000);
                }else{
                    showmsgpc(data.errormessage);
                }
            });
        };
    });
    //验证手机号码
    function _phone(phoneum){
        if (!(/^1(3|4|5|7|8)\d{9}$/.test(phoneum))){
            return false;
        }
        return true;
    }

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
