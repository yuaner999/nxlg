<%--
  Created by IntelliJ IDEA.
  User: NEUNB_Lisy
  Date: 2017/5/19
  Time: 15:56
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>

    <%--打印课表的js插件--%>
    <script src="<%=request.getContextPath()%>/js/explore_tabexcle/jquery-migrate-1.2.1.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/explore_tabexcle/jquery.jqprint-0.3.js"></script>

    <style>
        .findArgmCour{
            margin-top: 10px;
        }
        .findArgmCour .table{
            margin-top: 5px;
        }
        .forminput{
            margin-right:20px !important;
        }
        #info .table caption{
            color: #5c307d;
            margin-top: -10px;
            margin-bottom: 5px;
            margin-left: 20px;
            font-size: 18px;
        }
        #info {
            border: 1px solid #c5add7;
            margin-top: 31px;
            padding: 24px;
            position: relative;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：学生课表
<hr>
<%--课表--%>
<span>选择周时：</span>
<select type="text" ng-model="thweek.thweekday" name="loadStuArgmCour" class="forminput" id="thweel">
    <option value="0">整学期</option>
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
<table-btn style="width: 100px;margin-left: 20px;" ng-click="loadStuArgmCour()">查看课表</table-btn>
<table-btn style="width: 100px;margin-left: 20px;" ng-click="btnExcel()" class="btnExcel">导出课表</table-btn>
<%--<table-btn style="width: 100px;margin-left: 20px;" onclick="exploretable()">打印课表</table-btn>--%>
<form id="exportTo" method="post" hidden>
</form>
<div class="findArgmCour" id="findArgmCourTable">
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
<div class="tablebox" id="info" style="display: none">
    <table class="table">
        <caption>课程调整</caption>
        <thead>
        <thead>
        <th>类别</th>
        <th>课程名</th>
        <th>所分班级</th>
        <th>调整|停课周</th>
        <th>原上课时间</th>
        <th>原授课教师</th>
        <th>调整到周</th>
        <th>调整|停课时间</th>
        <th>调整教师</th>
        <th>调整教室</th>
        <th>调整日期</th>
        </thead>
        <tbody>
        <tr ng-repeat="log in logs">
            <td ng-bind="log.type"></td>
            <td ng-bind="log.chineseName"></td>
            <td ng-bind="log.class"></td>
            <td ng-bind="log.odd_teachweek"></td>
            <td ng-if="log.type=='停课'">停课</td>
            <td  ng-if="log.type=='调课'" ng-bind="'星期'+log.odd_week+' 第'+log.odd_pitch+'节'"></td>
            <td ng-bind="log.odd_teachName"></td>
            <td ng-if="log.type=='停课'">停课</td>
            <td ng-if="log.type=='调课'" ng-bind="log.now_teachweek"></td>
            <td ng-bind="'星期'+log.now_timeweek+' 第'+log.now_timepitch+'节'"></td>
            <td ng-if="log.type=='调课'" ng-bind="log.teacherName"></td>
            <td ng-if="log.type=='调课'" ng-bind="log.classroomName"></td>
            <td ng-if="log.type=='停课'">停课</td>
            <td ng-if="log.type=='停课'">停课</td>
            <td ng-bind="log.settime"></td>
        </tr>
    </table>
</div>
</body>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //查询学生课表
        $scope.scheduleByRooms=[];//存储得到的课表数据
        $scope.thweek={
            name:"",
            thweekday:"0",
            teachodd:"无"
        };//设置周时

        //加载课表信息
        $scope.loadStuArgmCour=function () {
            loading();//加载
            if ($scope.thweek.thweekday!=0){
                if ($scope.thweek.thweekday%2==0){
                    $scope.thweek.teachodd="双周";
                }else {
                    $scope.thweek.teachodd="单周";
                }
            }
            remotecallasync("StuArgmCour_load",$scope.thweek,function (data) {
                $scope.scheduleByRooms=null;
                closeLoading();
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("您暂无课程安排");
                    $(".btnExcel").hide();
                    $scope.$apply();
                }else{
                    $scope.scheduleByRooms = data.rows;//加载的数据对象，‘courses’根据不同需求而变
                    $scope.thweek.name=data.rows[0].studentName;
                    $scope.$apply();
                    $(".btnExcel").show();
                    //导出到课程信息到Excel
                    $scope.btnExcel=function () {
                        remotecallasync("StuArgmCour_getUserId",'',function (data) {
                            if(data){
                                var url="../../export/exportStuArgmCour.form?userid="+data+"&thweekday="+$scope.thweek.thweekday+"&teachodd="+$scope.thweek.teachodd+"&name="+$scope.thweek.name;
                                $("#exportTo").attr("action",url);
                                $("#exportTo").submit();
                            }
                        });
                    }
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        }
        $scope.showlog=function () {
            loading();//加载
            remotecallasync("stu_argmchange_load",'',function (data) {
                closeLoading();//关闭加载层
                if(data.total>0){
                    $("#info").show();
                     $scope.logs=data.row;
                    $scope.$apply();
                }else{
                    $("#info").hide();
                }
            },function(data){
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        }
        $scope.showlog();
        //初始化
        $scope.loadStuArgmCour();
    });

    //绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchkey").click();
        }
    });

    var exploretable=function () {
        $("#findArgmCourTable").jqprint();
    }

</script>
</html>
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
