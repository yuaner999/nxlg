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
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/tree.css"/>
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<%--<table-nav>--%>
<%--<li class="sele">专业管理</li>--%>
<%--<li>课程管理</li>--%>
<%--<li>培养计划</li>--%>
<%--</table-nav>--%>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" />新建</table-btn>
    <table-btn ng-click="delete()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />删除</table-btn>
    <table-btn ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>
    <input class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入角色名称" />
    <table-btn id="searchkey" ng-click="search()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <%--死的table  最上面的标题--%>
    <table class="table">
        <thead>
            <th>专业详情</th>
            <th>查看已修学分</th>
            <th>查看学生学分</th>
            <th>查看培养计划</th>
            <th>学业分析报告</th>
            <th>选修</th>
            <th>辅修</th>
        </thead>
    </table>
        <%--活的table  repeat循环的--%>
    <table class="table table-menu">
        <%--活的table的标题   点击下拉出详情--%>
        <thead>
            <th class="table-menu-btn">
                <b></b>
                <span>专业详情</span>
            </th>
            <th>查看已修学分</th>
            <th>查看学生学分</th>
            <th>查看培养计划</th>
            <th>学业分析报告</th>
            <th>选修</th>
            <th>辅修</th>
        </thead>
        <%--隐藏的内容列表  点击上面的thead才显示这里i--%>
        <tbody>
            <tr>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
            </tr>
            <tr>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
            </tr>
        </tbody>
    </table>
    <%--活的table  repeat循环的--%>
    <table class="table table-menu">
        <%--活的table的标题   点击下拉出详情--%>
        <thead>
            <th class="table-menu-btn">
                <b></b>
                <span>专业详情</span>
            </th>
            <th>查看已修学分</th>
            <th>查看学生学分</th>
            <th>查看培养计划</th>
            <th>学业分析报告</th>
            <th>选修</th>
            <th>辅修</th>
        </thead>
        <%--隐藏的内容列表  点击上面的thead才显示这里i--%>
        <tbody>
            <tr>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
            </tr>
            <tr>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
                <td>课程列表</td>
            </tr>
        </tbody>
    </table>
</div>
<!--分页 此页不需要-->
<div class="pagingbox">
    <paging></paging>
</div>
<!--新建表单-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <form id="RoleForm">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li style="display: none;"><span>ID：</span><input type="text" name="roleId" class="forminput" /></li>
                <li><span>角色名称：</span><input type="text" ng-model="checkitem.roleName" name="roleName" class="forminput" id="roleName"/></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
</body>
</html>
<script>
    var add_edit=true;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {

    });
    //dom  事件
    $(function () {
        $('.table-menu-btn b').click(function () {
            if($(this).hasClass('close2')){
                $(this).removeClass('close2');
                $(this).parent().parent().parent().next('tbody').slideUp(0);
            }else{
                $(this).addClass('close2');
                $(this).parent().parent().parent().next('tbody').slideDown(0);
            }
        });
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>