<%--
  Created by IntelliJ IDEA.
  User: gq
  Date: 2017/6/3
  Time: 10:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <style>
        .table-show{
            position:relative;
            top: 0;
            left: 0 !important;
        }
        .table-show .row{
            padding: 10px 0;
        }
        .table-show .bttn{
            margin-left: 25%;
            border: 1px solid #c5add7;
            height: 26px;
            background: #edeaf1;
        }
        .table-show ul{
            width: 30%;
            float: left;
        }
        .table-show li{
            margin: 10px -10px;
            display: inline-flex;
        }
        .table-show li span{
            width: 200px;
            display: inline-block;
        }
        .table-show li>span:first-child,.newword{
            color:#5c307d;
            font-family: "微软雅黑";
            margin-right:-90px;
        }
        .first span{
            font-size: 17px;
            color: red;
        }
        .title .tablesearchbtn{
            width: 120px;
            margin-left: 5px;
        }
        <%--查看详情--%>
        .table-courseshow{
            display: none;
            position: absolute;
            top: 20%;
            left: 20% !important;
            z-index: 100;
            max-width: 1026px;
            min-width: 750px;
            padding-top: 70px;
            border: 1px solid #c5add7;
            background-color: #edeaf1;
            padding-bottom: 70px;
        }
        .bttn{
            margin-left: 26%;
            margin-top:30px;
            border: 1px solid #c5add7;
            height: 26px;
            background: #edeaf1;
        }
        .show ul{
            width: 25%;
            padding-left: 40px;
            margin-left: 35px;
            float: left;
        }
        .show li{
            margin: 10px 60px;
            display: inline-flex;
        }
        .show li span{
            min-width: 105px;
            display: inline-block;
            margin-right: 20px;
        }
        .show li>span:first-child{
            color:#5c307d;
            font-family: "微软雅黑";
        }
        .black{
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            background: #000;
            opacity: 0.5;
            filter: alpha(opacity=0.2);
            z-index: 9;
            display: none;
        }
        #selectcourse{
            height: 400px;
            border: 1px solid #c5add7;
            margin-top: 31px;
            padding: 24px;
            overflow-y: scroll;
            position: relative;
            /* scrollbar-base-color: #c5add7;
             scrollbar-shadow-color: #fff;*/
        }
        #selectcourse .table caption{
            color: #5c307d;
            margin-top: -10px;
            margin-bottom: 5px;
            margin-left: 20px;
            font-size: 18px;
        }
        .btn-selectcourse{
            position: absolute;
            right: 26px;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：学生缴费统计
<hr>
<div class="title">
    <span ng-if="show==1">班级名称：</span>
    <select  ng-model="para.studentClass" name="studentClass" class="forminput" id="studentClass"  ng-if="show==1">
        <option value="" >--请选择--</option>
        <option ng-repeat="class in classes" value="{{class.className}}">{{class.className}}</option>
    </select>
    <span  ng-if="show==1">学期名称：</span>
    <select  ng-model="para.semester" name="semester" class="forminput" id="semester"  ng-if="show==1">
        <option value="" >--请选择--</option>
        <option ng-repeat="semester in semesters" value="{{semester.semester}}">{{semester.semester}}</option>
    </select>
    <table-btn ng-if="show=='1'" id="search" ng-click="loadDataFirst()"  ng-if="show==1">搜索</table-btn>
    <table-btn ng-if="show=='2'" class="top" ng-click="previous()"  ng-if="show==2">返回</table-btn>
</div>
<%--学生列表--%>
<div class="tablebox" ng-if="show=='1'" id="student">
    <table class="table">
        <thead>
        <th>班级</th>
        <th>学期</th>
        <th>总人数</th>
        <th>已缴费人数</th>
        <th>欠费人数</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="statistics in statisticses">
            <td ng-bind="statistics.studentClass"></td>
            <td ng-bind="statistics.semester"></td>
            <td ng-bind="statistics.total"></td>
            <td ng-bind="statistics.noPay"></td>
            <td ng-bind="statistics.alreadyPayed"></td>
            <td><table-btn ng-click="detail(statistics)">查看详情</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--学生选课--%>
<div class="tablebox" ng-if="show=='2'" id="s_course">
    <table class="table">
        <thead>
        <th>学生姓名</th>
        <th>应缴金额</th>
        <th>实缴金额</th>
        <th>缴费状态</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td ng-bind="data.studentName"></td>
            <td ng-bind="data.shouldPay"></td>
            <td ng-bind="data.realPay"></td>
            <td ng-bind="data.status"></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.show=1;
        $scope.para={};
        remotecall("studentPaymentStatistics_load",{},function (data) {
            $scope.classes = data.className;
            $scope.semesters = data.semester;
        },function (data) {
        });
        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadData();
        }

        $scope.loadData = function () {
            $(".pagingbox").show();
            $scope.show=1;
            loading();//加载
            remotecall("studentPaymentStatistics_load",{pageNum:pageNum,pageSize:pageSize,className:$scope.para.studentClass,semester:$scope.para.semester},function (data) {
                closeLoading();
                $scope.statisticses = data.statistics.rows;
                pageCount = parseInt((data.statistics.total-1)/pageSize)+1;//页码总数
                // 分页逻辑开始
                $scope.allPage=[];
                $scope.sliPage=[];
                for(var i=1;i<=Math.ceil(data.statistics.total/pageSize);i++){
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
                //数据为0时提示
                if(data.statistics.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
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
        //checked 复选框判断
        $scope.loadData();
        //查看班级缴费情况
        $scope.detail=function(tr){
            $(".pagingbox").hide();
            $scope.show=2;
            loading();//加载
            remotecall("studentPaymentStatistics_loaddetail",tr, function (data) {
                closeLoading();
                if(data.length>0){
                    $scope.datas = data;
                }else{
                    $scope.datas=[];
                    parent.pMsg("没有缴费信息");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
        }

        //查看详情
        $scope.showCourse=function (course) {
            $scope.course=course;
            $('.table-courseshow,.black').show();
        }
        //关闭详情
        $scope.close=function () {
            $('.table-courseshow,.black').hide();
        }
        $scope.previous=function () {
            $(".pagingbox").show();
            $scope.loadData();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>