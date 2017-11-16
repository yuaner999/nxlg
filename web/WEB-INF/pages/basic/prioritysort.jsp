<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-15
  Time: 15:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <style>
        .black{
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            background: #000;
            opacity: 0.3;
            filter: alpha(opacity=0);
            z-index: 7;
            display: none;
        }
        .table-detail{
            display: none;
            position: absolute;
            top: 30%;
            left: 35% !important;
            z-index: 10;
            width: 500px;
            min-width: 300px;
            padding: 70px 10px 10px;
            border: 1px solid #c5add7;
            background-color: #ffffff;
        }
        .detail{
            margin-left:10px;
        }
        .detail li{
            margin-bottom:10px;
            margin-left: 50px;
        }
        .detail li span{
            margin-right:5px;
            width:110px;
            display: inline-block;
        }
        .detail label {
            padding-left: 20px;
            cursor: pointer;
            background: url(../../images/bg_radio.jpg) no-repeat left top;
            background-size: 20px;
        }
        .detail .checked3 {
            background-position: left bottom;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：优先级设置
<hr>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th>序号</th>
        <th>优先级名称(从高到低)</th>
        <th></th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td ng-bind="data.sort">1</td>
            <td ng-bind="data.priorityname"></td>
            <td><table-btn ng-click="set(data)">设置</table-btn></td>
            <td><table-btn ng-click="up(data)">上移</table-btn><b style="margin-right: 10px"></b><table-btn ng-click="down(data)">下移</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="table-detail">
    <form id="MenuForm">
        <div class="row">
            <ul class="detail">
                <li><input type="text" hidden ng-model="it.id" ></li>
                <li><span>是否启用:</span>
                    <label ng-class="it.isenabled=='1'?'checked3':''"><input style="display:none" name="isenabled" type="radio"  ng-model="it.isenabled"  ng-value="1" ng-checked="it.isenabled=='1'">是</label>
                    <label ng-class="it.isenabled=='0'?'checked3':''"><input style="display:none" name="isenabled" type="radio"  ng-model="it.isenabled" ng-value="0" ng-checked="it.isenabled=='0'">否 </label>
                </li>
                <li><span>惩罚值:</span><input type="text"  ng-model="it.punishValue" name="punishValue" class="forminput" id="punishValue"/></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;margin-bottom: 20px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancelset()">取消</span>
        </div>
    </form>
</div>
<div class="black"></div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.datalist=[];
        $scope.dataitem={};
        $scope.loadData = function () {
            loading();//加载
            remotecall("basic_priority_load",'',function (data) {
                $scope.datas = data;
                closeLoading();//关闭加载层
                //数据为0时提示
                if(data==null){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败" );
                console.log(data);
            });
            $scope.datalist=[];
            $scope.dataitem={};
        };
        //首次加载菜单
        //先定义，后使用，否则出错误！！！
        $scope.loadData();
        $scope.up= function (tr) {
            $scope.datalist.push(tr);
            $scope.dataitem=$scope.datalist[0];
            if(tr.sort==1)   {parent.pMsg("优先级已经最高了,无需上移");$scope.datalist=[];$scope.dataitem={};}
            else{
                loading();
                remotecall("basic_priority_up",$scope.dataitem,function (data) {
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("上移成功");
                        //重新加载菜单
                        $scope.loadData();
                        $scope.$apply();
                    }else {
                        closeLoading();//关闭加载层
                        parent.pMsg("上移失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("请求失败");
                    console.log(data);
                });
            }
        };
        $scope.down= function (tr) {
            $scope.datalist.push(tr);
            $scope.dataitem=$scope.datalist[0];
            if(tr.sort==$scope.datas.length) {parent.pMsg("优先级已经最低了,无需下移");$scope.datalist=[];$scope.dataitem={};}
            else {
                loading();
                remotecall("basic_priority_down", $scope.dataitem,function (data) {
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("下移成功");
                        //重新加载菜单
                        $scope.loadData();
                        $scope.$apply();
                    }else {
                        closeLoading();//关闭加载层
                        parent.pMsg("下移失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("请求失败");
                    console.log(data);
                });
            };
            }
        $scope.set=function (data) {
            $scope.it=data;
            $('.table-detail,.black').show();
        }
        $scope.cancelset=function () {
            $('.table-detail,.black').hide();
            $('#MenuForm input').text("");
        }
        $("#MenuForm").validate({
            submitHandler:function(form){
                loading();
                remotecall("basic_prioritysort_edit",$scope.it,function (data) {
                    closeLoading();//关闭加载层
                    if(data){
                        parent.pMsg("设置成功");
                        $('.table-detail,.black').hide();
                        $('#MenuForm input').text("");
                        $scope.loadData();
                        $scope.$apply();
                    }else {
                        parent.pMsg("设置失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("数据库请求失败");
                });
            },
            rules:{
                punishValue:{
                    required:true,
                    digits: true,
                    maxlength:10
                }},
               messages:{
                   punishValue:{
                    required:"必填项",
                    maxlength:"惩罚值过大",
                    digits: "只能输入数字"
                }},
            showErrors: function (errorMap, errorList) {
                $.each(errorList, function (i, v) {
                    layer.tips(v.message, v.element, { time: 2000 });
                    return false;
                });
            },
            onfocusout: false
        });
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>