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
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
</head>
<style>
    <%--查看详情--%>
    .table-score {
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

    .scorecol {
        margin-left: 10px;
    }

    .scorecol li {
        margin-bottom: 5px;
    }

    .scorecol li span {
        margin-right: 5px;
        width: 230px;
        display: inline-block;
    }

    .bttn {
        margin-left: 26%;
        margin-top: 30px;
        border: 1px solid #c5add7;
        height: 26px;
        background: #edeaf1;
    }

    .show ul {
        width: 30%;
        padding-left: 40px;
        margin-left: 100px;
        float: left;
    }

    .show li {
        margin: 10px 60px;
        display: inline-flex;
    }

    .show li span {
        min-width: 105px;
        display: inline-block;
        margin-right: 20px;
    }

    .show li > span:first-child, .tips li > span:first-child {
        color: #5c307d;
        font-family: "微软雅黑";
    }

    .black {
        position: fixed;
        top: 0;
        left: 0;
        height: 100%;
        width: 100%;
        background: #000;
        opacity: 0.5;
        filter: alpha(opacity=0.5);
        z-index: 9;
        display: none;
    }

    .tips ul {
        float: left;
        margin: 20px 0px 10px 30px;
    }

    .sel {
        margin-left: -5px;
    }

    .title .tablesearchbtn {
        margin-left: 0px;
        margin-right: 12px;
        width: 150px;
        vertical-align: middle;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：学生结课成绩
<hr>
<!--导航筛选-->
<table-nav class="table-nav" ng-show="show=='2'">
    <li ng-click="dofilter(0)" class="sele">待审核</li>
    <li ng-click="dofilter(1)">通过</li>
    <li ng-click="dofilter(2)">不通过</li>
</table-nav>
<div class="title">
    <table-btn ng-if="show=='1'" ng-click="previous1()">返回</table-btn>
    <table-btn ng-show="show=='2'" ng-click="previous2()">返回</table-btn>
    <table-btn ng-if="show=='2'&& filter=='0'" class="top" ng-click="pass()"><img
            src="<%=request.getContextPath()%>/images/tablepass.png"/>通过
    </table-btn>
    <table-btn ng-if="show=='2'&& filter=='0'" class="top" ng-click="nopass()"><img
            src="<%=request.getContextPath()%>/images/tablereject.png"/>不通过
    </table-btn>
    <span ng-show="show=='0'" class="span_width">课程代码：</span>
    <input ng-show="show=='0'" class="tablesearchbtn" type="text" ng-model="courseCode" placeholder="请输入关键字查询..."
           onkeyup="getSearchStr(this)"/>
    <span ng-show="show=='0'" class="span_width">课程名称：</span>
    <input ng-show="show=='0'" class="tablesearchbtn" type="text" ng-model="chineseName" placeholder="请输入关键字查询..."
           onkeyup="getSearchStr(this)"/>
    <table-btn ng-if="show=='0'" id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<div class="tablebox" ng-if="show=='0'">
    <table class="table">
        <thead>
        <th>课程代码</th>
        <th>课程名称</th>
        <th>承担单位</th>
        <th>负责教师</th>
        <th>总学分</th>
        <th>总学时</th>
        <th>课程学期</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="course in courses">
            <td ng-bind="course.courseCode"></td>
            <td ng-bind="course.chineseName"></td>
            <td ng-bind="course.assumeUnit"></td>
            <td ng-bind="course.teacherName"></td>
            <td ng-bind="course.totalCredit"></td>
            <td ng-bind="course.totalTime"></td>
            <td ng-bind="course.mtc_courseTerm"></td>
            <td>
                <table-btn ng-click="choosecourse(course)">选择</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<!--专业列表-->
<div class="tablebox" id="class" ng-if="show=='1'">
    <table class="table">
        <thead>
        <th>课程名</th>
        <th>所分班级</th>
        <th>班级教师</th>
        <th>负责教师</th>
        <th>授课方式</th>
        <th>学期</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="class in classes">
            <td ng-bind="class.chineseName"></td>
            <td ng-bind="class.tc_class"></td>
            <td ng-bind="class.ateacherName"></td>
            <td ng-bind="class.bteacherName"></td>
            <td ng-bind="class.tc_teachway"></td>
            <td ng-bind="class.tc_semester"></td>
            <td>
                <table-btn ng-click="chooseclass(class)">选择</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<%--平台列表--%>
<div class="tablebox" id="stu" ng-show="show=='2'">
    <table class="table">
        <thead>
        <th class="checked" ng-show="filter=='0'">
            <button><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></button>
        </th>
        <th>学号</th>
        <th>学生姓名</th>
        <th>专业</th>
        <th>状态</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="stu in stus">
            <td class="thischecked" ng-click="thischecked(stu)" ng-show="filter=='0'">
                <input type="checkbox" ng-model="stu.td0" name="scc" value="{{stu.scc}}"/>
            </td>
            <td ng-bind="stu.studentNum"></td>
            <td ng-bind="stu.studentName"></td>
            <td ng-bind="stu.studentMajor"></td>
            <td ng-bind="stu.pass"></td>
            <td>
                <table-btn ng-click="pass1(stu)" ng-show="filter=='0'||filter=='2'">通过</table-btn>
                &nbsp;&nbsp;
                <table-btn ng-click="nopass1(stu)" ng-show="filter=='0'||filter=='1'">不通过</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<div class="black"></div>
<div class="pagingbox">
    <paging></paging>
</div>
</body>
</html>
<script>
    var add_edit = true;
    var num = 0;
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        $scope.filter = 0;
        $scope.show = 0;
        $scope.courselist = [];
        $scope.courseitem = {};
        $scope.classlist = [];
        $scope.classitem = {};
        $scope.stulist = [];
        $scope.stuitem = {};
        $scope.all = false;

        $scope.loadDataFirst = function () {
            pageNum = 1;
            $scope.loadData();
        }
        //加载课程
        $scope.loadData = function () {
            $scope.show = 0;
            loading();//加载
            remotecall("teacher_Course_load", {
                pageNum: pageNum,
                pageSize: pageSize,
                courseCode: $scope.courseCode,
                chineseName: $scope.chineseName
            }, function (data) {
                closeLoading();//关闭加载层
                if (data.result == false) {
                    showmsgpc(data.errormessage);
                    return;
                }
                $scope.courses = data.rows;
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

                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        }
        $scope.loadData();
        //加载班级
        $scope.choosecourse = function (course) {
            $scope.show = 1;
            $scope.courselist.push(course);
            $scope.courseitem = $scope.courselist[0];
            loading();//加载
            remotecall("teacher_Course_classList", {
                courseId: $scope.courseitem.courseId,
                pageNum: pageNum,
                pageSize: pageSize
            }, function (data) {
                closeLoading();//关闭加载层
                if (data.result == false) {
                    showmsgpc(data.errormessage);
                    return;
                }
                $scope.classes = data.rows;
                //$scope.$apply();
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

                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        //加载学生
        $scope.chooseclass = function (tr) {
            $scope.show = 2;
            $scope.classlist.push(tr);
            $scope.classitem = $scope.classlist[0];
            loading();//加载
            remotecall("teacher_Courseclass_stuList", {
                pageNum: pageNum,
                pageSize: pageSize,
                filter: $scope.filter,
                tc_id: $scope.classitem.tc_id
            }, function (data) {
                closeLoading();//关闭加载层
                $scope.stus = data.rows;
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

                $scope.all = false;
                for (i = 0; i < $scope.stus.length; i++) {
                    $scope.stus[i].td0 = false;
                }
                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        //右侧菜单栏
        $scope.dofilter = function (str) {
            $scope.filter = str;
            $scope.chooseclass();
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
                if ($scope.show == '0') {
                    pageNum = pn;
                    $scope.loadData();
                } else if ($scope.show == '1') {
                    pageNum = pn;
                    $scope.choosecourse();
                } else {
                    pageNum = pn;
                    $scope.chooseclass();
                }
            }
        };
        //返回上一级
        $scope.previous1 = function () {
            pageNum = 1;
            $scope.loadData();
            $scope.courselist = [];
            $scope.courseitem = {};
        }
        $scope.previous2 = function () {
            pageNum = 1;
            $scope.filter = 0;
            $(".table-nav li").removeClass('sele');
            $(".table-nav li").first().addClass("sele");
            $scope.classlist = [];
            $scope.classitem = {};
            $scope.choosecourse();
        }
        //通过功能
        $scope.pass = function () {
            var checknum = $scope.stulist.length;
            if (checknum < 1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else {
                parent.pConfirm("确认通过选中的学生成绩吗？", function () {
                    loading;
                    remotecall("teacher_stuscore_pass", {stulist: $scope.stulist}, function (data) {
                        closeLoading();//关闭加载层
                        if (data) {
                            parent.pMsg("操作成功");
                            $scope.chooseclass();
                            $scope.$apply();
                        } else {
                            parent.pMsg("操作失败");
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("审核请求失败");
                        console.log(data);
                    });
                }, function () {
                });
            }
        };
        //拒绝
        $scope.nopass = function () {
            var checknum = $scope.stulist.length;
            if (checknum != 1) {
                parent.pMsg("只能选择一条记录");
                return;
            }
            else {
                parent.pConfirm("确认不通过选中的学生成绩吗？", function () {
                    loading;
                    remotecall("teacher_stuscore_nopass", {stulist: $scope.stulist}, function (data) {
                        closeLoading();//关闭加载层
                        if (data) {
                            parent.pMsg("操作成功");
                            $scope.chooseclass();
                            $scope.$apply();
                        } else {
                            parent.pMsg("操作失败");
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("审核请求失败");
                        console.log(data);
                    });
                }, function () {
                });
            }
        }
        $scope.pass1 = function (stu) {
            parent.pConfirm("确认通过选中的学生成绩吗？", function () {
                loading;
                remotecall("teacher_stuscore_pass1", stu, function (data) {
                    closeLoading();//关闭加载层
                    if (data) {
                        parent.pMsg("操作成功");
                        $scope.chooseclass();
                        $scope.$apply();
                    } else {
                        parent.pMsg("操作失败");
                    }
                }, function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("审核请求失败");
                    console.log(data);
                });
            }, function () {
            });
        }
        //拒绝
        $scope.nopass1 = function (stu) {
            parent.pConfirm("确认不通过选中的学生成绩吗？", function () {
                loading;
                remotecall("teacher_stuscore_nopass1", stu, function (data) {
                    closeLoading();//关闭加载层
                    if (data) {
                        parent.pMsg("操作成功");
                        $scope.chooseclass();
                        $scope.$apply();
                    } else {
                        parent.pMsg("操作失败");
                    }
                }, function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("审核请求失败");
                    console.log(data);
                });
            }, function () {
            });
        }
        $scope.allfn = function () {
            if ($scope.all == false) {
                for (i = 0; i < $scope.stus.length; i++) {
                    $scope.stus[i].td0 = false;
                }
                $scope.stulist = [];
                num = 0;
            } else {
                $scope.stulist = [];
                for (i = 0; i < $scope.stus.length; i++) {
                    $scope.stus[i].td0 = true;
                    $scope.stulist.push($scope.stus[i]);
                }
                num = $scope.stus.length;
            }
        };
        $scope.thischecked = function (tr) {
            if (tr.td0 == false || tr.td0 == null) {
                num++;
                tr.td0 = true;
                $scope.stulist.push(tr);
            } else {
                num--;
                tr.td0 = false;
                $scope.all = false;
                var index = $scope.stulist.indexOf(tr);
                if (index > -1) {
                    $scope.stulist.splice(index, 1);
                }
            }
            if (num == $scope.stus.length) {
                $scope.all = true;
            } else {
                $scope.all = false;
            }
        };
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>