<%--
  Created by IntelliJ IDEA.
  User: NEUNB_Lisy
  Date: 2017/5/25
  Time: 16:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>

    <style>
        .span_width{
            width: 90px;
        }
        .row{
            padding-left: 252px !important;
            margin-right: 0px !important;
        }
        .forminput{
            margin-right:80px !important;
        }
        .text-center{
            position: absolute;
            left:33%;
        }
        .table-addform{
            display: none;
            padding: 15px 0 0 25px;
        }
        .result{
            margin-top: 10px;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：空余教室查询
<hr>
<div class="search">
        <span class="span_width">周时：</span>
    <select type="text" ng-model="searchRoom.teachweek" name="teachweek" class="forminput" id="teachweek"/>
    <option value="0">--请选择--</option>
    <option value="1">第01周</option>
    <option value="2">第02周</option>
    <option value="3">第03周</option>
    <option value="4">第04周</option>
    <option value="5">第05周</option>
    <option value="6">第06周</option>
    <option value="7">第07周</option>
    <option value="8">第08周</option>
    <option value="9">第09周</option>
    <option value="10">第10周</option>
    <option value="11">第11周</option>
    <option value="12">第12周</option>
    <option value="13">第13周</option>
    <option value="14">第14周</option>
    <option value="15">第15周</option>
    <option value="16">第16周</option>
    <option value="17">第17周</option>
    <option value="18">第18周</option>
    <option value="19">第19周</option>
    <option value="20">第20周</option>
    </select>

    <span class="span_width">上课日期：</span>
    <select type="text" ng-model="searchRoom.timeweek" name="timeweek" class="forminput" id="timeweek"/>
    <option value="0">--请选择--</option>
    <option value="1">星期一</option>
    <option value="2">星期二</option>
    <option value="3">星期三</option>
    <option value="4">星期四</option>
    <option value="5">星期五</option>
    <option value="6">星期六</option>
    <option value="7">星期天</option>
    </select>

    <span class="span_width">节次：</span>
    <select type="text" ng-model="searchRoom.timepitch" name="timepitch" class="forminput" id="timepitch"/>
    <option value="0">--请选择--</option>
    <option value="1">第一节</option>
    <option value="2">第二节</option>
    <option value="3">第三节</option>
    <option value="4">第四节</option>
    <option value="5">第五节</option>
    </select>
    <table-btn id="search" ng-click="loadData()">查询</table-btn>
    <table-btn style="width: 170px;margin-left: 20px;" ng-click="btnExcel()" class="btnExcel">导出空闲教室信息</table-btn>
    <form id="exportTo" method="post" hidden>
    </form>
</div>
<%--查询结果--%>
<div class="result">
    <table class="table">
        <thead class="checked">
            <th>校区</th>
            <th>教学楼</th>
            <th>楼层</th>
            <th>教室号</th>
            <th>教室名称</th>
            <th>教室类型</th>
            <th>教室容量</th>
            <th>教室面积</th>
            <th>状态</th>
        </thead>
        <tbody ng-repeat="data in datas track by $index">
            <td ng-bind="data.campus"></td>
            <td ng-bind="data.building"></td>
            <td ng-bind="data.floor"></td>
            <td ng-bind="data.classroomNum"></td>
            <td ng-bind="data.classroomName"></td>
            <td ng-bind="data.classroomType"></td>
            <td ng-bind="data.classroomCapacity"></td>
            <td ng-bind="data.classroomArea"></td>
            <td ng-bind="data.classroomStatus"></td>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
</body>
<script>
var app = angular.module('app',[]);
app.controller('ctrl',function  ($scope) {
    $scope.searchRoom={
        teachweek:"0",
        teachodd:"单周",
        timeweek:"0",
        timepitch:"0"
    };
    $scope.loadData=function () {
        loading();
        if($scope.searchRoom.teachweek%2==0){
            $scope.searchRoom.teachodd="单周";
        }else if($scope.searchRoom.teachweek%2==1){
            $scope.searchRoom.teachodd="双周";
        }
        var teachweek=$scope.searchRoom.teachweek;
        var teachodd=$scope.searchRoom.teachodd;
        var timeweek=$scope.searchRoom.timeweek;
        var timepitch=$scope.searchRoom.timepitch;
        remotecall("checkUnuseCRoom",{pageNum:pageNum,pageSize:pageSize,teachweek:teachweek,teachodd:teachodd,timeweek:timeweek,timepitch:timepitch},function (data) {
            pageCount = parseInt((data.total-1)/pageSize)+1;//页码总数
            // 分页逻辑开始
            $scope.allPage=[];
            $scope.sliPage=[];
            for(var i=1;i<=Math.ceil(data.total/pageSize);i++){
                $scope.allPage.push(i);
            }
            for(var i=0;i<$scope.allPage.length;i+=pageShow){
                $scope.sliPage.push($scope.allPage.slice(i,i+pageShow));
            }
            $scope.TotalPageCount=$scope.allPage.length;
            $scope.TotalDataCount=data.total;
            $scope.pages=$scope.sliPage[Math.ceil(pageNum/pageShow)-1];
            $('.paging li').removeClass('sele');
            if(pageNum%pageShow==0&&pageNum!=0){
                var dx=pageShow-1;
            }else{
                var dx=pageNum%pageShow-1;
            }
            setTimeout(function () {
                $('.paging li').eq(dx).addClass('sele')
            },100);

            $scope.datas=data.rows;
            closeLoading();
            if(!data){
                parent.pMsg("该时间教室都在使用");
                $(".pagingbox").hide();
            }else {
                $(".pagingbox").show();
            }
        },function (data) {
            closeLoading();
            console.log(data);
            parent.pMsg("连接数据库失败");
        });
    };
    //分页
    $scope.gotoPage = function (pn,i) {
        if(pn==-1){//上一页
            pn = pageNum-1;
        }
        if(pn==-2){//下一页
            pn = pageNum+1;
        }
        if(pn==-3){//最后一页
            pn = pageCount;
        }
        if(pn<1||pn>pageCount){//页码不正确
            return;
        }else {
            pageNum = pn;//改变当前页
            //重新加载菜单
            $scope.loadData();
        }
    };
    //导出到信息到Excel
    $scope.btnExcel=function () {
        var url="../../export/exportUnuseClassroomInfo.form?teachweek="
            +$scope.searchRoom.teachweek+"&teachodd="+$scope.searchRoom.teachodd+"&timeweek="+$scope.searchRoom.timeweek+"&timepitch="+$scope.searchRoom.timepitch;
        $("#exportTo").attr("action",url);
        $("#exportTo").submit();
    }
    //默认加载全部
    $scope.loadData();
});
</script>
</html>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
