<%--
  Created by IntelliJ IDEA.
  User: NEUNB_Lisy
  Date: 2017/5/25
  Time: 16:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>

    <style>
        .span_width {
            width: 90px;
        }

        .forminput {
            margin-right: 80px !important;
        }

        .result {
            margin-top: 10px;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：空闲学生查询
<hr>
<div class="search">
    <span class="span_width">周时：</span>
    <select type="text" ng-model="searchStudent.teachweek" name="teachweek" class="forminput" id="teachweek"/>
    <option value="0">--请选择--</option>
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

    <span class="span_width">上课日期：</span>
    <select type="text" ng-model="searchStudent.timeweek" name="timeweek" class="forminput" id="timeweek"/>
    <option value="0">--请选择--</option>
    <option value="1">星期一</option>
    <option value="2">星期二</option>
    <option value="3">星期三</option>
    <option value="4">星期四</option>
    <option value="5">星期五</option>
    <option value="6">星期六</option>
    <option value="7">星期天</option>
    </select>

    <span class="span_width">节次：</span>
    <select type="text" ng-model="searchStudent.timepitch" name="timepitch" class="forminput" id="timepitch"/>
    <option value="0">--请选择--</option>
    <option value="1">第一节</option>
    <option value="2">第二节</option>
    <option value="3">第三节</option>
    <option value="4">第四节</option>
    <option value="5">第五节</option>
    </select>

    <table-btn id="search" ng-click="loadDataFirst()">查询</table-btn>
</div>

<div class="search" style="margin-top: 10px;">

    <span class="span_width">年级：</span>
    <select type="text" ng-model="searchStudent.studentGrade" name="studentGrade" class="forminput" id="studentGrade"
            ng-change="loadClass()">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="grade in grades" value="{{grade.year}}" ng-bind="grade.year"></option>
    </select>

    <span class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;院：</span>
    <select type="text" ng-model="searchStudent.studentCollege" name="studentCollege" class="forminput"
            id=studentCollege"
            ng-change="loadMajor(this)">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="college in colleges" value="{{college.wordbookValue}}"
                ng-bind="college.wordbookValue"></option>
    </select>

    <span class="span_width">专业：</span>
    <select type="text" ng-model="searchStudent.studentMajor" name="studentMajor" class="forminput" id=studentMajor">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="major in majors" value="{{major.majorName}}" ng-bind="major.majorName"></option>
    </select>

    <table-btn style="width: 170px;" ng-click="btnExcel()" class="btnExcel">导出空闲学生信息</table-btn>
    <form id="exportTo" method="post" hidden>
    </form>


</div>
<%--查询结果--%>
<div class="result">
    <table class="table">
        <thead class="checked">
        <th>学生学号</th>
        <th>学生姓名</th>
        <th>手机号</th>
        <th>邮箱号</th>
        <th>入学日期</th>
        <th>年级</th>
        <th>学院</th>
        <th>专业</th>
        <th>辅修</th>
        <th>班级</th>
        <th>培养层次</th>
        <th>学制</th>
        <th>学习形式</th>
        <th>校区</th>
        <th>是否删除</th>
        </thead>
        <tbody ng-repeat="data in datas track by $index">
        <td ng-bind="data.studentNum"></td>
        <td ng-bind="data.studentName"></td>
        <td ng-bind="data.studentPhone"></td>
        <td ng-bind="data.studentEmail"></td>
        <td ng-bind="data.entranceDate"></td>
        <td ng-bind="data.studentGrade"></td>
        <td ng-bind="data.studentCollege"></td>
        <td ng-bind="data.studentMajor"></td>
        <td ng-bind="data.otherMajor"></td>
        <td ng-bind="data.studentClass"></td>
        <td ng-bind="data.studentLevel"></td>
        <td ng-bind="data.studentLength"></td>
        <td ng-bind="data.studentForm"></td>
        <td ng-bind="data.studentSchoolAddress"></td>
        <td ng-bind="data.isDelete"></td>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
</body>
<script>
    var app = angular.module('app', []);
    app.controller('ctrl', function ($scope) {
        var loadCollege = false;
        var loadMajor = false;
        var now = (new Date()).getFullYear();
        $scope.searchStudent = {
            teachweek: "0",
            teachodd: "0",
            timeweek: "0",
            timepitch: "0"
        };
        $scope.grades = [{id: 0, year: now}, {id: 1, year: now - 1}, {id: 2, year: now - 2}, {
            id: 3,
            year: now - 3
        }, {id: 4, year: now - 4}];

        //加载学院
        remotecall("studentManage_loadCollege", '', function (data) {
            $scope.colleges = data;
            loadCollege = true;
        }, function (data) {
            parent.pMsg("加载学院失败,或连接数据库失败！");
            console.log(data);
        });
        //加载专业
        remotecall("studentManage_loadMajor", {}, function (data) {
            $scope.majors = data;
            loadMajor = true;
        }, function (data) {
            parent.pMsg("加载专业失败,或连接数据库失败！");
        });

        //初始化数据
        $scope.init = function () {
            if (loadCollege && loadMajor) {
                $scope.loadData();
            }
        }


        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum = 1;
            $scope.loadData();
        }

        //根据选择的学院加载相应学院下的专业
        $scope.loadMajor = function (obj) {
            loading();
            var majorCollege = $scope.searchStudent.studentCollege;
            remotecall("studentManage_loadMajor", {majorCollege: majorCollege}, function (data) {
                closeLoading();//关闭加载层
                $scope.majors = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载专业失败,或连接数据库失败！");
            });
        };
        //加载空余时间的学生
        $scope.loadData = function () {
            loading();
            if($scope.searchStudent.teachweek != 0){
                if ($scope.searchStudent.teachweek % 2 == 0) {
                    $scope.searchStudent.teachodd = "双周";
                }
                if ($scope.searchStudent.teachweek % 2 == 1) {
                    $scope.searchStudent.teachodd = "单周";
                }
            }
            var teachweek = $scope.searchStudent.teachweek;
            var teachodd = $scope.searchStudent.teachodd;
            var timeweek = $scope.searchStudent.timeweek;
            var timepitch = $scope.searchStudent.timepitch;
            var studentGrade = $scope.searchStudent.studentGrade;
            var studentCollege = $scope.searchStudent.studentCollege;
            var studentMajor = $scope.searchStudent.studentMajor;
            remotecall("checkUnuseStudent", {
                        pageNum: pageNum,
                        pageSize: pageSize,
                        teachweek: teachweek,
                        teachodd: teachodd,
                        timeweek: timeweek,
                        timepitch: timepitch,
                        studentGrade: studentGrade,
                        studentCollege: studentCollege,
                        studentMajor: studentMajor
                    }, function (data) {
                        pageCount = parseInt((data.total - 1) / pageSize) + 1;//页码总数
                        // 分页逻辑开始
                        $scope.allPage = [];
                        $scope.sliPage = [];
                        for (var i = 1; i <= Math.ceil(data.total / pageSize); i++) {
                            $scope.allPage.push(i);
                        }
                        for (var i = 0; i < $scope.allPage.length; i += pageShow) {
                            $scope.sliPage.push($scope.allPage.slice(i, i + pageShow));
                        }
                        $scope.TotalPageCount = $scope.allPage.length;
                        $scope.TotalDataCount = data.total;
                        $scope.pages = $scope.sliPage[Math.ceil(pageNum / pageShow) - 1];
                        $('.paging li').removeClass('sele');
                        if (pageNum % pageShow == 0 && pageNum != 0) {
                            var dx = pageShow - 1;
                        } else {
                            var dx = pageNum % pageShow - 1;
                        }
                        setTimeout(function () {
                            $('.paging li').eq(dx).addClass('sele')
                        }, 100);
                        $scope.datas = data.rows;
                        closeLoading();
                        if (!data.rows.length) {
                            parent.pMsg("该时间学生都在上课");
                            $(".pagingbox").hide();
                        } else {
                            $(".pagingbox").show();
                        }
                    }, function (data) {
                        closeLoading();
                        console.log(data);
                        parent.pMsg("连接数据库失败");
                    }
            );
        };

        //分页
        $scope.gotoPage = function (pn, i) {
            if (pn == -1) {//上一页
                pn = pageNum - 1;
            }
            if (pn == -2) {//下一页
                pn = pageNum + 1;
            }
            if (pn == -3) {//最后一页
                pn = pageCount;
            }
            if (pn < 1 || pn > pageCount) {//页码不正确
                return;
            } else {
                pageNum = pn;//改变当前页
                //重新加载菜单
                $scope.loadData();
            }
        };
        //导出到信息到Excel
        $scope.btnExcel = function () {
            var studentGrade = $scope.searchStudent.studentGrade;
            var studentCollege = $scope.searchStudent.studentCollege;
            var studentMajor = $scope.searchStudent.studentMajor;
            var url = "../../export/exportUnuseStudentInfo.form?teachweek="
                    + $scope.searchStudent.teachweek + "&teachodd="
                    + $scope.searchStudent.teachodd + "&timeweek="
                    + $scope.searchStudent.timeweek + "&timepitch="
                    + $scope.searchStudent.timepitch + "&studentGrade="
                    + $scope.searchStudent.studentGrade + "&studentCollege="
                    + $scope.searchStudent.studentCollege + "&studentMajor="
                    + $scope.searchStudent.studentMajor;
            $("#exportTo").attr("action", url);
            $("#exportTo").submit();
        }
        //默认加载全部
        $scope.init();
    });
</script>
</html>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>
