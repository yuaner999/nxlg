<%--
  Created by IntelliJ IDEA.
  User: gq
  Date: 2017/6/5
  Time: 11:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
</head>
<style>
    .unCourseArrange{background: #c2c2c2}
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：排课
<hr>
<div class="title">
    <%--<span>当前排课状态:</span>
    <table-btn id="arrangeStatus" class="top_1" ></table-btn>
    <span ng-bind="arrangeStatus" style="margin-left:100px;"></span>--%>
    <table-btn class="top_1  tablebtn canCourseArrange"  ng-click="arrangeCourse()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>排课</table-btn>
    <table-btn class="top_1  tablebtn unCourseArrange"  ng-click="arranging()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>正在排课</table-btn>
</div>
</body>
<script>
var app=angular.module("app",[]);
app.controller("ctrl",function ($scope,$interval) {
    $scope.arrangeStatus={};
    $scope.loadStatus=function () {
        loading();
        remotecallasync("basic_loadArrangeStatus",{},function (data) {
            closeLoading();
            if (data[0].wordbookValue==0){
                $(".canCourseArrange").show();
                $(".unCourseArrange").hide();
            }else {
                $(".canCourseArrange").hide();
                $(".unCourseArrange").show();
            }
        },function (data) {
            closeLoading();
            parent.pMsg("数据库请求失败");
        });
    };

    $scope.arrangeCourse=function () {
        parent.pConfirm("确定清空排课信息，重新排课吗？",function () {
            loading();
            $scope.loadStatus();
            $.ajax({
                url:"/arrangecourse.form",
                type:"post",
                dataType:"json",
                success:function (data) {
                    if(data.result){
                        closeLoading();
                        parent.pMsg("开始排课");
                        $scope.loadStatus();
                    }else{
                        $scope.loadStatus();
                        closeLoading();
                        parent.pMsg("当前正在排课");
                    }
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("批量删除请求失败");
                console.log(data);
            });
        },function () {
            $scope.loadStatus();
            closeLoading();//关闭加载层
        });
    }

    $scope.arranging=function () {
        parent.pMsg("当前正在排课");
    }

    //数据初始化
    var timer = $interval(function(){
        $scope.loadStatus();
    },5000);
    $scope.loadStatus();
});
</script>
</html>

