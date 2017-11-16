<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/7
  Time: 13:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!--兼容双核浏览器-->
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" >
    <title>宁夏理工选课系统</title>
    <!--通用css-->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/common.css"/>
    <!--单引css-->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/index.css"/>
    <!-- Bootstrap部分 -->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/bootstrap.min.css">
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script>
        var pagecontextpath="<%=request.getContextPath()%>";
    </script>
    <script src="<%=request.getContextPath()%>/js/jquery-1.11.0.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/angular1.6.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/remotecall.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/Validform_v5.3.2_min.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/layer/layer.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.md5.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/font/gVerify.js"></script>
    <!--layui部分-->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/layui/css/layui.css"/>
    <script src="<%=request.getContextPath()%>/layui/layui.js" type="text/javascript" charset="utf-8"></script>
    <!--通用js-->
    <script src="<%=request.getContextPath()%>/js/font/common.js" type="text/javascript" charset="utf-8"></script>
    <style>
        body{
            font-size: 14px;
        }
        .section{
            background: #fff;
            margin:4% 37% 1%;
            width: 500px;
        }
        .title{
            font-size: 16px;
            padding-bottom: 10px;
            border-bottom: 1px solid #c5add7;
            margin-bottom: 35px;
        }

        .form{
            margin-left: 40px;
            font-size: 14px;
            font-weight: 500;
        }
        .user{
            margin-bottom: 17px;
            position: relative;
        }
        .userName{
            margin-bottom: 6px;
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
        .form li button{
            margin-left: 10px;
            width: 100px;
            height: 25px;
            background: #c5add7;
            color: #fff;
            top:0;
        }
        .noBtn{
            width: 200px;
            height: 25px;
            background: #c5add7;
            color: #fff;
            margin: 20px 70px 0;
        }
        .noBtn1{
            width: 100px;
            height: 25px;
            background: #c5add7;
            color: #fff;
            margin: 20px 40px 0;
        }
        #v_container{
            position: relative;
            left:10px;
            top:10px;
            width: 100px;
            height: 30px;
            display: inline;
        }
    </style>
</head>
<body ng-app="app" ng-controller="ctrl">
<!--头-->
<div class="head" ng-click="jumpToLogin()">
    <img src="<%=request.getContextPath()%>/images/loginlogo_03.png"/>
    <div>选课系统</div>
</div>
<!--身体的总容器-->
<div class="section">
    <div class="title">
        <span><b>忘记密码</b></span>
    </div>
        <ul class="form" id="first"><%--ng-if="order==1" --%>
            <li class="userName">
                <span>用户名</span>
                <input type="text" ng-model="user.userName">
            </li>
            <li class="user"id="checkcode">
                <span>图片验证码</span>
                <input id="code_input" type="text" value="">
                <div id="v_container"></div>
            </li>
            <li class="user">
                <span>邮箱</span>
                <input type="text" ng-model="user.userEmail">
                <button ng-click="send()" ng-bind="btntxt"></button>
            </li>
            <div>
                <button class="noBtn" ng-click="gonext()">下一步</button>
            </div>
        </ul>
        <ul class="form" id="then" style="display:none">
            <li class="user">
                <span>邮箱验证码</span>
                <input type="text" ng-model="user.usercode">
            </li>
            <li class="user">
                <span>新密码</span>
                <input type="password" ng-model="user.newpwd">
            </li>
            <li class="user">
                <span>确认新密码</span>
                <input type="password" ng-model="user.renewpwd">
            </li>
            <div>
                <button class="noBtn1" ng-click="gologin()">确认</button> <button class="noBtn1" ng-click="previous()">返回</button>
            </div>
        </ul>
</div>
</body>
</body>
</html>
<script>
    //验证码gVerify.js
    var verifyCode = new GVerify("v_container");

    var app = angular.module('app', []);
    app.controller('ctrl', function($scope) {
        $("#first").show();
        $("#then").hide();
        $scope.user={userName:"",userEmail:"",usercode:"",newpwd:"",newpwd_s:"",renewpwd:""};
        //下一步
        $scope.gonext=function () {
            if($scope.user.userName==''){
                showmsgpc("用户名不能为空");
                return;
            }
            if($scope.user.userEmail==''){
                showmsgpc("邮箱不能为空");
                return;
            }
            if(!_Email($scope.user.userEmail)){
                showmsgpc("邮箱不能为空");
            }
            $("#first").hide();
            $("#then").show();
        };
        //确认
        $scope.gologin=function () {
            if($scope.user.newpwd==''||$scope.user.renewpwd==''){
                showmsgpc("输入的密码不能为空");
            }else if($scope.user.newpwd!=$scope.user.renewpwd){
                showmsgpc("两次输入的密码不一致，请重新输入");
            }else{
                $scope.user.newpwd_s=$.md5($scope.user.newpwd);
                remotecallasync("forgetpwd",$scope.user, function (data) {
                    if(data.result){
                        showmsgpc("修改成功，3秒后为您跳转到登录页，重新登录");
                        setTimeout(function () {
                            window.location = "login.form"
                        },3000);
                    }else{
                        showmsgpc(data.errormessage);
                    }
                },function (data) {showmsgpc("请求数据库失败");})
            }
        };
        //返回
        $scope.previous=function(){
            $("#first").show();
            $("#then").hide();
        }
        $scope.btntxt='发送验证码';
        var m=60;
        //发送邮箱验证码
        $scope.send=function () {
            var res = verifyCode.validate(document.getElementById("code_input").value);
            if($scope.user.userName==''){
                showmsgpc("用户名为空，不能发送验证码");
                return;
            }
            if($scope.user.userEmail==''){
                showmsgpc("邮箱为空，不能发送验证码");
                return;
            }
            if(!_Email($scope.user.userEmail)){
                showmsgpc("邮箱格式不正确");
            }
            if(!res){
//                layer.tips('图片验证码错误', '#code_input', {
//                    tips: 3
//                });
                showmsgpc("图片验证码错误");
                return;
            }
            remotecallasync("beforesendcode",$scope.user, function (data) {
                if(data.result) {
                    $scope.time(m);
                    remotecallasync("sendcheckcode", $scope.user, function (data) {
                        if (data.result) {
                            showmsgpc("验证码已发送到您的邮箱，请注意查收");
                        } else {
                            showmsgpc(data.errormessage);
                        }
                    },function (data) {
                        showmsgpc("数据库请求失败");
                    })
                }else{
                    showmsgpc(data.errormessage);
                }
            },function (data) {
                showmsgpc("数据库请求失败");
            })
        };
        //计时，邮箱验证码时间间隔1小时
        $scope.time=function (m) {
            var timer=setInterval(function () {
                m--;
                if(m<0){
                    clearInterval(timer);
                    m=60;
                    layer.alert('验证码已过时，请重新发送', {
                        skin: 'demo-class'
                        ,closeBtn: 0
                    });
                    $scope.$apply();
                };
            },60000);
        };
        //跳转到登录页
        $scope.jumpToLogin=function () {
            window.location = "login.form";
        }
    });
    //验证是否为邮箱
    function _Email(num){
        if (!( /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/.test(num))){
            return false;
        }
        return true;
    }
</script>