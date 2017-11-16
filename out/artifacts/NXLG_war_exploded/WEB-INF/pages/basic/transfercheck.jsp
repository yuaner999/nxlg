<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/6/12
  Time: 13:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <style>
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
        .show ul{
            width: 80%;
            padding-left: 40px;
            margin-left: 35px;
            float: left;
        }
        .show li{
            width: 100%;
            margin: 10px 60px;
            display: block;
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
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：调剂审核
<hr>
<table-nav>
    <li ng-click="dofilter(1)" class="sele">待审核列表</li>
    <li ng-click="dofilter(0)" >其他列表</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-if="show==false" ng-click="pass()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>通过</table-btn>
    <table-btn ng-if="show==false" ng-click="reject()"><img src="<%=request.getContextPath()%>/images/tablereject.png"/>拒绝</table-btn>
    <input class="tablesearchbtn s" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="search()">搜索</table-btn>
</div>

<!--表格-->
<div style="width:100%">
    <div class="tablebox" style="width:100%;">
        <table class="table" style="table-layout:fixed">
            <thead>
            <th ng-if="show==false" class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
            <th>学号</th>
            <th>学生</th>
            <th>申请学期</th>
            <th>主专业</th>
            <th>辅修专业</th>
            <th>原因</th>
            <th>申请日期</th>
            <th>审核状态</th>
            <th ng-if="show">拒绝原因</th>
            <th></th>
            </thead>
            <tbody>
            <tr ng-repeat="data in datas">
                <td ng-if="show==false" class="thischecked" ng-click="thischecked(data)">
                    <input type="checkbox" ng-checked="data.td0" name="transferid" value="{{data.transferid}}"/>
                </td>
                <td ng-bind="data.studentNum"></td>
                <td ng-bind="data.studentName"></td>
                <td ng-bind="data.term"></td>
                <td ng-bind="data.studentMajor"></td>
                <td ng-bind="data.otherMajor"></td>
                <td ng-bind="data.reason" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"></td>
                <td ng-bind="data.setdate"></td>
                <td ng-bind="data.status"></td>
                <td style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%" ng-bind="data.reject" ng-if="show"></td>
                <td> <table-btn ng-click="detail(data)">查看详情</table-btn></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
<div class="black"></div>
<div class="table-courseshow">
    <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <ul>
            <li><span>申请学期：</span><span ng-bind="z.term"></span></li>
            <li><span>调剂原因：</span><span style=" word-wrap: break-word;display: block; margin-left: 123px; margin-top: -20px; min-height: 20px;" ng-bind="z.reason"></span></li>
            <li><span>审核状态：</span><span ng-bind="z.status"></span></li>
            <li ng-if="z.status!='已通过'"><span>拒绝原因：</span><span style="word-wrap: break-word;display: block; margin-left: 123px; margin-top: -20px; min-height: 20px;" ng-bind="z.reject"></span></li>
        </ul>
    </div>
</div>
<div class="black"></div>
<div class="pagingbox">
    <paging></paging>
</div>
</body>
</html>
<script>
    var num=0;
    var filter=1;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载信息
        $scope.all=false;
        $scope.show=false;
        $scope.datalist=[];
        $scope.dataitem={};
        $scope.search = function () {
            loading();//加载
            remotecall("stu_transfercheck_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr,filter:filter},function (data) {
                closeLoading();
                //数据为0时提示
                    $scope.datas=data.rows;
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
                    for(i=0;i<$scope.datas.length;i++){
                        $scope.datas[i].td0=false;
                    }
                if(data.total==0){
                    parent.pMsg("暂时没有调剂申请信息");
                }
                $scope.datalist=[];
                $scope.dataitem={};
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
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
                //重新加载数据
                $scope.search();
            }
        };
        $scope.dofilter=function(str){
            pageNum=1;
            if(str==1){
                $scope.show=false;
            }else if(str==0){
                $scope.show=true;
            }
            filter = str;
            $scope.search();
        }
        $scope.search();
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
            if(num==$scope.datas.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                $scope.all =true;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=true
                    $scope.datalist.push($scope.datas[i]);
                }
                num=$scope.datas.length;
            }else{
                $scope.all =false;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                $scope.datalist=[];
                $scope.dataitem={};
                num=0;
            }
        };
        $scope.detail=function (data) {
            $scope.z=data;
            $(".table-courseshow").show();
            $(".black").show();
        }
        $scope.close=function () {
            $(".table-courseshow").hide();
            $(".black").hide();
        };
        //通过功能
        $scope.pass = function () {
            var checknum=$scope.datalist.length;
            if(checknum<1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else{
                parent.pConfirm("确认通过选中的所有内容吗？",function () {
                    loading();
                    remotecallasync("stu_transfercheck_pass",{passIds:$scope.datalist},function (data) {
                        closeLoading();//关闭加载层
                        if(data){
                            parent.pMsg("审核通过");
                            //重新加载菜单
                            $scope.search();
                            $scope.$apply();
                        }else {
                            parent.pMsg("审核不通过");
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("审核请求失败");
                        console.log(data);
                    });
                },function () {});
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
                        if(str==""){layer.msg("请输入拒绝理由");return;}else if(str.length>500){parent.pMsg("拒绝理由500字以内");return;}
                        loading();
                        remotecallasync("stu_transfercheck_reject",{transferid:$scope.dataitem.transferid,reason:str},function (data) {
                            closeLoading();//关闭加载层
                            if(data){
                                $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                                $scope.search();
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
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
