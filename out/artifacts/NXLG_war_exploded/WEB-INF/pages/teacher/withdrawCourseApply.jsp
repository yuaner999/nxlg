<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/23
  Time: 19:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：退选申请
<hr>
<table-nav>
    <li ng-click="dofilter(1)" class="sele">选课列表</li>
    <li ng-click="dofilter(0)">退课列表</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <input class="tablesearchbtn" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadData()">搜索</table-btn>
    <span>退课开始时间：<span style="color: #FF1F06" ng-bind="tuikestart"></span></span>&nbsp;
    <span>退课结束时间：<span style="color: #FF1F06" ng-bind="tuikeend"></span></span>
</div>
<!--选修课程列表-->
<div class="tablebox" id="allInfo">
    <table class="table">
        <thead>
        <th>学号</th>
        <th>姓名</th>
        <th>课程代码</th>
        <th>课程名</th>
        <th>平台</th>
        <th>所在班级</th>
        <th>教师</th>
        <th>当前学期</th>
        <th  ng-if="Var==true">状态</th>
        <th  ng-if="Var==true">申请理由</th>
        <th  ng-if="Var==true">申请拒绝</th>
        <th  ng-if="Var==false"></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td ng-bind="data.studentNum"></td>
            <td ng-bind="data.studentName"></td>
            <td ng-bind="data.courseCode"></td>
            <td ng-bind="data.chineseName"></td>
            <td ng-bind="data.terraceName"></td>
            <td ng-bind="data.class"></td>
            <td ng-bind="data.teacherName"></td>
            <td ng-bind="data.term"></td>
            <td  ng-if="Var==true" ng-bind="data.scc_status"></td>
            <td  ng-if="Var==true&&(data.Areason.length<=10||data.Areason==null)" ng-bind="data.Areason"></td>
            <td  ng-if="Var==true&&data.Areason.length>10" ng-bind="data.Arsn" ng-click="AreasonDetail(data.Areason,$index)" class="Ar"></td>
            <td  ng-if="Var==true&&(data.Rreason.length<=10||data.Rreason==null)" ng-bind="data.Rreason"></td>
            <td  ng-if="Var==true&&data.Rreason.length>10" ng-bind="data.Rrsn" ng-click="RreasonDetail(data.Rreason,$index)" class="Rr"></td>
            <td  ng-if="Var==false"><table-btn ng-click="withdraw(data)">退选</table-btn></td>
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
    var filter=1;
    var Var=false;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.datalist = [];
        $scope.dataitem = {};
        $scope.Var=false;
        $scope.loadData = function (){
            loading();//加载
            remotecall("withdrawCourseApply_load",{pageNum:pageNum,pageSize:pageSize,filter:filter,searchStr:searchStr}, function (data) {
                closeLoading();
                if(data==0||data==1){
                    parent.pMsg("该用户没有权限");
                }else if(data==2){
                    parent.pMsg("暂不是退选时间");
                }else{
                    $scope.datas = data.rows;
                }
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

                //分页加载跳转到指定页

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
                        //重新加载用户信息
                        $scope.loadData();
                    }
                };
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
            remotecall("basic_coursechoosetime_load",'',function (data) {
                if(data!=null&&data!=""){
                    $scope.tuikestart = data[0].tuikestart;
                    $scope.tuikeend = data[0].tuikeend;
                }
                else{
                    parent.pMsg("当前未设置选课时间");
                }
                closeLoading();//关闭加载层
            },function (data) {
                parent.pMsg("加载时间失败");
                closeLoading();//关闭加载层
            });
        }
        //右侧菜单栏
        $scope.dofilter=function(str){
            pageNum=1;
            filter = str;
            if(str==0){
                $scope.Var=true;
            }else if(str==1){
                $scope.Var=false;
            }
            $scope.loadData();
        }

        //返回上一级
        $scope.loadData();
        $scope.withdraw=function(tr){
            filter=0;
            $scope.datalist.push(tr);
            $scope.dataitem = $scope.datalist[0];
            var scc=$scope.dataitem.scc;
            if(nowTime()<ConvertDateFromString($scope.tuikestart)||nowTime()>ConvertDateFromString($scope.tuikeend)){
                parent.pMsg("请在规定时间内退课");
                return;
            }
            layer.prompt({
                title: '申请退课理由',
                formType: 2,
            }, function (str) {
                loading();
                if(str==""||str==null){return;}
                remotecall("withdrawCourseApply_apply",{scc:scc,reason:str},function (data) {
                    closeLoading();//关闭加载层
                    if(data){
                        $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                        parent.pMsg("退选申请成功");
                        filter=1;
                        $scope.loadData();
                        $scope.$apply();
                    }else {
                        parent.pMsg("退选申请失败");
                    }
                },function (data) {
                    parent.pMsg("退选请求失败");
                    closeLoading();//关闭加载层
                });
            },function () {
                filter=1;
                $scope.loadData();;
            });
        }
        //理由详情
        $scope.AreasonDetail=function(data,i){
            if(data==null||data==""||data.length<=5)return;
            $(".Ar:eq("+i+")").addClass("RRR");
            layer.tips(data,".RRR" ,{
                tips: [4, '#c5add7'],
                time: 3000
            });
            $(".Ar:eq("+i+")").removeClass("RRR");
        }
        $scope.RreasonDetail=function(data,i){
            if(data==null||data=="")return;
            $(".Rr:eq("+i+")").addClass("RRR");
            layer.tips(data,".RRR" ,{
                tips: [4, '#c5add7'],
                time: 3000
            });
            $(".Rr:eq("+i+")").removeClass("RRR");
        }
    });
    //时间：将字符型转为时间型，值为毫秒
    function ConvertDateFromString(dateString) {
        if (dateString) {
            var arr1 = dateString.split(" ");
            var sdate = arr1[0].split('-');
            var mdate = arr1[1].split(':');
            var date = (new Date(sdate[0],sdate[1],sdate[2],mdate[0],mdate[1],mdate[2])).getTime();
            return date;
        }
    }
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
