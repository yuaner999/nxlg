<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-05-2
  Time: 15:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：开课课程审核
<hr>
<table-nav>
    <li ng-click="dofilter(0)" class="sele">待审核列表</li>
    <li ng-click="dofilter(1)" >现有开课课程</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-if="show==2" id="search" ng-click="previous()">返回</table-btn>
    <table-btn ng-if="show==2" ng-click="pass()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>通过</table-btn>
    <table-btn ng-if="show==2" ng-click="reject()"><img src="<%=request.getContextPath()%>/images/tablereject.png"/>拒绝</table-btn>
    <input ng-show="show==3" class="tablesearchbtn" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>
    <table-btn ng-if="show==3" id="search" ng-click="loadData()">搜索</table-btn>
</div>
<%--学院待审核总量--%>
<div class="tablebox" id="Infoall" ng-if="show==1">
    <table class="table">
        <thead>
        <th>学院</th>
        <th>待审核</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="In in Infoall">
            <td ng-bind="In.college"></td>
            <td ng-bind="In.checkall"></td>
            <td><table-btn ng-click="Cdetail(In)">查看</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<!--平台课程列表-->
<div class="tablebox" id="allInfo" ng-if="show==2||show==3">
    <table class="table">
        <thead>
        <th ng-if="show==2" class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
        <th>年级</th>
        <th>学院</th>
        <th>专业</th>
        <th>培养层次</th>
        <th>平台</th>
        <th>课程</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th>开课学期</th>
        <th>主修/辅修</th>
        <th>备注</th>
        <th>审核状态</th>
        <th>审核类别</th>
        <th ng-if="Var">未通过原因</th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-if="show==2" class="thischecked" ng-click="thischecked(Info)">
                <input type="checkbox" ng-model="Info.td0" name="mtc_id" value="{{Info.mtc_id}}"/>
            </td>
            <td  ng-bind="Info.mtc_grade"></td>
            <td ng-bind="Info.majorCollege"></td>
            <td ng-bind="Info.majorName"></td>
            <td ng-bind="Info.level"></td>
            <td ng-bind="Info.terraceName"></td>
            <td ng-bind="Info.chineseName"></td>
            <td ng-bind="Info.courseCategory_3"></td>
            <td ng-bind="Info.courseCategory_4"></td>
            <td ng-bind="Info.courseCategory_5"></td>
            <td ng-bind="Info.mtc_courseTerm"></td>
            <td ng-bind="Info.mtc_majorWay"></td>
            <td ng-bind="Info.mtc_note"></td>
            <td ng-bind="Info.mtc_checkStatus"></td>
            <td  ng-bind="Info.mtc_checkType"></td>
            <td  ng-if="Var" ng-bind="Info.mtc_refuseReason"></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox" ng-if="show==2||show==3">
    <paging></paging>
</div>

</body>
</html>
<script>
    var filter=0;
    var mtc_id=null;
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function ($scope) {
        $scope.Var=true;
        $scope.show=1;
        $scope.all = false;
        $scope.datalist=[];
        $scope.dataitem={};
        //学院待审核总量
        $scope.loadInfoall=function(){
            $scope.datalist=[];
            $scope.dataitem={};
            loading();
            remotecall("teacher_terraceCourseCheck_loadall","",function (data) {
                closeLoading();
                $scope.Infoall = data;
                $scope.show=1;
                $scope.Var=true;
                if(data.length<1){parent.pMsg("暂无审核数据");}
              //  $scope.$apply();
            },function (data) {
                closeLoading();
                parent.pMsg("数据库请求失败");
            });
        }
        $scope.loadInfoall();
        $scope.Cdetail=function(tr){
            $scope.item={};
            $scope.item=tr;
            $scope.datalist=[];
            $scope.dataitem={};
            var college=tr.college;
            remotecallasync("teacher_terraceCourseCheck_Collegechecked",{pageNum:pageNum,pageSize:pageSize,college:college},function (data) {
                closeLoading();
                $scope.allInfo = data.rows;
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
                num=0;
                $scope.all = false;
                for(i=0;i<$scope.allInfo.length;i++){
                    $scope.allInfo[i].td0=false;
                }
                $scope.show=2;
                $scope.$apply();
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("数据库请求失败");
            });
        }
        $scope.previous=function(){
            $scope.loadInfoall();
        }
        //加载数据
        $scope.loadData = function (){
            loading();//加载
            remotecall("teacher_terraceCourseCheck_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                $scope.allInfo = data.rows;
                closeLoading();//关闭加载层
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
                num=0;
                $scope.all = false;
                for(i=0;i<$scope.allInfo.length;i++){
                    $scope.allInfo[i].td0=false;
                }
                $scope.show=3;
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
        }

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
                if($scope.show==2){
                    $scope.Cdetail($scope.item);
                }else if($scope.show==3){
                    $scope.loadData();
                }
            }
        };
        $scope.dofilter=function(str){
            pageNum=1;
            if(str==1){
                $scope.Var=false;
                $scope.show=3;
                $scope.loadData();
            }else if(str==0){
                $scope.Var=true;
                $scope.show=1;
                $scope.loadInfoall();
            }
        }
        //通过功能
        $scope.pass = function () {
            var checknum=$scope.datalist.length;
            if(checknum<1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else{
                //$scope.dataitem=$scope.datalist[0];
                loading();
                parent.pConfirm("确认通过选中的"+checknum+"条内容吗？",function () {
                    remotecall("teacher_terraceCourseCheck_pass",{passIds:$scope.datalist},function (data) {
                        closeLoading();//关闭加载层
                        if(data){
                            parent.pMsg("审核通过");
                            //重新加载菜单
                            $scope.Cdetail($scope.item);
                            $scope.$apply();
                        }else {
                            parent.pMsg("审核不通过");
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("审核请求失败");
                        console.log(data);
                    });
                },function () {
                    closeLoading();//关闭加载层
                });
            }
        };
        //拒绝
        $scope.reject = function () {
            var checknum=$scope.datalist.length;
            if(checknum!=1) {
                parent.pMsg("只能选择一条记录");
                return;
            }
            else{
                $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").show();
                $(".layui-layer-shade").hide();
                $scope.dataitem=$scope.datalist[0];
                layer.prompt({
                    title: '未通过原因',
                    formType: 2,
                }, function (str) {
                    if (str) {
                        loading();
                        remotecallasync("teacher_terraceCourseCheck_reject",{mtc_id:$scope.dataitem.mtc_id,reason:str},function (data) {
                            closeLoading();//关闭加载层
                            if(data){
                                $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                                $scope.Cdetail($scope.item);
                                $scope.$apply();
                            }else {
                                parent.pMsg("添加失败");
                            }
                        },function (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("数据库请求失败");
                            console.log(data);
                        });
                        return false;
                    }
                });
            }
        };
        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.datalist.push(tr);
            }else{
                num--;
                tr.td0 = false;
                var index = $scope.datalist.indexOf(tr);
                if (index > -1) {
                    $scope.datalist.splice(index, 1);
                }
            }
            if(num==$scope.allInfo.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                $scope.all=true;
                for(i=0;i<$scope.allInfo.length;i++){
                    $scope.allInfo[i].td0=true;
                    $scope.datalist.push($scope.allInfo[i]);
                }
                num=$scope.allInfo.length;
            }else{
                $scope.all=false;
                for(i=0;i<$scope.allInfo.length;i++){
                    $scope.allInfo[i].td0=false;
                    $scope.datalist=[];
                    $scope.dataitem={};
                }
                num=0;
            }
        };
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>