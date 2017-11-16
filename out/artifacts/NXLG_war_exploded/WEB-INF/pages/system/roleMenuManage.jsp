<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-14
  Time: 14:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/zTreeStyle/zTreeStyle.css"/>
    <script src="<%=request.getContextPath()%>/js/jquery.ztree.all.js" type="text/javascript" charset="utf-8"></script>
    <style>
        .table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th{line-height: 2.4em}
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：角色菜单
<hr>
<div class="title">
    <%--<table-btn ng-click="check()"><img src="<%=request.getContextPath()%>/images/details.png" />查看</table-btn>--%>
    <%--<table-btn ng-click="save()"><img src="<%=request.getContextPath()%>/images/tablepass.png" />保存</table-btn>--%>
</div>
<!--表格-->
<div style="width:100%;height:75%;overflow:scroll;border:2px solid #c5add7;">
    <div class="tablebox" style="width:320px;height:73%;top:76px;left:26px;position:fixed;border-right: 3px solid #c5add7;">
        <table class="table" style="border: 0px;border-bottom: 1px solid #c5add7">
            <thead>
            <th>角色名称</th>
            <th></th>
            </thead>
            <tbody>
            <tr ng-repeat="role in roles">
                <td class="thischecked" ng-click="thischecked(role)" style="display: none">
                    <input style="cursor: pointer" type="checkbox" ng-model="role.td0" name="roleIdSelect" value="{{role.roleId}}"/><%--ng-checked="all"--%>
                </td>
                <td ng-bind="role.roleName" style="width: 50%"></td>
                <td> <table-btn ng-click="check(role)">查看</table-btn>
                    <table-btn ng-click="save(role)">保存</table-btn></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="tablebox" style="width:auto;margin-left: 319px;">
        <ul id="tree" class="ztree" style="padding: 66px 26px;"></ul>
    </div>
</div>

</body>
</html>
<script>
    var zNodes=new Array();
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.loadRole = function () {
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("roleManage_loadRole",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                $scope.roles = data.rows;//加载的数据对象，‘roles’根据不同需求而变
                for(i=0;i<$scope.roles.length;i++){
                    $scope.roles[i].td0=false;
                }
                //数据为0时提示
                if(data.total==0){
                    closeLoading();//关闭加载层
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            remotecall("roleAuthority_getmenu",'',function (data) {//加载角色权限菜单
                closeLoading();//关闭加载层
                for(var i=0;i<data.length;i++){
                    zNodes[i]=new Object();
                    zNodes[i].id=data[i].menuId;
                    zNodes[i].pId=data[i].menuParent;
                    zNodes[i].name=data[i].menuName;
                    zNodes[i].open=true;
                    zNodes[i].nocheck=false;
                }
            });
        };
        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                for(i=0;i<$scope.roles.length;i++) {
                    $scope.roles[i].td0 = false;
                }
                tr.td0 = true;
            }else{
                tr.td0 = false;
            }
        };
        //首次加载角色--%>
        $scope.loadRole();
        $scope.checklist={};
        //checked 复选框判断
        var setting={
            showLine:false,
            data:{
                simpleData:{
                    enable:true
                }
            },
            check: {
                enable: true //显示复选框
            },
        };//
        $(document).ready(function () {
            var t = $("#tree");
            t = $.fn.zTree.init(t, setting, zNodes);
            var zTree = $.fn.zTree.getZTreeObj("tree");
        });
        //保存---保存角色的菜单权限
        $scope.save = function (tr) {
            loading();
            var node = new Array();
            var j=0;
            tr.td0 = false;
            $scope.thischecked(tr);
            var roleId =tr.roleId;
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var act=zTree.transformToArray(zTree.getNodes());//树形菜单序列化
            for(var i=0;i<act.length;i++)//获取选中的菜单Id
            {
                if(act[i].checked=== true){
                    node[j] = act[i].id;
                    j++;
                }
            }
            if(node.length=='0'){
                closeLoading();//关闭加载层
                parent.pMsg("保存失败，角色权限不能为空");
            }else{
                remotecallasync("roleAuthority_setmenu", {roleId:roleId,node:node}, function (data) {//保存角色权限
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("保存成功");
                    }else{
                        closeLoading();//关闭加载层
                        parent.pMsg("保存失败");
                    }
                });
            }
        };
        //查看---根据角色id查看角色的菜单权限
        $scope.check = function (tr) {
            loading();
            tr.td0 = false;
            $scope.thischecked(tr);
            var roleId =tr.roleId;
            remotecallasync("roleAuthority_getmenu", {roleId:roleId}, function (data) {//根据角色名称获取权限菜单
                var zTree = $.fn.zTree.getZTreeObj("tree");
                zTree.checkAllNodes(false);
                if(data.length>0){
                    for(var i=0;i<data.length;i++){
                        for(var j=0;j<zNodes.length;j++){
                            if(zNodes[j].id==data[i].menuId){
                                zTree.checkNode(zTree.getNodeByParam("id",zNodes[j].id),true);
                            }
                        }
                        closeLoading();//关闭加载层
                        parent.pMsg("查询成功");
                    }
                }else{
                    zTree.checkAllNodes(false);
                    closeLoading();//关闭加载层
                    parent.pMsg("数据为空");
                }
            });
        };
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>