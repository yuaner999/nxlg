<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-15
  Time: 11:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>

    <%--打印课表的js插件--%>
    <script src="<%=request.getContextPath()%>/js/explore_tabexcle/jquery-migrate-1.2.1.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/explore_tabexcle/jquery.jqprint-0.3.js"></script>

    <style>
       .crlist{
       }
        .tealist{
            display: none;
        }
        .findArgmCour{
            display: none;
            margin-top: 5px;
        }
        .claroobtn{
            display: none;
        }
        .techroobtn{
            display: none;
        }
       .span_width{
           width: 90px;
       }
       .forminput{
           margin-right:20px !important;
       }
        input.tablesearchbtn{
            margin-left: 0px !important;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：查看排课课表
<hr>
<div style="display: none"><input id="search"></div><%--用来清除搜索信息--%>
<table-nav>
    <li ng-click="dofilter(1)" class="sele">教室列表</li>
    <li ng-click="dofilter(2)" >教师列表</li>
</table-nav>

<%--教室列表--%>
<div class="crlist a-show">
    <div class="title search">
        <input class="tablesearchbtn" type="text" placeholder="按教室名称进行查询..." onkeyup="getSearchStr(this)"/>
        <table-btn id="searchkey" ng-click="loadUsingClassRoom()">搜索</table-btn>
        <form class="top_1" method="post" hidden></form>
    </div>
    <div class="tablebox">
        <table class="table">
            <thead>
            <th>校区</th>
            <th>教学楼</th>
            <th>楼层</th>
            <th>教室号</th>
            <th>教室名称</th>
            <th>教室类型</th>
            <th>教室容量</th>
            <th>教室面积</th>
            <th>使用状态</th>
            <th>使用面积</th>
            <th>操作</th>
            </thead>
            <tbody>
            <tr ng-repeat="UsingClassRoom in UsingClassRooms">
                <td ng-bind="UsingClassRoom.campus"></td>
                <td ng-bind="UsingClassRoom.building"></td>
                <td ng-bind="UsingClassRoom.floor"></td>
                <td ng-bind="UsingClassRoom.classroomNum"></td>
                <td ng-bind="UsingClassRoom.classroomName"></td>
                <td ng-bind="UsingClassRoom.classroomType"></td>
                <td ng-bind="UsingClassRoom.classroomCapacity"></td>
                <td ng-bind="UsingClassRoom.classroomArea"></td>
                <td ng-bind="UsingClassRoom.classroomStatus"></td>
                <td ng-bind="UsingClassRoom.classroomUnit"></td>
                <td><table-btn ng-click="chkByCrSet(UsingClassRoom)">查看课表</table-btn></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<%--教师列表--%>
<div class="tealist">
    <div class="title search">
        <input class="tablesearchbtn" type="text" placeholder="按教工工号进行查询..." onkeyup="getSearchStr2(this)"/>
        <table-btn id="searchkey2" ng-click="loadTeacher()">搜索</table-btn>
        <form class="top_1" method="post" hidden></form>
    </div>
    <div class="tablebox">
        <table class="table">
            <thead>
            <th>工号</th>
            <th>教师姓名</th>
            <th>性别</th>
            <th>民族</th>
            <th>政治面貌</th>
            <th>操作</th>
            </thead>
            <tbody>
            <tr ng-repeat="teacher in teachers">
                <td ng-bind="teacher.teacherNumber"></td>
                <td ng-bind="teacher.teacherName"></td>
                <td ng-bind="teacher.teacherGender"></td>
                <td ng-bind="teacher.nation"></td>
                <td ng-bind="teacher.politics"></td>
                <td><table-btn ng-click="chkByTeSet(teacher)">查看课表</table-btn></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
<div class="claroobtn" >
    <span>选择周时：</span>
    <select type="text" ng-model="thweek.thweekday" name="loadStuArgmCour" class="forminput" id="loadStuArgmCour1">
        <option value="0" selected>整学期</option>
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
    <table-btn style="width: 100px;" ng-click="chkByCr()">查看课表</table-btn>
    <table-btn style="width: 100px;margin-left: 20px;" ng-click="btnExcelCr()" class="btnExcel">导出课表</table-btn>
    <%--<table-btn style="width: 100px;margin-left: 20px;" onclick="exploretable()">打印课表</table-btn>--%>
</div>
<div class="techroobtn" >
    <span>选择周时：</span>
    <select type="text" ng-model="thweek.thweekday" name="loadStuArgmCour" class="forminput" id="loadStuArgmCour2">
        <option value="0" selected>整学期</option>
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
    <table-btn style="width: 100px;" ng-click="chkByTe()">查看课表</table-btn>
    <table-btn style="width: 100px;margin-left: 20px;" ng-click="btnExcelTh()" class="btnExcel">导出课表</table-btn>
    <%--<table-btn style="width: 100px;margin-left: 20px;" onclick="exploretable()">打印课表</table-btn>--%>
</div>
<form id="exportTo" method="post" hidden>
</form>
<div id="findArgmCourTable" class="findArgmCour">
    <table class="table" >
        <thead>
        <th colspan="2">时间</th>
        <th>星期一</th>
        <th>星期二</th>
        <th>星期三</th>
        <th>星期四</th>
        <th>星期五</th>
        <th>星期六</th>
        <th>星期天</th>
        </thead>
        <tbody>
        <tr>
            <td rowspan="2">上午</td>
            <td>第一大节</td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="1">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="1">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="2">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="1">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="3">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="1">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="4">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="1">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="5">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="1">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="6">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="1">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="7">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="1">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
        </tr>
        <tr style="border-top: 2px solid #c5add7;">
            <td>第二大节</td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="1">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="2">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="2">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="2">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="3">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="2">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="4">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="2">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="5">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="2">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="6">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="2">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="7">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="2">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
        </tr>
        <tr  style="border-top: 2px solid #c5add7;">
            <td rowspan="2">下午</td>
            <td>第三大节</td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="1">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="3">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="2">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="3">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="3">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="3">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="4">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="3">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="5">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="3">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="6">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="3">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="7">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="3">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
        </tr>
        <tr  style="border-top: 2px solid #c5add7;">
            <td>第四大节</td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="1">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="4">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="2">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="4">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="3">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="4">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="4">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="4">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="5">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="4">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="6">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="4">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="7">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="4">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
        </tr>
        <tr  style="border-top: 2px solid #c5add7;">
            <td>晚上</td>
            <td>第五大节</td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="1">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="5">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="2">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="5">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="3">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="5">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="4">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="5">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="5">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="5">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="6">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="5">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
            <td>
                    <span ng-repeat="scheduleByRoom in scheduleByRooms" ng-switch="scheduleByRoom.al_timeweek">
                        <span ng-switch-when="7">
                            <span ng-switch="scheduleByRoom.al_timepitch">
                                <span ng-switch-when="5">
                                    {{scheduleByRoom.chineseName}}<br>
                                    {{scheduleByRoom.teacherName}}<br>
                                    {{scheduleByRoom.classroomName}}<br>
                                    {{scheduleByRoom.tc_class}}<br>
                                    {{scheduleByRoom.tc_thweek_start}}至{{scheduleByRoom.tc_thweek_end}}周({{scheduleByRoom.tc_teachodd}})<br>
                                </span>
                            </span>
                        </span>
                    </span>
            </td>
        </tr>
        </tbody>
    </table>
</div>

</body>
</html>
<script>
    var oldClassroomPageNum=1;
    var oldTeacherPageNum=1;
    var app = angular.module('app',[]);
    app.controller('ctrl',function  ($scope) {

        $scope.thweek={
            name:"",
            thweekday:"0",
            teachodd:"无"
        };//设置周时

        //判断分页
        $scope.show=1;

        //搜索框内容
        $scope.input={};

        $scope.chkByCrtr={};

        //加载教室列表
        $scope.loadUsingClassRoom = function () {
            loading();//加载
            remotecall("basic_classroom_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                closeLoading();
                if(data.rows.length>0){
                    $scope.thweek.name=data.rows[0].classroomName;
                }
                $scope.UsingClassRooms = data.rows;
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

                for(i=0;i<$scope.UsingClassRooms.length;i++){
                    $scope.UsingClassRooms[i].td0=false;
                }
                num=0;
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无可用教室");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("加载数据失败" );
                console.log(data);
            });
            remotecall("basic_classroom_loadwordbook_campus",'',function (data) {
                $scope.options_campus = data;
            },function (data) {
                parent.pMsg("加载校区失败");
                console.log(data);
            });
            remotecall("basic_classroom_loadwordbook_building",'',function (data) {
                $scope.options_building = data;
            },function (data) {
                parent.pMsg("加载教学楼失败");
                console.log(data);
            });
            remotecall("basic_classroom_loadwordbook_classroomtype",'',function (data) {
                $scope.options_classroomtype = data;
                closeLoading();//关闭加载层
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载教室类型失败");
                console.log(data);
            });
            $scope.datalist=[];
            $scope.dataitem={};
        };

        //加载教师列表
        $scope.loadTeacher = function () {
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("teacherManage_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr2},function (data) {
                closeLoading();//关闭加载层
                $scope.teachers = data.rows;//加载的数据对象，‘teachers’根据不同需求而变
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

                $scope.all = false;
                for(i=0;i<$scope.teachers.length;i++){
                    $scope.teachers[i].td0=false;
                }
                //数据为0时提示
                if(data.total==0){
                    closeLoading();//关闭加载层
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            $scope.checklist=[];
            $scope.checkitem={};
        };

        //顶部教师和教室切换
        $scope.dofilter=function (tr) {
            $(".pagingbox").show();
//            $scope.gotoPage(1);
//            $scope.input.keyword=null;
//            getSearchStr("#searchkey");
            if(tr==1){
                oldTeacherPageNum=pageNum;
                pageNum=oldClassroomPageNum;
                $(".tealist").removeClass("a-show");
                $(".tealist").addClass("a-hide");
                $(".tealist").hide();
                $(".findArgmCour").removeClass("a-show");
                $(".findArgmCour").addClass("a-hide");
                $(".findArgmCour").hide();
                $(".crlist").removeClass("a-hide");
                $(".crlist").addClass("a-show");
                $(".crlist").show();
                $(".search").show();
                $(".techroobtn").removeClass("a-show");
                $(".techroobtn").addClass("a-hide");
                $(".techroobtn").hide();
                $(".claroobtn").removeClass("a-show");
                $(".claroobtn").addClass("a-hide");
                $(".claroobtn").hide();
                $scope.thweek={
                    name:"",
                    thweekday:"0",
                    teachodd:"无"
                };//设置周时
                $scope.chkByCrtr={};
                $scope.scheduleByRooms=[];
                $scope.loadUsingClassRoom();
                $scope.show=1;
            }else if(tr=2){
                oldClassroomPageNum=pageNum;
                pageNum=oldTeacherPageNum;
                $(".crlist").removeClass("a-show");
                $(".crlist").addClass("a-hide");
                $(".crlist").hide();
                $(".findArgmCour").removeClass("a-show");
                $(".findArgmCour").addClass("a-hide");
                $(".findArgmCour").hide();
                $(".tealist").removeClass("a-hide");
                $(".tealist").addClass("a-show");
                $(".tealist").show();
                $(".search").show();
                $(".techroobtn").removeClass("a-show");
                $(".techroobtn").addClass("a-hide");
                $(".techroobtn").hide();
                $(".claroobtn").removeClass("a-show");
                $(".claroobtn").addClass("a-hide");
                $(".claroobtn").hide();
                $scope.thweek={
                    name:"",
                    thweekday:"0",
                    teachodd:"无"
                };//设置周时
                $scope.chkByCrtr={};
                $scope.scheduleByRooms=[];
                $scope.loadTeacher();
                $scope.show=2;
            }

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
                if($scope.show==1){
                    $scope.loadUsingClassRoom();
                }else if($scope.show==2){
                    $scope.loadTeacher();
                }
            }
        };

        //查看教室课程表设置好教室id
        $scope.chkByCrSet=function (tr) {
            $(".crlist").removeClass("a-show");
            $(".crlist").addClass("a-hide");
            $(".crlist").hide();
            $(".search").hide();
            $(".findArgmCour").removeClass("a-hide");
            $(".findArgmCour").addClass("a-show");
            $(".findArgmCour").show();
            $(".claroobtn").removeClass("a-hide");
            $(".claroobtn").addClass("a-show");
            $(".claroobtn").show();
            $(".techroobtn").removeClass("a-show");
            $(".techroobtn").addClass("a-hide");
            $(".techroobtn").hide();
            $scope.chkByCrtr=Object.assign(tr,$scope.thweek);//将教室id值与周时合并
            $scope.chkByCr();
        }

        //根据教室查看课程表
        $scope.chkByCr=function () {
            $(".pagingbox").hide();
            loading();
            if ($scope.thweek.thweekday!=0){
                if ($scope.thweek.thweekday%2==0){
                    $scope.thweek.teachodd="双周";
                }else {
                    $scope.thweek.teachodd="单周";
                }
            }
            $scope.chkByCrtr=Object.assign($scope.chkByCrtr,$scope.thweek);//将教室id值与周时合并
            remotecall("finArgmByCroom_query",$scope.chkByCrtr,function (data) {
                closeLoading();//关闭加载层
                $scope.scheduleByRooms = data.rows;//加载的数据对象，‘courses’根据不同需求而变
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("该教室暂无课程安排");
                    $(".btnExcel").hide();
                }else{
                    $(".btnExcel").show();
                    $scope.btnExcelCr=function () {
                        var url="../../export/exportArgmCourseByCr.form?id="+$scope.scheduleByRooms[0].classroomId+"&thweekday="+$scope.thweek.thweekday+"&teachodd="+$scope.thweek.teachodd+"&name="+$scope.chkByCrtr.classroomName;
                        $("#exportTo").attr("action",url);
                        $("#exportTo").submit();
                    }
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
        }

        //查看教师课程表设置好教师ID
        $scope.chkByTeSet=function (tr) {
            $(".tealist").removeClass("a-show");
            $(".tealist").addClass("a-hide");
            $(".tealist").hide();
            $(".search").hide();
            $(".findArgmCour").removeClass("a-hide");
            $(".findArgmCour").addClass("a-show");
            $(".findArgmCour").show();
            $(".techroobtn").removeClass("a-hide");
            $(".techroobtn").addClass("a-show");
            $(".techroobtn").show();
            $(".claroobtn").removeClass("a-show");
            $(".claroobtn").addClass("a-hide");
            $(".claroobtn").hide();
            $scope.chkByCrtr=Object.assign(tr,$scope.thweek);//将id值与周时合并
            $scope.chkByTe();
        }

        //根据教师查看课程表
        $scope.chkByTe=function () {
            $(".pagingbox").hide();
            loading();//加载
            if ($scope.thweek.thweekday!=0){
                if ($scope.thweek.thweekday%2==0){
                    $scope.thweek.teachodd="双周";
                }else {
                    $scope.thweek.teachodd="单周";
                }
            }
            $scope.chkByCrtr=Object.assign($scope.chkByCrtr,$scope.thweek);//将id值与周时合并
            remotecall("finArgmByTeacher_query",$scope.chkByCrtr,function (data) {
                closeLoading();//关闭加载层
                $scope.scheduleByRooms = data.rows;//加载的数据对象，‘courses’根据不同需求而变
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("该教师暂无课程安排");
                    $(".btnExcel").hide();
                }else {
                    $scope.thweek.name=$scope.scheduleByRooms[0].teacherName;
                    $(".btnExcel").show();
                    //根据教师导出excle课表
                    $scope.btnExcelTh=function () {
                        var url="../../export/exportArgmCourseByTh.form?tcid="+$scope.scheduleByRooms[0].teacherId+"&thweekday="+$scope.thweek.thweekday+"&teachodd="+$scope.thweek.teachodd+"&name="+$scope.thweek.name;
                        $("#exportTo").attr("action",url);
                        $("#exportTo").submit();
                    }
                }

            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
        }
        
        //初始化时加载信息
        $scope.loadUsingClassRoom();

    });

    //绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchkey").click();
            $("#searchkey2").click();
        }
    });

    //浏览器打印
   var exploretable=function () {
       $("#findArgmCourTable").jqprint();
   }

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>