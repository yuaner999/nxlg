<%--
  Created by IntelliJ IDEA.
  User: liulei
  Date: 2017-03-04
  Time: 16:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <meta charset="utf-8"/>
    <title>宁夏理工选课系统</title>
    <!--兼容双核浏览器-->
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" >
    <!--通用css-->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/common.css"/>
    <!--单引css-->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/login.css"/>
    <!-- Bootstrap部分 -->
    <link href="<%=request.getContextPath()%>/css/bootstrap.min.css" rel="stylesheet">
    <script>
        //返回ie版本字符串
        function IETester(userAgent){
            var UA =  userAgent || navigator.userAgent;
            if(/msie/i.test(UA)){
                return UA.match(/msie (\d+\.\d+)/i)[1];
            }else if(~UA.toLowerCase().indexOf('trident') && ~UA.indexOf('rv')){
                return UA.match(/rv:(\d+\.\d+)/)[1];
            }
            return false;
        }
        if(parseInt(IETester())<10){
            alert("您的浏览器为IE内核，且版本过低，这将影响网页效果，请使用高版本IE或其他内核浏览器");
            //强制关闭页面
            window.opener = null;
            window.open('','_self');
            window.close();
        }
    </script>
    <script>
        var pagecontextpath="<%=request.getContextPath()%>";
        if(window.parent==window){//不存在父页面

        }else {//存在父页面
            parent.gotoLogin();
        }
    </script>
    <script src="<%=request.getContextPath()%>/js/jquery-1.11.0.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/angular1.6.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/remotecall.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/Validform_v5.3.2_min.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/layer/layer.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.md5.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/font/gVerify.js"></script>
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <!--layui部分-->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/layui/css/layui.css"/>
    <script src="<%=request.getContextPath()%>/layui/layui.js" type="text/javascript" charset="utf-8"></script>
    <!--通用js-->
    <script src="<%=request.getContextPath()%>/js/font/common.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
    <div class="bg">
        <div class="head">
            <img src="<%=request.getContextPath()%>/images/loginlogo_03.png"/>
            <div>
                选课系统
            </div>
        </div>
        <!--form-->
        <div class="box text-center">
				<span>
					<p>欢迎登陆</p>
					<h1>宁夏理工学院选课系统</h1>
					<span>推荐使用谷歌浏览器登录系统</span>
				</span>
            <div class="form">
                <form id="LoginForm">
                    <div class="input-group">
                        <img src="<%=request.getContextPath()%>/images/loginusernum_07.png"/>
                        <input class="form-control" type="text" placeholder="请输入用户名" name="userName" id="UserName" value="" />
                    </div>
                    <div class="input-group">
                        <img src="<%=request.getContextPath()%>/images/loginuserpword_07.png"/>
                        <input class="form-control" type="password" placeholder="请输入密码" name="password" id="Password" value="" />
                    </div>
                    <div class="input-group">
                        <img src="<%=request.getContextPath()%>/images/yan.png"/>
                        <input class="form-control" type="text" placeholder="" name="CheckCode" id="CheckCode" value="" />
                        <input style="display: none" type="text" name="CheckCodeimg" id="CheckCodeimg" value=""/>
                        <div id="v_container"></div>
                    </div>
                    <input type="submit" class="btn-block btn input" value="登录">
                    <a class="pull-right" title="找回密码" href="forgetpassword.form">忘记密码</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
<script>
    //验证码gVerify.js
    var verifyCodes = new GVerify("v_container");
    verifyCode=verifyCodes.options.code;
    $("#CheckCodeimg").val(verifyCode);
    //刷新验证码
    $("#v_container").click(function(){
        verifyCode=verifyCodes.options.code;
        $("#CheckCodeimg").val(verifyCode);
    });
    $(function () {
        //表单验证
        $("#LoginForm").validate({

            submitHandler:function(form){
                //验证通过
                var userName = $.trim($("#UserName").val());
                var password = $.md5($("#Password").val());
                remotecallasync("login",{userName:userName,password:password},function (data) {
                    if(data){
                        layer.msg("登录成功");
                        setTimeout(function () {
                            window.location = "index.form";
                        },1500);
                    }else {
                        layer.msg("用户名或密码错误");
                        $("#Password").val("")
                    }
                },function (data) {
                    layer.msg("登录失败");
                    console.log(data);
                });
            },
            rules:{
                userName:{
                    required:true
                },
                password:{
                    required:true
                },
                CheckCode:{
                    equalTo: "#CheckCodeimg",
                }
            },
            messages:{
                userName:{
                    required:"请输入用户名"
                },
                password:{
                    required:"请输入密码"
                },
                CheckCode:{
                    equalTo: "验证码不正确",
                }
            },
            onkeyup:false,
            onclick:false,
            onfocusout:false,//失去焦点时不执行验证
            errorPlacement:function(error,element){//错误提示，错误对象
                layer.tips(error[0].innerText,element,{//1.错误信息，2提示位置，3同时提示多个错误
                    tipsMore:true//错误信息可以同时提示多个，...
                });
            }
        });
    });
</script>