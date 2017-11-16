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
    <%--<table-btn id="arrangeStatus" class="top_1" ></table-btn>--%>

    <table-btn class="top_1  tablebtn canCourseArrange"  ng-click="arrangeCourse()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>排课</table-btn>
    <table-btn class="top_1  tablebtn unCourseArrange"  ng-click="arranging()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>正在排课</table-btn>
        <span ng-bind="arrangeStatus" style="margin-left:100px;"></span>
</div>
</body>
<script>
var app=angular.module("app",[]);
var timer;
app.controller("ctrl",function ($scope,$timeout) {
    $scope.arrangeStatus="";
    $scope.loadStatus=function () {
//        loading();
        remotecallasync("basic_loadArrangeStatus",{},function (data) {
//            closeLoading();
            if (data[0].wordbookValue==0||data[0].wordbookValue==3||data[0].wordbookValue==4){
                $(".canCourseArrange").show();
                $(".unCourseArrange").hide();
            }else {
                $(".canCourseArrange").hide();
                $(".unCourseArrange").show();
                timer = $timeout(function(){
                    $scope.loadStatus();
                },10000);
            }
            if (data[0].wordbookValue==1){
                $scope.arrangeStatus="当前排课状态:准备开始";
            }else if (data[0].wordbookValue==2){
                $scope.arrangeStatus="当前排课状态:开始排课";
            }else if (data[0].wordbookValue==3){
                $scope.arrangeStatus="当前排课状态:排课结束";
            }else if (data[0].wordbookValue==4){
                $scope.arrangeStatus="当前排课状态:排课错误";
                remotecall("basic_loadArrangeWrongMsg",{},function (datamsg) {
                    if(datamsg!=null&&datamsg.length>0) {
                        var msg="";
                        if(datamsg[0].wordbookValue==-101){
                            msg="教室资源不足";
                        }
                        else if(datamsg[0].wordbookValue==-102){
                            msg="未设置每周上课天数";
                        }
                        else if(datamsg[0].wordbookValue==-103){
                            msg="未设置每天上课节数";
                        }
                        else if(datamsg[0].wordbookValue==-104){
                            msg="未设置教学起始周";
                        }
                        else if(datamsg[0].wordbookValue==-105){
                            msg="未设置当前学期";
                        }
                        else if(datamsg[0].wordbookValue==-106){
                            msg="未设置动态规则惩罚值";
                        }
                        else if(datamsg[0].wordbookValue==-110){
                            msg="未知错误";
                        }
                        $scope.arrangeStatus = "当前排课状态:排课错误," + msg;
                    }
                },function (data) {
                    closeLoading();
                    parent.pMsg("数据库请求失败");
                });
            }else{
                $scope.arrangeStatus="";
            }
            $scope.$apply();
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
                        //数据初始化
                        timer = $timeout(function(){
                            $scope.loadStatus();
                        },5000);
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


    $scope.loadStatus();
});
</script>
</html>

