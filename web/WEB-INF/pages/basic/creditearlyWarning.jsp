<%--
  Created by IntelliJ IDEA.
  User: gq
  Date: 2017/5/27
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <style>
       caption{
           color: #5c307d;
           margin-top: -10px;
           margin-bottom: 5px;
           margin-left: 20px;
           font-size: 18px;
       }
       .show ul{
           width: 100%;
           padding-left: 40px;
           margin-left: 35px;
           float: left;
       }
       .show li{
           margin: 10px 60px;
           display: inline-flex;
       }
       .show li span{
           min-width: 160px;
           display: inline-block;
           margin-right: 20px;
       }
       .show li>span:first-child{
           color:#5c307d;
           font-family: "微软雅黑";
       }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：学业预警
<hr>
<div class="tablebox">
    <table class="table">
        <caption>在各平台需修满学分 <span style="margin-left: 116px; margin-right: 15px;">[统计]</span><span style="font-size: 16px" ng-bind="'总应修学分'+sum1+'    分|选修学分'+sum2+'   分|未修学分'+sum3+'分'"></span></caption>
        <thead>
        <th>平台</th>
        <th>应修学分</th>
        <th>选修学分</th>
        <th>未修学分</th>
        </thead>
        <tbody>
        <tr ng-repeat="score in scores">
            <td ng-bind="score.terraceName"></td>
            <td ng-bind="score.scoretotal"></td>
            <td ng-bind="score.total"></td>
            <td ng-bind="score.leftcredit"></td>
        </tr>
        </tbody>
    </table>
    <table class="table">
        <caption>本专业在各平台需修满学分 <span style="margin-left: 62px; margin-right: 15px;">[统计]</span><span  style="font-size: 16px" ng-bind="'总应修学分'+sum4+'分|     选修学分'+sum5+'     分|未修学分'+sum6+'分'"></span></caption>
        <thead>
        <th>平台</th>
        <th>应修学分</th>
        <th>选修学分</th>
        <th>未修学分</th>
        </thead>
        <tbody>
        <tr ng-repeat="majorscore in majorscores">
            <td ng-bind="majorscore.terraceName"></td>
            <td ng-bind="majorscore.scorethis"></td>
            <td ng-bind="majorscore.havethis"></td>
            <td ng-bind="majorscore.nohave"></td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.sum1=0;
        $scope.sum2=0;
        $scope.sum3=0;
        $scope.sum4=0;
        $scope.sum5=0;
        $scope.sum6=0;
         $scope.loadStucreditear=function () {
             loading();
             remotecall("stu_creditearly_load",'',function (data) {
                 closeLoading();
                 $scope.scores=data;
                 if(data.length==0){
                     parent.pMsg("暂无数据");
                 }
                 if(data.length>0){
                     for(var i=0;i<data.length;i++){
                         $scope.sum1+=parseFloat(data[i].scoretotal);
                         $scope.sum2+=parseFloat(data[i].total);
                         $scope.sum3+=parseFloat(data[i].leftcredit);
                     }
                 }
             },function (data) {
                 closeLoading();//关闭加载层
                 parent.pMsg("暂无数据");
             });
             loading();
             remotecall("stu_creditearlymajor_load",'',function (data) {
                 closeLoading();
                 $scope.majorscores=data;
                 if(data.length==0){
                     parent.pMsg("暂无数据");
                 }
                 if(data.length>0){
                     for(var i=0;i<data.length;i++){
                         $scope.sum4+=parseFloat(data[i].scorethis);
                         $scope.sum5+=parseFloat(data[i].havethis);
                         $scope.sum6+=parseFloat(data[i].nohave);
                     }
                 }
             },function (data) {
                 closeLoading();//关闭加载层
                 parent.pMsg("暂无数据");
             });
         }
        $scope.loadStucreditear();
    });
</script>
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>