<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/15
  Time: 16:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <style>
        .table-majorshow{
            position: absolute;
            top: 20%;
            left: 20% !important;
            z-index: 100;
            max-width: 1026px;
            min-width: 750px;
            padding: 70px;
            border: 1px solid #c5add7;
            background-color: #edeaf1;
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
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：开课班级审核
<hr>
<table-nav>
    <li ng-click="dofilter(0)" class="sele"  style="width: 150px">待审核开课班级</li>
    <li ng-click="dofilter(1)" style="width: 150px">现有开课班级列表</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-if="show==1" ng-click="pass()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>通过</table-btn>
    <table-btn ng-if="show==1" ng-click="reject()"><img src="<%=request.getContextPath()%>/images/tablereject.png"/>拒绝</table-btn>
</div>
<!--平台课程列表-->
<div class="tablebox" id="allInfo">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th ng-if="show==1" class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
        <th>课程名</th>
        <th>负责教师</th>
        <th>所分班级</th>
        <th>班级教师</th>
        <th>人数范围</th>
        <th>授课方式</th>
        <th>授课周时</th>
        <th>单双周</th>
        <th>先行课程</th>
        <th>所属专业</th>
        <th>审核状态</th>
        <th>审核类别</th>
        <th ng-if="Var">未通过原因</th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-if="show==1" class="thischecked" ng-click="thischecked(Info)">
                <input type="checkbox" ng-model="Info.td0" name="tc_id" value="{{Info.tc_id}}"/>
            </td>
            <td ng-bind="Info.chineseName"></td>
            <td ng-bind="Info.teacherName"></td>
            <td ng-bind="Info.tc_class"></td>
            <td ng-bind="Info.teacherName1"></td>
            <td ng-bind="Info.tc_numrange"></td>
            <td ng-bind="Info.tc_teachway"></td>
            <td ng-bind="Info.tc_teachweek"></td>
            <td ng-bind="Info.tc_teachodd"></td>
            <td ng-bind="Info.tc_teachmore"></td>
            <td><table-btn ng-click="showmajor(Info)">查看</table-btn></td>
            <td ng-bind="Info.tc_checkStatus"></td>
            <td ng-bind="Info.tc_checkType"></td>
            <td ng-if="Var" ng-bind="Info.tc_refuseReason" class="Ar" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"  ng-click="ReasonDetail(Info.tc_refuseReason,$index)"></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="black"></div>
<div class="pagingbox">
    <paging></paging>
</div>
<div class="table-majorshow" ng-show="majorshow">
    <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <table class="table">
            <thead>
            <th>专业名称</th>
            <th>所属学院</th>
            <th>专业代码</th>
            <th>培养层次</th>
            <th>专业状态</th>
            </thead>
            <tbody>
            <tr ng-repeat="data in majors">
                <td ng-bind="data.majorName"></td>
                <td ng-bind="data.majorCollege"></td>
                <td ng-bind="data.majorCode"></td>
                <td ng-bind="data.level"></td>
                <td ng-bind="data.majorStatus"></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
<script>
    var filter=0;
    var ep_id=null;
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function ($scope) {
        $scope.Var=false;
        $scope.show = 1;
        $scope.all = false;
        $scope.datalist=[];
        $scope.dataitem={};
        //加载数据
        $scope.loadData = function (){
            loading();//加载
            remotecall("educateTaskCheck_load",{filter:filter,pageNum:pageNum,pageSize:pageSize},function (data) {
                closeLoading();//关闭加载层
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
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            $scope.datalist=[];
            $scope.dataitem={};
        }
        $scope.loadData();
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
                if($scope.Var){
                    filter=1;
                }else{
                    filter=0;
                }
                $scope.loadData();
            }
        };
        $scope.dofilter=function(str){
            pageNum=1;
            if(str==1){
                $scope.Var=true;
                $scope.show = "";
            }else if(str==0){
                $scope.Var=false;
                $scope.show = 1;
            }
            filter = str;
            $scope.loadData();
        }
        //通过功能
        $scope.pass = function () {
            var checknum=$scope.datalist.length;
            if(checknum<1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else{
                loading();
                parent.pConfirm("确认通过选中的所有内容吗？",function () {
                    remotecallasync("educateTaskCheck_pass",{passIds:$scope.datalist},function (data) {
                        if(data==1){
                           closeLoading();
                            parent.pMsg("审核通过");
                            $scope.dofilter(0);
                            $scope.loadData();
                            $scope.$apply();
                        }else {
                            parent.pMsg("审核不通过");
                            closeLoading();
                        }
                    },function (data) {
                        parent.pMsg("审核请求失败");
                        closeLoading();
                    });
                },function () {closeLoading();});
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
                        remotecallasync("educateTaskCheck_reject",{tc_id:$scope.dataitem.tc_id,reason:str},function (data) {
                            if(data){
                                $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                                $scope.loadData();
                                $scope.$apply();
                            }else {
                                parent.pMsg("添加失败");
                            }
                        },function (data) {
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
                $scope.all=false;
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
                $scope.all =true;
                for(i=0;i<$scope.allInfo.length;i++){
                    $scope.allInfo[i].td0=true;
                    $scope.datalist.push($scope.allInfo[i]);
                }
                num=$scope.allInfo.length;
            }else{
                $scope.all =false;
                for(i=0;i<$scope.allInfo.length;i++){
                    $scope.allInfo[i].td0=false
                }
                $scope.datalist=[];
                $scope.dataitem={};
                num=0;
            }
        };
        $scope.showmajor=function (task) {
            loading();
            var tc_id=task.tc_id;
            remotecall("basic_teachtask_loadmajor",{tc_id:tc_id},function (data) {
                closeLoading();//关闭加载层
                $scope.majors=data;
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
            $scope.majorshow=true;
            $(".black,table").show();
        }
        $scope.ReasonDetail=function(data,i){
            if(data==null||data==""||data.length<=5)return;
            $(".Ar:eq("+i+")").addClass("RRR");
            layer.tips(data,".RRR" ,{
                tips: [4, '#c5add7'],
                time: 3000
            });
            $(".Ar:eq("+i+")").removeClass("RRR");
        }
        $scope.Detail=function(data,i){
            $(".Arr:eq("+i+")").addClass("RRRr");
            layer.tips(data,".RRRr" ,{
                tips: [4, '#c5add7'],
                time: 3000
            });
            $(".Arr:eq("+i+")").removeClass("RRRr");
        };
        $scope.close=function () {
            $(".pagingbox").show();
            $(".black").hide();
            $scope.majorshow=false;
        };
    });

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
