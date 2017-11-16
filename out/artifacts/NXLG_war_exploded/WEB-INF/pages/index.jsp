<%--
  Created by IntelliJ IDEA.
  User: liulei
  Date: 2017-03-04
  Time: 17:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession s = request.getSession();
    if (s.getAttribute("sessionUserID") == null||s.getAttribute("sessionUserID")=="") {
                response.sendRedirect(request.getContextPath()+"/views/login.form");
                response.getWriter().close();
    }
%>
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
    <script>
        //返回ie版本字符串
        function IETester(userAgent){
            var UA =  userAgent || navigator.userAgent;
      Rectangle  if(/msie/i.test(UA)){
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
    <![endif]-->
    <script>
        var pagecontextpath="<%=request.getContextPath()%>";
    </script>
    <script src="<%=request.getContextPath()%>/js/jquery-1.11.0.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/angular1.6.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/remotecall.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/Validform_v5.3.2_min.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/layer/layer.js" type="text/javascript" charset="utf-8"></script>
    <!--layui部分-->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/layui/css/layui.css"/>
    <script src="<%=request.getContextPath()%>/layui/layui.js" type="text/javascript" charset="utf-8"></script>
    <!--通用js-->
    <script src="<%=request.getContextPath()%>/js/font/common.js" type="text/javascript" charset="utf-8"></script>
</head>
<body ng-app="app" ng-controller="ctrl">
    <!--头-->
    <div class="head">
        <img src="<%=request.getContextPath()%>/images/loginlogo_03.png"/>
        <div>选课系统</div>
        <ul class="pull-right">
            <div class="curcle">
                <div class="img">
                    <img src="<%=request.getContextPath()%>/images/loginuser_01.png"/>
                </div>
                <span ng-bind="user.name"></span>
            </div>
            <!--站内信按钮-->
            <button id="btn_info" ng-class="user.info.length>0? 'a-blink' : ''"
                    <%--ng-show="user.info.length!=0"--%>
                    ng-mouseover="hoverbtn(0)"
                    ng-mouseout="hoverbtn(1)"
                    title="消息">
                <img style="margin-top: 3px;margin-left: 8px;" src="<%=request.getContextPath()%>/images/indexinfo_06.png"/>
                <!------------通知消息弹窗-------------->
                <ul id="information" ng-show="user.info.length>=0">
                    <p>
                        通知 &nbsp <span  ng-bind="user.info.length"></span>
                        条未读消息
                        <span class="inforight" ng-click="allinfo()"></span>
                    </p>
                    <li ng-style="$index>1? {display:'none'}:{}" class="{{item.hover? 'bg-zi':''}}" ng-repeat="item in user.info" ng-mouseout="infohover(item,false)"  ng-mouseover="infohover(item,true)">
                        <h3 ng-bind="item.messageTitle"></h3>
                        <p ng-bind="item.messageContent"></p>
                        <div>
                            <span class="{{}}" ng-hide="item.hover">
                                <span>
                                    <span ng-bind="item.month"></span>月
                                    <span ng-bind="item.day"></span>日
                                </span>
                                <span>
                                    <span ng-bind="item.hour"></span>:
                                    <span ng-bind="item.minute"></span>
                                </span>
                            </span>
                                <span ng-show="item.hover" class="inforight"  ng-click="ainfo(item)"></span>
                        </div>
                    </li>
                    <span ng-click="changeframesrc('basic/messageManage.form')">查看全部</span>
                </ul>
            </button>
            <%--<button title="个人设置">--%>
                <%--<img src="<%=request.getContextPath()%>/images/indexsetting_06.png"/>--%>
            <%--</button>--%>
            <button title="退出登录" onclick="exit()">
                <img style="margin-left: 10px;" src="<%=request.getContextPath()%>/images/indexout_06.png"/>
            </button>
        </ul>
    </div>

    <!--身体的总容器-->
    <div class="container-fluid main clearfix">
        <!--左导航-->
        <div class="leftnav">
            <ul>
                <li ng-repeat="option in moptions" >
                    <div ng-click="changeframesrc(option.menuUrl)">
                        <img ng-src="<%=request.getContextPath()%>{{option.iconurl}}"/>
                        <span ng-bind="option.menuName"></span>
                    </div>
                    <ol>
                        <li ng-repeat="menu in option.menus" ng-click="changeframesrc(menu.menuUrl1)"><span ng-bind="menu.menuName1"></span><b ng-bind="menu.menuUrl1"></b><i></i></li>
                    </ol>
                </li>
                <i class="after"></i>
            </ul>
        </div>
        <!--右方iframe框架-->
        <iframe id="iframe" ng-src="{{iframe.src}}" width="100%" height="100%" frameborder="no"></iframe>
        <!--欢迎界面-->
        <div class="welcome"></div>
    </div>
    </body>
    <!--angular和本页特效都在下面
    -->
    <script src="<%=request.getContextPath()%>/js/font/index.js" type="text/javascript" charset="utf-8"></script>
</body>
</html>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
<script>
    //Layer.msg
    function pMsg(content) {
        layer.msg(content);
    }
    //Layer.confirm
    function pConfirm(content,callback,errorcallback) {
        layer.confirm(content, {
            btn: ['确认','取消'] //按钮
        }, function(index){
            layer.close(index);
            if(callback) callback();
        }, function(){
            if(errorcallback) errorcallback();
        });
    }
    //退出登录
    function exit() {
        layer.confirm("确认退出本次登录吗？", {
            btn: ['确认','取消'] //按钮
        }, function(){
            remotecallasync("index_exit",{},function () {
                window.location = "login.form";
            },function () {});
        }, function(){});
    }
    function gotoLogin() {
        location.reload(true);
    }
</script>