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
        .table-show {
            position: relative;
            top: 0;
            left: 0 !important;
        }

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
            margin-left: 5px;
        }

        <%--查看详情--%>
        .table-courseshow {
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

        .bttn {
            margin-left: 26%;
            margin-top: 30px;
            border: 1px solid #c5add7;
            height: 26px;
            background: #edeaf1;
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

        #selectcourse {
            height: 400px;
            border: 1px solid #c5add7;
            margin-top: 31px;
            padding: 24px;
            overflow-y: scroll;
            position: relative;
            /* scrollbar-base-color: #c5add7;
             scrollbar-shadow-color: #fff;*/
        }

        #selectcourse .table caption {
            color: #5c307d;
            margin-top: -10px;
            margin-bottom: 5px;
            margin-left: 20px;
            font-size: 18px;
        }

        .btn-selectcourse {
            position: absolute;
            right: 26px;
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
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：手动调整选课
<hr>

<div class="title">
    <span ng-show="show=='1'" class="span_width">年级：</span>
    <select ng-show="show=='1'" type="text" ng-model="studentsGrade" name="studentsGrade" class="queryinput" id="studentsGrade"
            ng-change="loadStudentClass()">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="grade in grades" value="{{grade.wordbookValue}}">{{grade.wordbookValue}}</option>
    </select>

    <span ng-show="show=='1'" class="span_width">班级：</span>
    <select ng-show="show=='1'" type="text" ng-model="studentclass" name="studentsClass" class="queryinput"
            id="studentsClass">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="class in studentsClass" value="{{class.className}}"
                ng-bind="class.className"></option>
    </select>

    <span ng-show="show=='1'" class="span_width">学院：</span>
    <select  ng-show="show=='1'" type="text" ng-model="studentsCollege" name="studentsCollege" class="queryinput" id=studentsCollege"
            ng-change="loadStudentMajor(this)">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="college in studentsColleges" value="{{college.wordbookValue}}"
                ng-bind="college.wordbookValue"></option>
    </select>

    <span ng-show="show=='1'" class="span_width">专业：</span>
    <select ng-show="show=='1'" type="text" ng-model="studentsMajor" name="studentsMajor" class="queryinput" id=studentsMajor">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="major in studentsMajors" value="{{major.majorName}}" ng-bind="major.majorName"></option>
    </select>
    <%--<input type="text" />--%>
</div>

<div class="title">
    <input ng-show="show=='1'" class="tablesearchbtn" type="text" ng-model="studentsNum" placeholder="请输入学号"/>
    <input ng-show="show=='1'" class="tablesearchbtn" type="text" ng-model="studentsName" placeholder="请输入学生姓名"/>
    <%--<input ng-show="show=='1'" class="tablesearchbtn" type="text" placeholder="请输入想要搜索的内容"--%>
           <%--onkeyup="getSearchStr(this)"/>--%>
    <table-btn ng-if="show=='1'" id="search" ng-click="loadDataFirst()">搜索</table-btn>
    <table-btn ng-if="show=='2'" class="top" ng-click="previous()">返回</table-btn>
    <table-btn ng-if="show=='2'" class="top" ng-click="firstloadMajor()">选修</table-btn>
    <table-btn ng-if="show=='3'" class="top" ng-click="previous1()">返回</table-btn>
    <table-btn ng-if="show=='5'" class="top" ng-click="previous5()">返回</table-btn>
    <div ng-show="show=='4'">
        <table-btn class="top" ng-click="previous2()">返回</table-btn>
        <span>教师： <input class="tablesearchbtn" type="text" placeholder="输入教师姓名" id="keytname"/></span>
        <span>教室： <input class="tablesearchbtn" type="text" placeholder="输入教室" id="keyroom"/></span>
        <span>承担单位： <input class="tablesearchbtn" type="text" placeholder="输入承担单位" id="keyunit"/></span>
        <span>上课时间： <span>第 </span><input class="tablesearchbtn" type="text" id="keytime" style="width:60px"/>周</span>
        <table-btn ng-click="loadCoursefirst()">搜索</table-btn>
        <span>本次选课选修的总学分：<span style="color: #FF1F06" ng-bind="totalthisfenshu"></span>分</span>
        <span>总计选修的总学分：<span style="color: #FF1F06" ng-bind="totalfenshu"></span>分</span>
    </div>
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
<%--学生选课--%>
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
        <th>当前学期</th>
        <th></th>
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
            <td>
                <table-btn ng-click="withdraw(data)">退选</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<div class="tablebox" id="major" ng-if="show=='5'">
    <table class="table">
        <thead>
        <th>院(系)/部</th>
        <th>专业名称</th>
        <th>所属学科</th>
        <th>培养层次</th>
        <th>学制</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="major in majors">
            <td ng-bind="major.majorCollege"></td>
            <td ng-bind="major.majorName"></td>
            <td ng-bind="major.subject"></td>
            <td ng-bind="major.level"></td>
            <td ng-bind="major.length"></td>
            <td>
                <table-btn ng-click="loadTerrace(major)">选择</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
<%--平台--%>
<div class="tablebox" ng-if="show=='3'" id="terrace">
    <table class="table">
        <thead>
        <th>序号</th>
        <th>平台名称</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="terrace in terraces">
            <td ng-bind="$index+1"></td>
            <td ng-bind="terrace.terraceName"></td>
            <td>
                <table-btn ng-click="loadCoursefirst(terrace)">选择</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<%--专业平台课程--%>
<div class="tablebox" ng-if="show=='4'" id="course">
    <table class="table">
        <thead>
        <th hidden>terraceId</th>
        <th>课程代码</th>
        <th>中文名称</th>
        <th>承担单位</th>
        <th>专业</th>
        <th>课程类别</th>
        <th>所在班级</th>
        <th>任课教师</th>
        <th>人数范围</th>
        <th>总学分</th>
        <th>总学时</th>
        <th>上课周</th>
        <th>时间/地点</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="course in courses">
            <td ng-bind="course.terraceId" hidden></td>
            <td ng-bind="course.courseCode"></td>
            <td ng-bind="course.chineseName"></td>
            <td ng-bind="course.assumeUnit"></td>
            <td ng-bind="course.majorName"></td>
            <td ng-bind="search(course.tcm_grade,course.majorName,course.courseId,course.terraceId)"></td>
            <td ng-bind="course.tc_class"></td>
            <td ng-bind="course.teacherName"></td>
            <td ng-bind="course.tc_numrange"></td>
            <td ng-bind="course.totalCredit"></td>
            <td ng-bind="course.totalTime"></td>
            <td ng-bind="'第'+course.tc_thweek_start+'至'+course.tc_thweek_end+'周|'+course.tc_teachodd"></td>
            <td>
                <b ng-repeat="weektime in course.times">
                    <span ng-bind="'星期'+weektime.al_timeweek"></span>
                    <b ng-repeat="jieshu in weektime.jie">
                        <span ng-bind="'第'+jieshu.al_timepitch+'节|地点'+jieshu.classroomName"></span>
                    </b>
                    <br/>
                </b>
            </td>
            <td>
                <table-btn ng-click="showCourse(course)">查看详情</table-btn>
                <b style="margin-right: 10px"></b>
                <table-btn ng-click="chooseCourse(course)">选修</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
<div class="black"></div>
<div class="table-courseshow">
    <img style="float: right; position:absolute; top:15px;right:15px"
         src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <ul>
            <li><span>教师信息</span></li>
            <li><span>教师姓名</span><span ng-bind="course.teacherName">计算机院</span></li>
            <li><span>任教单位：</span><span ng-bind="course.teachUnit">10</span></li>
            <li><span>学历：</span><span ng-bind="course.education">1001</span></li>
            <li><span>专业技术职务：</span><span ng-bind="course.duty">0110</span></li>
            <li><span>专业技术职务等级：</span><span ng-bind="course.dutyLevel">技术</span></li>
        </ul>
        <ul>
            <li><span>教材信息</span></li>
            <li><span>教材名称：</span><span ng-bind="course.name">工</span></li>
            <li><span>出版社：</span><span ng-bind="course.press">本</span></li>
            <li><span>版次：</span><span ng-bind="course.edition">4</span></li>
            <li><span>书号：</span><span ng-bind="course.booknumber">2000</span></li>
            <li><span>价格：</span><span ng-bind="course.price">启</span></li>
        </ul>
        <ul>
            <li><span>课程信息</span></li>
            <li><span>课程类别三：</span><span ng-bind="course.courseCategory_3">工</span></li>
            <li><span>课程类别四：</span><span ng-bind="course.courseCategory_4">本</span></li>
            <li><span>课程类别五：</span><span ng-bind="course.courseCategory_5">4</span></li>
            <li><span>授课方式：</span><span ng-bind="course.tc_teachway">2000</span></li>
            <li><span>是否有先行课程：</span><span ng-bind="course.tc_teachmore">启</span></li>
        </ul>
    </div>
</div>
</body>
</html>
<script>
    var oldMajorPageNum = 1;
    var oldPageNum = 1;
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        $scope.show = 1;
        var keytname = "", keyroom = "", keyunit = "", keytime = "", terraceId = "", studentGrade = "", studentGrade = "", studentMajor = "", otherMajor = "";
        $scope.void = function () {
            $scope.majorlist = [];
            $scope.majoritem = {};
            $scope.datalist = [];
            $scope.dataitem = {};
            $scope.checklist = [];
            $scope.checkitem = {};
            $scope.teritem = {};
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
            $scope.show = 1;
//            console.log("第一个="+pageCount);
            loading();//加载
            remotecallasync("studentManage_loadStudent", {
                pageNum: pageNum,
                pageSize: pageSize,
                studentNum: $scope.studentsNum,
                studentName: $scope.studentsName,
                studentCollege: $scope.studentsCollege,
                studentMajor: $scope.studentsMajor,
                studentClass: $scope.studentclass,
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
                $scope.$apply();
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
        $scope.loadData();
        //查看学生课程
        $scope.detail = function (tr) {

            $scope.void();
            $scope.item = {};//定义一个中间变量，保存当前查看谁的选修
            $scope.show = 2;
            $scope.datalist.push(tr);
            $scope.dataitem = $scope.datalist[0];
            $scope.item = $scope.dataitem;//查看XX学生的选课
            loading();
            remotecall("manualAdjustCourse_load", $scope.dataitem, function (data) {
                closeLoading();
                //console.log(data.length);
                if (data.length > 0) {
                    $scope.datas = data;
                } else {
                    $scope.datas = [];
                    parent.pMsg("该学生无选修课程");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
        }
        //选修
        $scope.load = function () {
            loading();//加载
            remotecall("manualAdjustCourse_creditshave", {studentId: $scope.dataitem.studentId}, function (data) {
                closeLoading();//关闭加载层
                if (data.length > 0) {
                    $scope.totalfenshu = data[0].totalfenshu;
                    if (data[0].totalfenshu == null) {
                        $scope.totalfenshu = 0;
                    }
                } else {
                    $scope.totalfenshu = 0;
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载失败");
            });
            loading();//加载
            remotecall("manualAdjustCourse_creditsthishave", {studentId: $scope.dataitem.studentId}, function (data) {
                closeLoading();//关闭加载层
                if (data.length > 0) {
                    $scope.totalthisfenshu = data[0].totalthisfenshu;
                    if (data[0].totalthisfenshu == null) {
                        $scope.totalthisfenshu = 0;
                    }
                } else {
                    $scope.totalthisfenshu = 0;
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载失败");
            });
        }
        //加载专业
        $scope.firstloadMajor = function () {
            oldPageNum = pageNum;
            pageNum = 1;
            $scope.loadMajor();
        }
        $scope.loadMajor = function () {
            $scope.show = 5;
            $(".pagingbox").show();
            loading();//加载
            remotecall("basic_majorlist_load", {pageNum: pageNum, pageSize: pageSize}, function (data) {
                closeLoading();//关闭加载层
                if (data.result == false) {
                    showmsgpc(data.errormessage);
                    return;
                }
                $scope.majors = data.rows;
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
        $scope.loadTerrace = function (tr) {
            $scope.majorlist = [];
            $scope.majoritem = {};
            $scope.majorlist.push(tr);
            $scope.majoritem = $scope.majorlist[0];
            $scope.show = 3;
            loading();
            remotecall("terraceManage_loading", "", function (data) {
                closeLoading();//关闭加载层
                $scope.terraces = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        //课程的类别是必修还是选修
        $scope.search = function (tcm_grade, majorName, courseId, terraceId) {
            loading();
            var courseCategory_1 = '';
            var t = remotecall("teacher_courseCategory_1_load", {
                ep_grade: tcm_grade,
                ep_major: majorName,
                courseId: courseId,
                terraceId: terraceId
            }, function (data) {
                closeLoading();//关闭加载层
                if (data.total > 0) {
                    courseCategory_1 = data.rows[0].courseCategory_1;
                } else {
                    courseCategory_1 = '';
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载失败");
            });
            return courseCategory_1;
        }
        //查看详情
        $scope.showCourse = function (course) {
            $scope.course = course;
            $('.table-courseshow,.black').show();
        }
        //关闭详情
        $scope.close = function () {
            $('.table-courseshow,.black').hide();
        }
        //选择平台,加载课程
        $scope.loadCoursefirst = function (terrace) {
            oldMajorPageNum = pageNum;
            pageNum = 1;
            $scope.loadCourse(terrace);
        }
        $scope.loadCourse = function (terrace) {
            $scope.load();
            $scope.checklist.push(terrace);
            $scope.checkitem = $scope.checklist[0];
            $scope.teritem = {};
            $scope.teritem = $scope.checkitem;
            $scope.show = 4;
            $scope.Var = false;
            keytname = $("#keytname").val();
            keyroom = $("#keyroom").val();
            keyunit = $("#keyunit").val();
            keytime = $("#keytime").val();
            terraceId = $scope.checkitem.terraceId;
            studentGrade = $scope.dataitem.studentGrade;
            majorId = $scope.majoritem.majorId;
            loading();//加载

            remotecall("manualAdjustCourse_loadcourse", {
                majorId: majorId,
                studentGrade: studentGrade,
                terraceId: terraceId,
                pageNum: pageNum,
                pageSize: pageSize,
                keytname: keytname,
                keyroom: keyroom,
                keyunit: keyunit,
                keytime: keytime
            }, function (data) {
                closeLoading();//关闭加载层
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
                // $scope.$apply();
                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        //选课
        $scope.chooseCourse = function (course) {
            parent.pConfirm("确认为该生选择该课程吗？", function () {
                $scope.checklist = [];
                $scope.checkitem = {};
                $scope.checklist.push(course);
                $scope.checkitem = $scope.checklist[0];
                $scope.checkitem.studentId = $scope.dataitem.studentId;
                $scope.checkitem.studentNum = $scope.dataitem.studentNum;
                loading();
                remotecall("manualAdjustCourse_addcourse", $scope.checkitem, function (data) {
                    closeLoading();
                    if (data.result == 0) {
                        $scope.load();
                        if (data.errormessage == '' || data.errormessage == null) {
                            parent.pMsg("选课成功")
                        } else {
                            parent.pMsg("选课成功,该课程先行课为：" + data.errormessage)
                        }
                        $scope.detail($scope.dataitem);
                        $scope.$apply();
                    } else if (data.result == 1) {
                        parent.pMsg(data.errormessage);
                    } else if (data.result == 4) {
                        parent.pMsg("选课请求失败");
                    }
                }, function (data) {
                    closeLoading();
                    parent.pMsg("选课请求失败");
                });
            }, function () {
            });
        }
        $scope.withdraw = function (tr) {
            var scc = tr.scc;
            parent.pConfirm("确认退选该课程吗？", function () {
                loading();
                remotecall("manualAdjustCourse_del", {scc: scc}, function (data) {
                    closeLoading();//关闭加载层
                    if (data) {
                        parent.pMsg("退选成功");
                        $scope.detail($scope.dataitem);
                        $scope.$apply();
                    } else {
                        parent.pMsg("退选失败");
                    }
                }, function (data) {
                    parent.pMsg("退选请求失败");
                    closeLoading();//关闭加载层
                });
            }, function () {
            });
        }
        $scope.previous = function () {
//            pageNum=1;
            $scope.loadData();
        }
        $scope.previous1 = function () {
//            pageNum=1;
            pageNum = oldMajorPageNum;
            $scope.loadMajor();
            //$scope.loadData();
        }
        $scope.previous2 = function () {
            $scope.loadTerrace($scope.majoritem);
        }
        $scope.previous5 = function () {
//            pageNum=1;
            pageNum = oldPageNum;
            $scope.detail($scope.item);
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
                //重新加载用户信息
                if ($scope.show == 1) {
                    $scope.loadData();
                } else if ($scope.show == 5) {
                    $scope.loadMajor();
                } else {
                    $scope.loadCourse($scope.teritem);
                }
            }
        };
    });
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#search").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>