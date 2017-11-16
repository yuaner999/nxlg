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
    <script src="<%=request.getContextPath()%>/js/font/jedate/jquery.jedate.min.js" type="text/javascript"
            charset="utf-8"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/js/font/jedate/skin/jedate.css"/>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
    <style>
        .span_width {
            width: 90px;
        }

        .row {
            padding-left: 252px !important;
        }

        .forminput {
            margin-right: 80px !important;
        }

        .text-center {
            position: absolute;
            left: 33%;
        }

        .photo {
            position: absolute;
            left: 50px;
            top: 100px;
        }

        .btn {
            position: absolute;
            top: 185px;
            left: 45px;
            color: #f2f2f2;
            background: #c5add7;
        }

        /*人造下拉*/
        .listbox {
            position: relative;
            display: inline-block;
        }

        .listbox .after {
            content: '';
            position: absolute;
            right: 3px;
            height: 0;
            top: 11px;
            transform: scaleX(.5);
            -webkit-transform: scaleX(.5);
            -moz-transform: scaleX(.5);
            -ms-transform: scaleX(.5);
            width: 0;
            border: 6px solid transparent;
            border-top-color: rgb(51, 51, 51);
            cursor: pointer;
            z-index: 33;
        }

        .list {
            position: absolute;
            top: 26px;
            left: 0;
            width: 100%;
            background: #fff;
            border: 1px solid rgb(30, 144, 255);

        }

        .list div {
            cursor: pointer;
            padding: 0 5px;
        }

        .list div:hover {
            background: rgb(30, 144, 255);
            color: #fff;
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
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：学生管理
<hr>
<div class="title">
    <span class="span_width">年级：</span>
    <select type="text" ng-model="studentsGrade" name="studentsGrade" class="queryinput" id="studentsGrade"
            ng-change="loadStudentClass()">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="grade in grades" value="{{grade.wordbookValue}}">{{grade.wordbookValue}}</option>
    </select>

    <span class="span_width">班级：</span>
    <select type="text" ng-model="studentClass" name="studentsClass" class="queryinput"
            id="studentsClass">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="class in studentsClass" value="{{class.className}}"
                ng-bind="class.className"></option>
    </select>

    <span class="span_width">学院：</span>
    <select type="text" ng-model="studentsCollege" name="studentsCollege" class="queryinput" id=studentsCollege"
            ng-change="loadStudentMajor(this)">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="college in studentsColleges" value="{{college.wordbookValue}}"
                ng-bind="college.wordbookValue"></option>
    </select>

    <span class="span_width">专业：</span>
    <select type="text" ng-model="studentsMajor" name="studentsMajor" class="queryinput" id=studentsMajor">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="major in studentsMajors" value="{{major.majorName}}" ng-bind="major.majorName"></option>
    </select>
    <%--<input type="text" />--%>
</div>

<div class="title">
    <input class="tablesearchbtn" type="text" ng-model="studentNum" placeholder="请输入学号"/>
    <input class="tablesearchbtn" type="text" ng-model="studentName" placeholder="请输入学生姓名"/>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
    <table-btn ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png"/>新建</table-btn>
    <table-btn ng-click="delete()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png"/>批量删除</table-btn>
    <table-btn ng-click="insert()"><img src="<%=request.getContextPath()%>/images/icon_import.png"/>导入学生信息</table-btn>
    <table-btn ng-click="getModel()"><img src="<%=request.getContextPath()%>/images/icon_download.jpg"/>下载模板</table-btn>
</div>

<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/>
        </th>
        <th>学号</th>
        <th>姓名</th>
        <th>性别</th>
        <th>出生日期</th>
        <th>民族</th>
        <th>联系方式</th>
        <th>学院</th>
        <th>专业</th>
        <th>年级</th>
        <th>班级</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="student in students">
            <td class="thischecked" ng-click="thischecked(student)">
                <input type="checkbox" id="kind" ng-model="student.td0" name="studentIdSelect"
                       value="{{student.studentId}}"/>
            </td>
            <td ng-bind="student.studentNum"></td>
            <td ng-bind="student.studentName"></td>
            <td ng-bind="student.studentGender"></td>
            <td ng-bind="student.studentBirthday"></td>
            <td ng-bind="student.studentNation"></td>
            <td ng-bind="student.studentPhone"></td>
            <td ng-bind="student.studentCollege"></td>
            <td ng-bind="student.studentMajor"></td>
            <td ng-bind="student.studentGrade"></td>
            <td ng-bind="student.studentClass"></td>
            <td>
                <table-btn ng-click="edit(student)">修改</table-btn>
                <b style="margin-right: 10px"></b>
                <table-btn ng-click="del(student)">删除</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<!--分页-->
<div class="pagingbox">
    <paging></paging>
</div>
<!--导入学生信息-->
<div id="insert-form" title="批量导入"
     style="display:none;width:400px;height:410px;padding:10px;position:absolute;border:3px #c5add7 solid; left:35%;top:15%;background-color:#ffffff">
    <div id="file_box" style="margin-bottom: 10px;margin-top: 10px;">
        <label>选择文件:</label>
        <input id="upfile" style="display: inline-block;width: 200px;" name="fileup" type="file"/>
        <img style="float: right; position:absolute; top:15px;right:15px"
             src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    </div>
    <div id="btn_box" style="margin-bottom: 10px;margin-top: 10px;">
        <a href="javascript:void(0)" ng-click="validFile()">验证文件</a>&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="javascript:void(0)" ng-click="uploadFile()">上传并导入</a>
    </div>
    <div id="result_box" style="margin-bottom: 10px;margin-top: 10px;">
        <label>操作结果:</label>
        <br>
        <div id="valid_result"
             style="display: inline-block;width: 375px;height: 235px;border: 2px solid #c5add7;overflow: auto"></div>
    </div>
    <p style="color:#ff0000;">（导入学生信息时请选用给定的模板）</p>
    <%--批量导入对话框的按钮--%>
    <div>
        <a href="javascript:void(0)" style="margin-left: 340px; color: white;background: #c5add7;"
           ng-click="close()">关闭</a>
    </div>
</div>
<!--新建表单-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：学生管理 >
    新增/修改
    <hr>
    <form id="Form">
        <div class="row">
            <br class="col-sm-3 col-xs-3">
            <li style="display: none;"><span>ID：</span><input type="text" ng-model="checkitem.studentId"
                                                              name="studentId" class="forminput" id="studentId"/></li>
            <li><span class="span_width">学号：</span><input type="text" ng-model="checkitem.studentNum" name="studentNum"
                                                          class="forminput" id="studentNum"/></li>
            <li><span class="span_width">姓名：</span><input type="text" ng-model="checkitem.studentName"
                                                          name="studentName" class="forminput" id="studentName"/></li>
            <li><span class="span_width">姓名全拼：</span><input type="text" ng-model="checkitem.namePinYin"
                                                            name="namePinYin" class="forminput" id="namePinYin"/></li>
            <li><span class="span_width">曾用名：</span><input type="text" ng-model="checkitem.usedName" name="usedName"
                                                           class="forminput" id="usedName"/></li>
            <div class="photo">
                <ul class="col-sm-3 col-xs-3">
                    <img src="<%=request.getContextPath()%>/images/icon_error.png" id="PreView"
                         style="margin-top:10px; width: 120px;height: 166px;" name="studentIcon" id="studentIcon"
                         ng-click="uploadIcon('#PreView')">
                </ul>
                <input type="text" class="btn" style="border: 0px; cursor:pointer;width:85px" value="选择照片"
                       readonly="readonly" ng-click="uploadIcon('#PreView')"/>
            </div>
            <li><span class="span_width">身份证号码：</span><input type="text" ng-model="checkitem.studentIDCard"
                                                             name="studentIDCard" class="forminput" id="studentIDCard"/>
            </li>
            <li>
                <span class="span_width">性别：</span>
                <select type="text" ng-model="checkitem.studentGender" name="studentGender" class="forminput"
                        id="studentGender"/>
                <option value="">--请选择--</option>
                <option value="男">男</option>
                <option value="女">女</option>
                </select>
            </li>
            <li><span class="span_width">出生日期：</span>
                <input type="text" ng-model="checkitem.studentBirthday" name="studentBirthday" class="forminput"
                       id="studentBirthday"/>
            </li>
            <li><span class="span_width">民族：</span><input type="text" ng-model="checkitem.studentNation"
                                                          name="studentNation" class="forminput" id="studentNation"/>
            </li>
            <li>
                <span class="span_width">政治面貌：</span>
                <select type="text" ng-model="checkitem.studentPolitics" name="studentPolitics" class="forminput"
                        id="studentPolitics"/>
                <option value="">--请选择--</option>
                <option value="共青团员">共青团员</option>
                <option value="中共党员">中共党员</option>
                <option value="群众">群众</option>
                <option value="其他">其他</option>
                </select>
            </li>
            <li><span class="span_width">手机：</span><input type="text" ng-model="checkitem.studentPhone"
                                                          name="studentPhone" class="forminput" id="studentPhone"/></li>
            <li><span class="span_width">邮箱：</span><input type="text" ng-model="checkitem.studentEmail"
                                                          name="studentEmail" class="forminput" id="studentEmail"/></li>
            <li><span class="span_width">其他联系人：</span><input type="text" ng-model="checkitem.linkMan" name="linkMan"
                                                             class="forminput" id="linkMan"/></li>
            <li><span class="span_width">联系人电话：</span><input type="text" ng-model="checkitem.linkManPhone"
                                                             name="linkManPhone" class="forminput" id="linkManPhone"/>
            </li>
            <li><span class="span_width">联系地址：</span><input type="text" ng-model="checkitem.linkManaddress"
                                                            name="linkManaddress" class="forminput"
                                                            id="linkManaddress"/></li>
            <li><span class="span_width">联系人邮编：</span><input type="text" ng-model="checkitem.linkManPostcode"
                                                             name="linkManPostcode" class="forminput"
                                                             id="linkManPostcode"/></li>
            <li><span class="span_width">考号：</span><input type="text" ng-model="checkitem.examNumber" name="examNumber"
                                                          class="forminput" id="examNumber"/></li>
            <li><span class="span_width">高考所在省：</span><input type="text" ng-model="checkitem.province" name="province"
                                                             class="forminput" id="province"/></li>
            <li><span class="span_width">毕业中学：</span><input type="text" ng-model="checkitem.highSchool"
                                                            name="highSchool" class="forminput" id="highSchool"/></li>
            <li><span class="span_width">入学日期：</span><input type="text" ng-model="checkitem.entranceDate"
                                                            name="entranceDate" class="forminput" id="entranceDate"/>
            </li>
            <li>
                <span class="span_width">年级：</span>
                <select type="text" ng-model="checkitem.studentGrade" name="studentGrade" class="forminput"
                        id="studentGrade" ng-change="loadClass()">
                    <option value="" selected="selected">--请选择--</option>
                    <option ng-repeat="grade in grades" value="{{grade.wordbookValue}}">{{grade.wordbookValue}}</option>
                </select>
            </li>
            <li>
                <span class="span_width">学院：</span>
                <select type="text" ng-model="checkitem.studentCollege" name="studentCollege" class="forminput"
                        id=studentCollege" ng-change="loadMajor(this)">
                    <option value="" selected="selected">--请选择--</option>
                    <option ng-repeat="college in colleges" value="{{college.wordbookValue}}"
                            ng-bind="college.wordbookValue"></option>
                </select>
            </li>
            <li>
                <span class="span_width">专业：</span>
                <select type="text" ng-model="checkitem.studentMajor" name="studentMajor" class="forminput"
                        id=studentMajor">
                    <option value="" selected="selected">--请选择--</option>
                    <option ng-repeat="major in majors" value="{{major.majorName}}" ng-bind="major.majorName"></option>
                </select>
                <%--<input type="text" />--%>
            </li>
            <li><span class="span_width">辅修：</span><input type="text" ng-model="checkitem.otherMajor" name="otherMajor"
                                                          class="forminput" id="otherMajor"/></li>
            <li><span class="span_width">班级：</span>
                <%--<div class="listbox forminput">
                    <input type="text" ng-model="checkitem.studentClass" name="studentClass" id="studentClass"  ng-blur="validateClass(checkitem.studentClass)"
                           ng-click="leaveInput()" ng-keyup="changeoptions(checkitem.studentClass)"  placeholder="--全部--"/>
                    <div class="list" ng-show="fakeSelect">
                        <div ng-click="chooseItem(class)" ng-bind="class.className" ng-repeat="class in newClasses">

                        </div>
                    </div>
                    <div class="after" ng-click="selectAll()"></div>
                </div>--%>
                <select type="text" ng-model="checkitem.studentClass" name="studentClass" class="forminput"
                        id="studentClass">
                    <option value="" selected="selected">--请选择--</option>
                    <option ng-repeat="class in newClasses" value="{{class.className}}"
                            ng-bind="class.className"></option>
                </select>
            </li>
            <li>
                <span class="span_width">培养层次：</span>
                <select type="text" ng-model="checkitem.studentLevel" name="studentLevel" class="forminput"
                        id="studentLevel"/>
                <option value="">--请选择--</option>
                <option value="专科">专科</option>
                <option value="本科">本科</option>
                </select>
            </li>
            <li>
                <span class="span_width">学制：</span>
                <select type="text" ng-model="checkitem.studentLength" name="studentLength" class="forminput"
                        id="studentLength"/>
                <option value="">--请选择--</option>
                <option value="3">3</option>
                <option value="4">4</option>
                </select>
            </li>
            <li>
                <span class="span_width">学习形式：</span>
                <select type="text" ng-model="checkitem.studentForm" name="studentForm" class="forminput"
                        id="studentForm"/>
                <option value="" selected="selected">--请选择--</option>
                <option ng-repeat="form in forms" value="{{form.wordbookValue}}" ng-bind="form.wordbookValue"></option>
                </select>
            </li>
            <li>
                <span class="span_width">校区：</span>
                <select type="text" ng-model="checkitem.studentSchoolAddress" name="studentSchoolAddress"
                        class="forminput" id="studentSchoolAddress">
                    <option value="" selected="selected">--请选择--</option>
                    <option ng-repeat="option in options" value="{{option.wordbookValue}}"
                            ng-bind="option.wordbookValue"></option>
                </select>
            </li>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
</body>
</html>
<script>
    var add_edit = true;
    var load_all = true;
    var fakenum = 0;
    var now = (new Date()).getFullYear();
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        var num = 0;
        var img_id;//获取图片Id
        var img_ischange;
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
                $scope.loadStudent();
            }
        }

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadStudent();
        }

        //加载数据
        $scope.loadStudent = function () {
            loading();//加载层
            $('#insert-form').hide();
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
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

                //分页加载跳转到指定页

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
                        if (load_all) {
                            pageNum = pn;//改变当前页
                            //重新加载用户信息
                            $scope.loadStudent();
                        }
                        else {
                            pageNum = pn;//改变当前页
                            //重新加载用户信息
                            $scope.loadStudent();
                        }
                    }
                };
                num = 0;
                $scope.all = false;
                for (i = 0; i < $scope.students.length; i++) {
                    $scope.students[i].td0 = false;
                }
                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            /*remotecall("studentManage_loadGrade",'',function (data) {
             $scope.grades = data;
             },function (data) {
             parent.pMsg("加载年级失败,或连接数据库失败！");
             console.log(data);
             });*/
            remotecall("studentManage_loadSchoolAddress", '', function (data) {
                $scope.options = data;
            }, function (data) {
                parent.pMsg("加载校区失败,或连接数据库失败！");
                console.log(data);
            });
            remotecall("studentManage_loadCollege", '', function (data) {
                $scope.colleges = data;
            }, function (data) {
                parent.pMsg("加载学院失败,或连接数据库失败！");
                console.log(data);
            });
            remotecall("studentManage_loadMajor", {}, function (data) {
                $scope.majors = data;
            }, function (data) {
                parent.pMsg("加载专业失败,或连接数据库失败！");
            });
            remotecall("studentManage_loadClass", {}, function (data) {
                $scope.classes = data;
                $scope.newClasses = data;
            }, function (data) {
                parent.pMsg("加载班级失败,或连接数据库失败！");
            });
            remotecall("studentManage_loadForm", '', function (data) {
                closeLoading();//关闭加载层
                $scope.forms = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载学习形式失败,或连接数据库失败！");
                console.log(data);
            });
            $scope.checklist = [];
            $scope.checkitem = {};
        };
        //根据选择的学院加载相应学院下的专业
        $scope.loadMajor = function (obj) {
            loading();
            var majorCollege = $scope.checkitem.studentCollege;
            remotecall("studentManage_loadMajor", {majorCollege: majorCollege}, function (data) {
                closeLoading();//关闭加载层
                $scope.majors = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载专业失败,或连接数据库失败！");
                console.log(data);
            });
        };
        //根据选择的专业加载相应学院下的班级
        $scope.loadClass = function () {
            loading();

            var grade = $scope.checkitem.studentGrade;
            if (!grade) {
                closeLoading();//关闭加载层
            } else {
                remotecall("studentManage_loadClass", {gradeName: grade}, function (data) {
                    closeLoading();//关闭加载层
                    $scope.newClasses = data;
                    $scope.checkitem.studentClass = '';
                }, function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("加载班级失败,或连接数据库失败！");
                    console.log(data);
                });
            }
        };
        //根据选择的学院
        //批量删除功能
        $scope.delete = function () {
            $('#insert-form').hide();
            loading();
            //获取所选择的行
            if ($("input[name='studentIdSelect']:checked").length < 1) {
                parent.pMsg("请选择一条记录");
                closeLoading();//关闭加载层
                return;
            }
            var deleteIds = $("input[name='studentIdSelect']:checked").map(function (index, elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有学生吗？", function () {
                remotecall("studentManage_deleteStudent", {deleteIds: deleteIds}, function (data) {
                    if (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("批量删除成功");
                        //重新加载学生
                        $scope.loadStudent();
                        $scope.$apply();
                    } else {
                        parent.pMsg("批量删除失败");
                        closeLoading();//关闭加载层
                    }
                }, function (data) {
                    parent.pMsg("批量删除失败");
                    closeLoading();//关闭加载层
                    console.log(data);
                });
            }, function () {
                closeLoading();//关闭加载层
            });
        };
        //删除一个
        $scope.del = function (tr) {

            parent.pConfirm("确认删除该条数据吗？", function () {
                loading();
                remotecall("studentManage_delStudent", tr, function (data) {
                    if (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        $scope.loadStudent();
                        $scope.$apply();
                    } else {
                        closeLoading();//关闭加载层
                        parent.pMsg("删除失败");
                    }
                }, function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("删除失败");
                    console.log(data);
                });
            }, function () {
                closeLoading();//关闭加载层
            });
        }
        //新建
        $scope.add = function () {
            add_edit = true;
            $('#insert-form').hide();
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table').hide();
            $('.table-addform').show();
            $("#Form input").value = "";
            $("#PreView").attr("src", '<%=request.getContextPath()%>/images/icon_error.png');//新建时加载默认图片
        };
        //修改
        $scope.edit = function (tr) {
            add_edit = false;
            $scope.fakeSelect = false;
            $scope.checkitem = tr;
            $('#insert-form').hide();
            remotecallasync("student_loadimg", $scope.checkitem, function (data) {
                if (data[0].studentIcon != "" || data[0].studentIcon != null) {
                    img_ischange = (data[0].studentIcon);
                    $("#PreView").attr("src", serverimg(data[0].studentIcon));
                }
                else {
                    parent.pMsg("图片加载出错");
                }
            });
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-addform').show();
            $('table').hide();
        };

        $scope.insert = function () {
            $('#insert-form').show();
        }
        $scope.close = function () {
            $('#insert-form').hide();
            $("#valid_result,#file").empty();

        }
        //隐藏
        $scope.cancel = function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            }, 300);
            $('table,.title,.pagingbox').show();
            $scope.checklist = [];//清空选中
            $scope.checkitem = {};
            $scope.all = false;
            num = 0;
            for (i = 0; i < $scope.students.length; i++) {
                $scope.students[i].td0 = false;
            }
            $scope.loadStudent();
        };
        //上传图片
        $scope.uploadIcon = function (selector) {
            imguploadandpreview(selector, '1', function (data) {
                img_id = data.fid;//获取图片存储id
            });
        }
        //首次加载学生
        $scope.init();
        //checked 复选框判断
        $scope.all = false;
        $scope.checklist = [];
        $scope.checkitem = {};
        $scope.allfn = function () {
            if ($scope.all == false) {
                for (i = 0; i < $scope.students.length; i++) {
                    $scope.students[i].td0 = false
                }
                num = 0;
            } else {
                for (i = 0; i < $scope.students.length; i++) {
                    $scope.students[i].td0 = true
                }
                num = $scope.students.length;
            }
        };
        $scope.validateClass = function (classname) {
            var times = 0;
            if (!$scope.classes || $scope.classes.length == 0) $scope.classes = [];
            for (var i = 0; i < $scope.classes.length; i++) {
                var item = $scope.classes[i];
                if (item.className == classname) {
                    times++;
                }
            }
            if (times == 0) {
                parent.pMsg("您输入的选项不是现有班级，请重新选择");
                return false;
            }
            return true;
        }
        $scope.thischecked = function (tr) {
            if (tr.td0 == false || tr.td0 == null) {
                num++;
                tr.td0 = true;
                $scope.checklist.push(tr);
            } else {
                num--;
                tr.td0 = false;
                $scope.all = false;
                var index = $scope.checklist.indexOf(tr);
                if (index > -1) {
                    $scope.checklist.splice(index, 1);
                }
            }
            if (num == $scope.students.length) {
                $scope.all = true;
            } else {
                $scope.all = false;
            }
        };
        //人造下拉的逻辑
        $scope.fakeInput = function () {
            $scope.fakeSelect = true;
        }
        $scope.leaveInput = function () {
            if (fakenum == 2)fakenum = 0;
            if (fakenum == 0) {
                $scope.fakeSelect = true;
            }
            if (fakenum == 1) {
                $scope.fakeSelect = false;
            }
            fakenum++;

        }
        $scope.chooseItem = function (obj) {
            $scope.fakeSelect = false;
            $scope.checkitem.studentClass = obj.className;
        }
        $scope.changeoptions = function (obj) {
            $scope.newClasses = [];
            if (!$scope.classes || $scope.classes.length == 0) $scope.classes = [];
            for (var i = 0; i < $scope.classes.length; i++) {
                var item = $scope.classes[i];
                if (item.className.indexOf(obj) >= 0) {
                    $scope.newClasses.push(item);
                }
            }
        }
        $scope.selectAll = function () {
            $scope.fakeSelect = true;
            $scope.newClasses = $scope.classes;
        }
        //表单验证
        $("#Form").validate({
            submitHandler: function (form) {
                loading();
                //验证通过,然后就保存
                if (add_edit) {//如果是添加
                    var parames = $("#Form").serializeObject();//参数
                    if (!$scope.validateClass(parames["studentClass"])) {
                        closeLoading();//关闭加载层
                        return false;
                    }
                    remotecallasync("studentNum_unique", parames, function (data) {//判断用户名是否已存在
                        if (data.length == '0') { //如果用户名不和数据库中的重名,即不存在
                            parames["studentIcon"] = img_id;
                            remotecallasync("studentManage_addStudent", parames, function (data) {
                                if (data) {
                                    parent.pMsg("添加成功");
                                    closeLoading();//关闭加载层
                                    //重新加载
                                    $('.table-addform').hide();
                                    $('table').show();
                                    $('#Form input').text("");
                                    $scope.loadStudent();
                                    $scope.$apply();
                                    img_id = "";
                                } else {
                                    parent.pMsg("添加失败");
                                    closeLoading();//关闭加载层
                                }
                            }, function (data) {
                                parent.pMsg("数据库请求失败");
                                closeLoading();//关闭加载层
                                console.log(data);
                            });
                        } else {
                            parent.pMsg("该学生学号和用户账号重复，请重新输入");
                            closeLoading();//关闭加载层
                        }
                    }, function (data) {
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                } else {//修改
                    var edit_name = $("input[name='studentIdSelect']:checked").map(function (index, elem) {
                        return $(elem).val();
                    }).get();//根据Id判断 修改用户名时只允许修改本用户Id和数据库中不存在的用户名
                    var parames = $("#Form").serializeObject();//参数
//                    parames["studentId"]=edit_name[0];
                    if (!$scope.validateClass(parames["studentClass"])) {
                        closeLoading();//关闭加载层
                        return false;
                    }
                    if (img_id == "") {
                        parames["studentIcon"] = img_ischange;
                    } else {
                        parames["studentIcon"] = img_id;
                    }
                    remotecallasync("studentNum_unique", parames, function (data) {//查询输入的学生学号是否存在
                        if (data.length == '0' || data[0].studentId == edit_name) { //1、用户学号不存在 2、用户id的已有
                            remotecallasync("studentManage_editStudent", parames, function (data) {
                                if (data) {
                                    closeLoading();//关闭加载层
                                    parent.pMsg("修改成功");
                                    //重新加载信息
                                    $('.table-addform').hide();
                                    $('table').show();
                                    $scope.loadStudent();
                                    $scope.$apply();
                                    $scope.checklist = [];
                                    $scope.checkitem = {};
                                    img_id = "";
                                } else {
                                    parent.pMsg("修改失败");
                                    closeLoading();//关闭加载层
                                }
                            }, function (data) {
                                closeLoading();//关闭加载层
                                parent.pMsg("数据库请求失败");
                                console.log(data);
                            });
                        } else {
                            parent.pMsg("该学生学号和用户账号重复，请重新输入");
                            closeLoading();//关闭加载层
                        }
                    }, function (data) {
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                }
            },
            rules: {
                studentNum: {
                    number: true,
                    required: true,
                    maxlength: 45
                },
                studentName: {
                    required: true,
                    maxlength: 45
                },
                namePinYin: {
                    required: true,
                    maxlength: 45
                },
                studentIDCard: {
                    idCard: true,
                    required: true,
                },
                studentGender: {
                    required: true,
                    maxlength: 5
                },
                studentBirthday: {
                    required: true,
                },
                studentNation: {
                    required: true,
                    maxlength: 45
                },
                studentPolitics: {
                    required: true,
                    maxlength: 45
                },
                studentPhone: {
                    required: true,
                    tel: true,
                },
                studentEmail: {
                    required: true,
                    email: true,
                    maxlength: 45
                },
                linkMan: {
                    required: true,
                    maxlength: 45
                },
                linkManPhone: {
                    required: true,
                    tel: true,
                    maxlength: 15
                },
                linkManAddress: {
                    required: true,
                    maxlength: 45
                },
                examNumber: {
                    required: true,
                    maxlength: 45
                },
                province: {
                    required: true,
                    maxlength: 45
                },
                highSchool: {
                    required: true,
                    maxlength: 45
                },
                entranceDate: {
                    required: true,
                    maxlength: 15
                },
                studentGrade: {
                    required: true,
                    maxlength: 45
                },
                studentCollege: {
                    required: true,
                    maxlength: 45
                },
                studentMajor: {
                    required: true,
                    maxlength: 45
                },
                studentClass: {
                    required: true,
                    maxlength: 45
                },
                studentLevel: {
                    required: true,
                    maxlength: 45
                },
                studentLength: {
                    required: true,
                    maxlength: 5
                },
                studentForm: {
                    required: true
                },
                studentSchoolAddress: {
                    required: true,
                    maxlength: 45
                }
            },
            messages: {
                studentNum: {
                    required: "请输入学生学号",
                    number: "请输入数字",
                    maxlength: "长度不超过45个字符"
                },
                studentName: {
                    required: "请输入学生姓名",
                    maxlength: "长度不超过45个字符"
                },
                namePinYin: {
                    required: "请输入学生姓名全拼",
                    maxlength: "长度不超过45个字符"
                },
                studentIDCard: {
                    required: "请输入身份证号码",
                    idCard: "请输入正确格式的身份证号码",
                    maxlength: "长度不超过45个字符"
                },
                studentGender: {
                    required: "请选择学生性别",
                    maxlength: "长度不超过45个字符"
                },
                studentBirthday: {
                    required: "请选择出生日期",
                    maxlength: "长度不超过15个字符"
                },
                studentNation: {
                    required: "请输入民族",
                    maxlength: "长度不超过45个字符"
                },
                studentPolitics: {
                    required: "请选择政治面貌",
                    maxlength: "长度不超过45个字符"
                },
                studentPhone: {
                    required: "请输入电话号码",
                    tel: "请输入正确格式的电话号码"
                },
                studentEmail: {
                    required: "请输入邮箱",
                    email: "请输入正确格式的邮箱"
                },
                linkMan: {
                    required: "请输入其他联系人",
                    maxlength: "长度不超过45个字符"
                },
                linkManPhone: {
                    required: "请输入电话号码",
                    tel: "请输入正确格式的电话号码"
                },
                linkManaddress: {
                    required: "请输入联系人地址",
                    maxlength: "长度不超过45个字符"
                },
                examNumber: {
                    required: "请输入学生考号",
                    maxlength: "长度不超过45个字符"
                },
                province: {
                    required: "请输入高考所在省",
                    maxlength: "长度不超过45个字符"
                },
                highSchool: {
                    required: "请输入毕业中学",
                    maxlength: "长度不超过45个字符"
                },
                entranceDate: {
                    required: "请选择入学日期",
                    maxlength: "长度不超过15个字符"
                },
                studentGrade: {
                    required: "请选择年级",
                    maxlength: "长度不超过45个字符"
                },
                studentCollege: {
                    required: "请选择学院",
                    maxlength: "长度不超过45个字符"
                },
                studentMajor: {
                    required: "请输入学生专业",
                    maxlength: "长度不超过45个字符"
                },
                studentClass: {
                    required: "请输入学生班级",
                    maxlength: "长度不超过45个字符"
                },
                studentLevel: {
                    required: "请选择培养层次",
                    maxlength: "长度不超过45个字符"
                },
                studentLength: {
                    required: "请选择学制",
                    maxlength: "长度不超过5个字符"
                },
                studentForm: {
                    required: "请选择学习形式",
                },
                studentSchoolAddress: {
                    required: "请选择校区",
                    maxlength: "长度不超过45个字符"
                }
            },
            //重写showErrors
            showErrors: function (errorMap, errorList) {
                var msg = "";
                $.each(errorList, function (i, v) {
                    //msg += (v.message + "\r\n");
                    //在此处用了layer的方法,显示效果更美观
                    layer.tips(v.message, v.element, {time: 2000});
                    return false;
                });
            },
            /* 失去焦点时不验证 */
            onfocusout: false,
            onkeyup: false,
            onclick: false
        });

        //     验证文件
        $scope.validFile = function () {
            if (!$("#upfile").val()) {
                layer.msg("请选择文件！");
                return;

            }
            $.ajaxFileUpload({
                url: "<%=request.getContextPath()%>/dataupload/validdata.form", //用于文件上传的服务器端请求地址
                secureuri: false, //一般设置为false
                fileElementId: "upfile", //文件上传空间的id属性
                dataType: 'String', //返回值类型 一般设置为String
                success: function (data, status)  //服务器成功响应处理函数
                {
                    $scope.showResult(data);
                    console.log(data.errormessage);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    layer.msg("上传文件失败，请重新上传");
                }
            });
        }
        /**
         * 上传文件
         */
        $scope.uploadFile = function () {
            if (!$("#upfile").val()) {
                layer.msg("请选择文件！");
                return;
            }
            loading();
            $.ajaxFileUpload({
                url: "<%=request.getContextPath()%>/dataupload/studentinfo.form", //用于文件上传的服务器端请求地址
                secureuri: false, //一般设置为false
                fileElementId: "upfile", //文件上传空间的id属性
                dataType: 'String', //返回值类型 一般设置为String
                success: function (data, status)  //服务器成功响应处理函数
                {
                    //console.log(data);
                    closeLoading();//关闭加载层
                    $scope.showResult(data);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    closeLoading();//关闭加载层
                    layer.msg("上传文件失败，请重新上传");
                }
            });
        }

        /*
         * 上传文件后显示服务器返回的信息
         * @param data
         */
        $scope.showResult = function (data) {
            $("#valid_result").html("");
            //去除返回字符串的  <pre style="word-wrap: break-word; white-space: pre-wrap;"> 标签
            var str = data.substring(data.indexOf('>') + 1, data.lastIndexOf('<'));
            var s = eval("(" + str + ")");
            var str = s.msg + "<br>";
            if (s.data) {
                $.each(s.data, function () {
                    if (this.data) {
                        str += "&nbsp;&nbsp;" + this.msg + "<br>";
                        $.each(this.data, function () {
                            str += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + this + "<br>";
                        })
                    } else {
                        str += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + this + "<br>";
                    }
                });
            }
            $("#valid_result").html(str);
        }

        //下载模版文件
        $scope.getModel = function () {
            try {
                var elemIF = document.createElement("iframe");
                elemIF.src = "../../files/students_info.xls";
                elemIF.style.display = "none";
                document.body.appendChild(elemIF);
            } catch (e) {
            }
        }
    });
    //绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#search").click();
        }
    });
    //日历
    $("#studentBirthday,#entranceDate").jeDate({
        format: "YYYY-MM-DD",
        isTime: false,
        minDate: "1990-00-00 00:00:00",
        isOk: false
    })

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>
