<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/20
  Time: 14:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <style>
        .table-show .row {
            padding: 10px 0;
        }

        .table-show .bttn {
            margin-left: 25%;
            border: 1px solid #c5add7;
            height: 26px;
            background: #edeaf1;
        }

        .table-show ul {
            width: 30%;
            float: left;
        }

        .table-show li {
            margin: 10px -10px;
            display: inline-flex;
        }

        .table-show li span {
            width: 200px;
            display: inline-block;
        }

        .table-show li > span:first-child, .newword {
            color: #5c307d;
            font-family: "微软雅黑";
            margin-right: -90px;
        }

        .first span {
            font-size: 17px;
            color: red;
        }

        .title .tablesearchbtn {
            width: 220px;
            margin-left: 0px;
        }

        .show ul {
            width: 25%;
            padding-left: 40px;
            margin-left: 35px;
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

        .show li > span:first-child {
            color: #5c307d;
            font-family: "微软雅黑";
        }

        #selectcourse .table caption {
            color: #5c307d;
            margin-top: -10px;
            margin-bottom: 5px;
            margin-left: 20px;
            font-size: 18px;
        }

        .forminput {
            width: 200px;
        }

        .queryinput {
            border: 1px solid #c5add7;
            margin-right: 10px;
            height: 26px;
            width: 158px;
            padding: 0 5px;
        }

        .title .tablesearchbtn {
            width: 210px;
            margin-left: 0px;
            margin-right: 10px;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：查看学生所选课程
<hr>
<div class="title">
    <span ng-show="show=='1'" class="span_width">年级：</span>
    <select ng-show="show=='1'" type="text" ng-model="studentsGrade" name="studentsGrade" class="queryinput" id="studentsGrade"
            ng-change="loadStudentClass()">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="grade in grades" value="{{grade.wordbookValue}}">{{grade.wordbookValue}}</option>
    </select>

    <span ng-show="show=='1'" class="span_width">班级：</span>
    <select ng-show="show=='1'" type="text" ng-model="studentClass" name="studentsClass" class="queryinput"
            id="studentsClass">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="class in studentsClass" value="{{class.className}}"
                ng-bind="class.className"></option>
    </select>

    <span ng-show="show=='1'" class="span_width">学院：</span>
    <select ng-show="show=='1'" type="text" ng-model="studentsCollege" name="studentsCollege" class="queryinput" id=studentsCollege"
            ng-change="loadStudentMajor(this)">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="college in studentsColleges" value="{{college.wordbookValue}}"
                ng-bind="college.wordbookValue"></option>
    </select>

    <%--<input type="text" />--%>
</div>
<div class="title">
    <span ng-show="show=='1'" class="span_width">专业：</span>
    <select ng-show="show=='1'" type="text" ng-model="studentsMajor" name="studentsMajor" class="queryinput" id=studentsMajor">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="major in studentsMajors" value="{{major.majorName}}" ng-bind="major.majorName"></option>
    </select>
    <input ng-show="show=='1'" class="tablesearchbtn" type="text" ng-model="studentNum" placeholder="请输入学号"/>
    <input ng-show="show=='1'" class="tablesearchbtn" type="text" ng-model="studentName" placeholder="请输入学生姓名"/>
    <table-btn ng-show="show=='1'" id="search" ng-click="loadDataFirst()">搜索</table-btn>
    <%--<input ng-show="show=='1'" class="tablesearchbtn" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>--%>
    <%--<table-btn ng-if="show=='1'" id="search" ng-click="loadData()">搜索</table-btn>--%>
    <%--<span ng-if="show=='2'" class="span_width">选择学期：</span>--%>
    <select ng-model="Semesteritem.acId" ng-if="show=='2'" name="acid" class="forminput" id="acid">
        <option value="0" selected="selected">请选择学期(默认当前学期)</option>
        <option ng-repeat="semester in semesters" value="{{semester.acId}}">{{semester.semester}}</option>
    </select>
    <table-btn style="margin-left: 10px;" ng-if="show=='2'" id="search" ng-click="detail()">搜索</table-btn>
    <table-btn ng-if="show=='2'" class="top" ng-click="previous()">返回</table-btn>
</div>
<%--学生列表--%>
<div class="tablebox" ng-if="show=='1'" id="student">
    <table class="table">
        <thead>
        <th>学号</th>
        <th>姓名</th>
        <th>年级</th>
        <th>学院</th>
        <th>专业</th>
        <th>辅修</th>
        <th>班级</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="student in students">
            <td ng-bind="student.studentNum"></td>
            <td ng-bind="student.studentName"></td>
            <td ng-bind="student.studentGrade"></td>
            <td ng-bind="student.studentCollege"></td>
            <td ng-bind="student.studentMajor"></td>
            <td ng-bind="student.otherMajor"></td>
            <td ng-bind="student.studentClass"></td>
            <td>
                <table-btn ng-click="detail(student)">查看</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
<%--学生选课情况--%>
<div class="tablebox" ng-if="show=='2'" id="s_course">
    <table class="table">
        <thead>
        <th>学号</th>
        <th>姓名</th>
        <th>课程代码</th>
        <th>课程名</th>
        <th>平台</th>
        <th>所在班级</th>
        <th>教师</th>
        <th>学期</th>
        <th>状态</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td ng-bind="data.studentNum"></td>
            <td ng-bind="data.studentName"></td>
            <td ng-bind="data.courseCode"></td>
            <td ng-bind="data.chineseName"></td>
            <td ng-bind="data.terraceName"></td>
            <td ng-bind="data.class"></td>
            <td ng-bind="data.teacherName"></td>
            <td ng-bind="data.term"></td>
            <td ng-bind="data.scc_status"></td>
        </tr>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>

</body>
</html>
<script>
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        $scope.show = 1;
        $scope.theStu = {};
        $scope.Semesteritem = {
            "acId": "0",
        };
        $scope.pageNow = 0;//记录查看学生页面的页码数量
        $scope.isCheckd = false;//记录是否查看了学生的选课信息
        $scope.void = function () {
            $scope.datalist = [];
            $scope.dataitem = {};
            $scope.terlist = [];
            $scope.teritem = {};
            $scope.checklist = [];
            $scope.checkitem = {};
        }

        var loadCoMaGrInfo = false;
        var loadCollege = false;
        var loadMajor = false;
        var loadClass = false;
        //加载年级
        remotecall("teacher_loadCoMaGrInfo", {}, function (data) {
            $scope.grades = data.grade;
            loadCoMaGrInfo = true;
        }, function (data) {
        });
        //加载学院
        remotecall("studentManage_loadCollege", '', function (data) {
            $scope.studentsColleges = data;
            loadCollege = true;
        }, function (data) {
            parent.pMsg("加载学院失败,或连接数据库失败！");
            console.log(data);
        });
        //加载专业
        remotecall("studentManage_loadMajor", {}, function (data) {
            $scope.studentsMajors = data;
            loadMajor = true;
        }, function (data) {
            parent.pMsg("加载专业失败,或连接数据库失败！");
        });
        //加载班级
        remotecall("studentManage_loadClass", {}, function (data) {
            $scope.studentsClass = data;
            loadClass = true;
        }, function (data) {
            parent.pMsg("加载班级失败,或连接数据库失败！");
        });

        //根据选择的专业加载相应学院下的班级
        $scope.loadStudentClass = function () {
            loading();

            var grade = $scope.studentsGrade;
            if (!grade) {
                closeLoading();//关闭加载层
            } else {
                remotecall("studentManage_loadClass", {gradeName: grade}, function (data) {
                    closeLoading();//关闭加载层
                    $scope.studentsClass = data;
                }, function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("加载班级失败,或连接数据库失败！");
                    console.log(data);
                });
            }
        };

        //根据选择的学院加载相应学院下的专业
        $scope.loadStudentMajor = function (obj) {
            loading();
            var majorCollege = $scope.studentsCollege;
            remotecall("studentManage_loadMajor", {majorCollege: majorCollege}, function (data) {
                closeLoading();//关闭加载层
                $scope.studentsMajors = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载专业失败,或连接数据库失败！");
                console.log(data);
            });
        };

        //初始化页面
        $scope.init = function () {
            if (loadCoMaGrInfo && loadCollege && loadMajor && loadClass) {
                $scope.loadData();
            }
        }

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadData();
        }

        //加载学生信息
        $scope.loadData = function () {
            $(".pagingbox").show();
            $scope.show = 1;
            if ($scope.isCheckd) {
                pageNum = $scope.pageNow;
            }
            if (pageNum == 0) {
                pageNum = 1;
            }
            loading();//加载
            remotecall("studentManage_loadStudent", {
                pageNum: pageNum,
                pageSize: pageSize,
                studentNum: $scope.studentNum,
                studentName: $scope.studentName,
                studentCollege: $scope.studentsCollege,
                studentMajor: $scope.studentsMajor,
                studentClass: $scope.studentClass,
                studentGrade: $scope.studentsGrade
            }, function (data) {
                closeLoading();
                $scope.students = data.rows;//加载的数据对象，‘students’根据不同需求而变
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
                closeLoading();
                parent.pMsg("加载数据失败");
            });
            $scope.void();
        };
        //checked 复选框判断
        $scope.init();
        //查看学生课程
        $scope.detail = function (tr) {
            $scope.isCheckd = true;
            if (tr) {
                $scope.getSemester();
                $scope.theStu = tr;
            }
            $scope.void();
            $scope.item = {};//定义一个中间变量，保存当前查看谁的选修
            if ($scope.show == 1) {
                $scope.show = 2;
                $scope.gotoPage(1, 0);
            }
            $scope.datalist.push(tr);
            $scope.dataitem = $scope.datalist[0];
            $scope.item = $scope.dataitem;
            var theSemesterId;
            if ($scope.Semesteritem.acId == 0) {
                for (var i = 0; i < $scope.semesters.length; i++) {
                    if ($scope.semesters[i].is_now) {
                        theSemesterId = $scope.semesters[i].acId;
                    }
                }
            } else {
                theSemesterId = $scope.Semesteritem.acId;
            }
            var studentId = $scope.theStu.studentId;
            remotecall("queryAdjustCourse_load", {
                pageNum: pageNum,
                pageSize: pageSize,
                theSemesterId: theSemesterId,
                studentId: studentId
            }, function (data) {
                closeLoading();

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

                if (data.rows.length > 0) {
                    $scope.datas = data.rows;
                    for (var i = 0; i < $scope.datas.length; i++) {
                        if ($scope.datas[i].scc_status == null) {
                            $scope.datas[i].scc_status = "未申请退课";
                        }
                    }
                } else {
                    $scope.datas = [];
                    parent.pMsg("该学生无选修课程");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
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
                //重新加载用户信息
                if ($scope.show == 1) {
                    $scope.loadData();
                    $scope.pageNow = pn;
                } else if ($scope.show == 2) {
                    $scope.detail();
                }
            }
        };

        //加载学期
        $scope.getSemester = function () {
            remotecall("querySemester_load", {}, function (data) {
                if (data.length) {
                    $scope.semesters = data;
                    /*for (var i=0;i<data.length;i++){
                     if (data[i].is_now){
                     $scope.Semester=data[i];
                     }
                     }*/
                } else {
                    parent.pMsg("暂无学期");
                }
            }, function (data) {
                parent.pMsg("加载失败");
            });
        }
        //返回按钮
        $scope.previous = function () {
            $scope.loadData();
            $scope.isCheckd = false;
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>