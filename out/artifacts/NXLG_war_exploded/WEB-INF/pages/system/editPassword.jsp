<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-17
  Time: 14:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.md5.js"></script>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：修改密码
<hr>
    <!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
    <div class="table-addform container-fluid a-show">
        <form id="Form">
            <div class="row">
                <ul class="col-sm-3 col-xs-3">
                    <li><span>输入原密码：</span><input type="password" name="oldPassword" class="forminput"/></li>
                    <li><span>输入新密码：</span><input type="password" name="newPassword" id="newPassword" class="forminput"/></li>
                    <li><span>确认新密码：</span><input type="password" name="queryPassword" class="forminput"/></li>
                </ul>
            </div>
            <div class="text-center" style="margin-top: 30px;">
                <table-btn class="confirm" id="confirm">确定</table-btn>
                <span class="tablebtn confirm" ng-click="clear()">清除</span>
            </div>
        </form>
    </div>
</body>
</html>
<script>
    //显示弹出框
    $('.table-addform').addClass('a-show');
    $('.table-addform').removeClass('a-hide');
    $('.table-addform').show();
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //表单验证
        $("#Form").validate({
            submitHandler:function(form){
                //验证通过,然后就保存
                loading();
                var parames = $("#Form").serializeObject();//参数
                parames.oldPassword = $.md5(parames.oldPassword);
                parames.newPassword = $.md5(parames.newPassword);
                remotecall("editPassword",parames,function (data) {
                    closeLoading();
                    if(data==0){
                        parent.pMsg("原密码不正确");
                    }else if(data==1){
                        layer.confirm("修改成功,请重新登录", {
                            btn: ['确认'],
                            closeBtn: 0//按钮
                        }, function(){
                        remotecall("index_exit",{},function () {
                            window.location.href="<%=request.getContextPath()%>/views/login.form";
                        },function () {});
                        }, function(){});
                    }else {
                        parent.pMsg("修改失败");
                    }
                },function (data) {
                    parent.pMsg("数据库请求失败");
                    console.log(data);
                });
            },
            rules:{
                oldPassword:{
                    required:true
                },
                newPassword:{
                    required:true
                },
                queryPassword:{
                    equalTo:"#newPassword"
                }
            },
            messages:{
                oldPassword:{
                    required:"请输入原密码"
                },
                newPassword:{
                    required:"请输入新密码"
                },
                queryPassword:{
                    equalTo:"两次密码不一致"
                }
            },
            //重写showErrors
            showErrors: function (errorMap, errorList) {
                var msg = "";
                $.each(errorList, function (i, v) {
                    //msg += (v.message + "\r\n");
                    //在此处用了layer的方法,显示效果更美观
                    layer.tips(v.message, v.element, { time: 2000 });
                    return false;
                });
            },
            /* 失去焦点时不验证 */
            onfocusout: false
        });
        //清除函数
        $scope.clear = function () {
            $("input[type='password']").val("");
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>