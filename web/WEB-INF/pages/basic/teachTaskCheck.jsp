<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/27
  Time: 8:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
    <style>
        .table-majorshow {
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

        .black {
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

        .showTitle {
            position: absolute;
            top: 0;
            line-height: 70px;
            left: 2%;
            color: #5c307d;
            font-weight: bold;
        }

        .myTextarea {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：培养计划审核
<hr>

<!--筛选条件按钮组-->
<div class="title">

    <span class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;院：</span>
    <select type="text" ng-model="collegeName" name="collegeName" class="forminput"
            id="collegeName">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="college in colleges" value="{{college.wordbookValue}}"
                ng-bind="college.wordbookValue"></option>
    </select>

    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--培养计划列表-->
<div class="tablebox" id="allInfo">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th>学院</th>
        <th>已通过</th>
        <th>待审核</th>
        <th>未通过</th>
        <th style="width: 160px;"></th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-bind="Info.majorCollege"></td>
            <td ng-bind="Info.hascount"></td>
            <td ng-bind="Info.checkcount"></td>
            <td ng-bind="Info.uncheckcount"></td>
            <td>
                <table-btn ng-click="showDetail(Info)">查看详情</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>

<div class="black"></div>
<%--查看详情--%>

</body>
</html>
<script>

    var filter = 1;
    var add_edit = true;
    var now = (new Date()).getFullYear();
    var _copy_college_information = "";
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        $scope.Var = false;
        $scope.show = 2;
        $scope.teacher = false;
        $scope.checklist = [];
        $scope.checkitem = {};
        //加载学院
        remotecall("studentManage_loadCollege", '', function (data) {
            $scope.colleges = data;
            loadCollege = true;
        }, function (data) {
            parent.pMsg("加载学院失败,或连接数据库失败！");
        });

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum = 1;
            $scope.loadData();
        }

        //加载数据
        $scope.loadData = function () {
            $scope.show = 2;
            $scope.checklist = [];
            $scope.checkitem = {};
            $("#allInfo,.title,.pagingbox,.table-nav").show();
            $("#course,.table-addform,#insert-form").hide();
            if (!$scope.Var) {
                $(".table-nav li:first").addClass("sele");
                $(".table-nav li:last").removeClass("sele");
            } else {
                $(".table-nav li:last").addClass("sele");
                $(".table-nav li:first").removeClass("sele");
            }
            var collegeName=$scope.collegeName;
            loading();//加载
            remotecallasync("educateTaskCheck_load_count", {
                filter: filter,
                pageNum: pageNum,
                pageSize: pageSize,
                college: collegeName
            }, function (data) {
                closeLoading();
                if (data.result == false) {
                    showmsgpc(data.errormessage);
                    return;
                }
                $scope.allInfo = data.rows;
                console.log(data.rows)
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
                $scope.$apply();

                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
                console.log(data);
            });

            remotecall("isteacher", '', function (data) {
                closeLoading();//关闭加载层
                if (data == "管理员") {
                    $scope.teacher = true;
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("暂无数据");
            });

        }
        $scope.loadData();

        //右侧菜单栏
        $scope.showDetail = function (Info) {
            location.href = 'teachTaskCheckCollege.form?college=' + encodeURI(Info.majorCollege);
        }
        //右侧菜单栏
        $scope.dofilter = function (str) {
            pageNum = 1;
            if (str == 0) {//审核列表
                $scope.Var = true;
            } else if (str == 1) {
                $scope.Var = false;
            }
            filter = str;
            $scope.loadData();
        }
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
                $scope.loadData();

            }
        }

        //导入
        $scope.insert = function () {
            $('#insert-form,.black').show();
        }
        $scope.close = function () {
            $('#insert-form,.black').hide();
            $("#valid_result,#file").empty();

        }

        //关闭加载层
        $scope.close = function () {
            $(".pagingbox").show();
            $(".black").hide();
            $scope.majorshow = false;
        }


    });
    function getSearchStr2(obj) {
        pageNum = 1;
        searchStr = $(obj).val();
    }
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchCourse").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>