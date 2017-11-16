<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/20
  Time: 16:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
</head>
<style>
    .table-show{
        position:relative;
        top: 0;
        left: 0 !important;
    }
    .table-show .row{
        padding: 10px 0;
    }
    .table-show .bttn{
        margin-left: 25%;
        border: 1px solid #c5add7;
        height: 26px;
        background: #edeaf1;
    }
    .table-show ul{
        width: 30%;
        float: left;
    }
    .table-show li{
        margin: 10px -10px;
        display: inline-flex;
    }
    .table-show li span{
        width: 200px;
        display: inline-block;
    }
    .table-show li>span:first-child,.newword{
        color:#5c307d;
        font-family: "微软雅黑";
        margin-right:-90px;
    }
    .first span{
        font-size: 17px;
        color: red;
    }
    .title .tablesearchbtn{
        width: 120px;
        margin-left: 5px;
    }
    <%--查看详情--%>
    .table-courseshow{
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
    .findArgmCour{
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
        padding-left: 50px;
        padding-right: 50px;
    }
    .bttn{
        margin-left: 26%;
        margin-top:30px;
        border: 1px solid #c5add7;
        height: 26px;
        background: #edeaf1;
    }
    .show ul{
        width: 25%;
        padding-left: 40px;
        margin-left: 35px;
        float: left;
    }
    .show li{
        margin: 10px 60px;
        display: inline-flex;
    }
    .show li span{
        min-width: 105px;
        display: inline-block;
        margin-right: 20px;
    }
    .show li>span:first-child{
        color:#5c307d;
        font-family: "微软雅黑";
    }
    .black{
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
    #selectcourse{
        height: 400px;
        border: 1px solid #c5add7;
        margin-top: 31px;
        padding: 24px;
        overflow-y: scroll;
        position: relative;
        /* scrollbar-base-color: #c5add7;
         scrollbar-shadow-color: #fff;*/
    }
    #selectcourse .table caption{
        color: #5c307d;
        margin-top: -10px;
        margin-bottom: 5px;
        margin-left: 20px;
        font-size: 18px;
    }
    .btn-selectcourse{
        position: absolute;
        right: 26px;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：学生选课
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <div class="first" ng-if="show=='0'">
        <span ng-if="thischoose||thatchoose||otherchoose">现在可选</span>
        <span ng-if="thischoose&&!otherchoose">本专业课程</span>
        <span ng-if="thatchoose&&!otherchoose">辅修专业课程</span>
        <span ng-if="otherchoose">所有专业课程</span>
        <span ng-if="(!Var)&&(!tiaoji)&&(!tiaojiconfirm)">现在是非选课时间,不能选课</span>
        <span ng-if="tiaoji">现在是调剂课程时间,请及时调剂课程</span>
        <span ng-if="tiaojiconfirm">现在是调剂确认时间,请及时调剂课程</span>
    </div>
    <table-btn ng-if="show=='1'" ng-click="previous1()">返回</table-btn><%--返回第一页--%>
    <div ng-if="show=='2'">
        <table-btn ng-click="previous2()">返回</table-btn><%--返回选课平台--%>
        <span>教师<input class="tablesearchbtn" type="text" placeholder="输入教师姓名" id="keytname"/></span>
        <span>教室<input class="tablesearchbtn" type="text" placeholder="输入教室" id="keyroom"/></span>
        <span>承担单位<input class="tablesearchbtn" type="text" placeholder="输入承担单位" id="keyunit"/></span>
        <span>上课时间 <span>第</span><input class="tablesearchbtn" type="text" id="keytime" style="width:60px" />周</span>
        <span ng-if="otherchoose||tiaoji||tiaojiconfirm">专业筛选</span>
        <span ng-show="otherchoose||tiaoji||tiaojiconfirm">
           <select ng-model="wgy.college" class="forminput" style="width: 120px" ng-change="loadMajor()">
                <option value="">全部</option>
                <option ng-repeat="college in colleges" value="{{college.majorCollege}}">{{college.majorCollege}}</option>
           </select>
           <select ng-model="wgy.keyMajor" class="forminput"  ng-change="loadCourse1()">
                <option value="">全部</option>
                <option ng-repeat="keyMajor in majors" value="{{keyMajor.majorName}}">{{keyMajor.majorName}}</option>
           </select>
        </span>
        <table-btn id="search" ng-click="loadCourse()">搜索</table-btn>
        <div style="margin-left: 80px; margin-top: 10px;">
            <span style="margin-right: 40px">本平台本次选修的总学分： <span style="color: #FF1F06" ng-bind="thistotalfenshu"></span>分</span>
            <span style="margin-right: 40px">本次选课选修的总学分： <span style="color: #FF1F06" ng-bind="totalthisfenshu"></span>分</span>
            <span style="margin-right: 40px">总计选修的总学分：  <span style="color: #FF1F06" ng-bind="totalfenshu"></span>分</span>
        </div>
        <%-- <br/>--%>
        <div style="margin-left: 80px; margin-top: 10px;">
            <span style="margin-right: 40px">该平台总学分：<span style="color: #FF1F06" ng-bind="scoreall"></span>分</span>
            <span style="margin-right: 40px">在该平台需修满学分：<span style="color: #FF1F06" ng-bind="scoretotal"></span>分</span>
            <span style="margin-right: 40px">本专业在该平台需修满学分：<span style="color: #FF1F06" ng-bind="scorethis"></span>分</span>
            <span style="margin-right: 40px">可其他专业在该平台修满学分：<span style="color: #FF1F06" ng-bind="scoreother"></span>分</span>
        </div>
    </div>
    <table-btn ng-if="show=='3'" ng-click="previous3()">返回</table-btn>
</div>
<!--第一个页面-->
<div class="table-show" id="fisrtpage" style="width: 100%" ng-if="(!tiaoji)&&(show=='0')&&(!tiaojiconfirm)" >
    <div class="row" style="width: 100%">
        <ul>
            <li><span style="font-size: 15px"> 本专业课程 </span></li><br/>
            <li><span>选课开始时间：</span><span ng-bind="thischoosestart"></span></li>
            <li><span>选课结束时间：</span><span ng-bind="thischooseend"></span></li>
        </ul>
        <ul>
            <li><span  style="font-size: 15px">其他专业课程  </span></li><br/>
            <li><span>选课开始时间：</span><span ng-bind="otherchoosestart"></span></li>
            <li><span>选课结束时间：</span><span ng-bind="otherchooseend"></span></li>
        </ul>
        <ul>
            <li><span style="font-size: 15px" > 辅修选课时间 </span></li><br/>
            <li><span>选课开始时间:  </span><span ng-bind="thatchoosestart"></span></li>
            <li><span>选课结束时间：</span><span ng-bind="thatchooseend"></span></li>
        </ul>
    </div>
    <div class="row" style="width: 100%">
        <ul>
            <li>
                <span class="newword" style="font-size: 15px">可选修最低学分:</span>
                <span ng-bind="mincredits" style="width:50px;margin-left:15px;color:red "></span><span>学分</span>
            </li>
        </ul>
        <ul>
            <li>
                <span class="newword" style="font-size: 15px">可选修最高学分:</span>
                <span ng-bind="maxcredits"  style="width:50px;margin-left:15px;color:red "></span><span>学分</span>
            </li>
        </ul>
    </div>
    <div class="row" style="width: 100%">
        <ul>
            <li ><span class="newword" style="font-size: 15px">主修专业:</span><span ng-bind="student.studentMajor"></span></li>
        </ul>
        <ul ng-show="student.otherMajor!=''&&student.otherMajor!=null"><li><span class="newword" style="font-size: 15px">辅修专业:</span> <span  ng-bind="student.otherMajor" ></span></li></ul>
    </div>
    <div class="text-center" style="margin-top: 30px;" ng-if="Var||tiaoji||tiaojiconfirm">
        <table-btn class="confirm" id="confirm" ng-click="loadTerrace()">去选课</table-btn>
    </div>
</div>
<%--调剂--%>
<div class="table-show" id="tiaojipage" style="width: 100%" ng-if="(tiaoji||tiaojiconfirm)&&show=='0'">
    <div class="row" style="width: 100%">
        <ul>
            <li><span style="font-size: 15px"> 调剂课程时间 </span></li><br/>
            <li><span>调剂开始时间：</span><span ng-bind="tiaojistart"></span></li>
            <li><span>调剂结束时间：</span><span ng-bind="tiaojiend"></span></li>
        </ul>
        <ul>
            <li><span style="font-size: 15px"> 调剂确认时间 </span></li><br/>
            <li><span>开始时间：</span><span ng-bind="tiaojicomfirmstart"></span></li>
            <li><span>结束时间：</span><span ng-bind="tiaojicomfirmend"></span></li>
        </ul>
    </div>
    <div class="row" style="width: 100%">
        <ul>
            <li>
                <span class="newword" style="font-size: 15px">可选修最低学分:</span>
                <span ng-bind="mincredits" style="width:50px;margin-left:15px;color:red "></span><span>学分</span>
            </li>
        </ul>
        <ul>
            <li>
                <span class="newword" style="font-size: 15px">可选修最高学分:</span>
                <span ng-bind="maxcredits"  style="width:50px;margin-left:15px;color:red "></span><span>学分</span>
            </li>
        </ul>
    </div>
    <div class="row" style="width: 100%">
        <ul>
            <li ><span class="newword" style="font-size: 15px">主修专业:</span><span ng-bind="student.studentMajor"></span></li>
        </ul>
        <ul ng-show="student.otherMajor!=''&&student.otherMajor!=null"><li><span class="newword" style="font-size: 15px">辅修专业:</span> <span  ng-bind="student.otherMajor" ></span></li></ul>
    </div>
    <div class="text-center" style="margin-top: 30px;" ng-if="tiaoji||tiaojiconfirm">
        <table-btn class="confirm" id="confirm" ng-click="canloadTerrace()">去调剂</table-btn>
    </div>
</div>
<%--第二个页面平台--%>
<div class="tablebox" id="terrace" ng-if="show=='1'">
    <table class="table">
        <thead>
        <th>序号</th>
        <th>平台名称</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="terrace in terraces">
            <td>{{$index+1}}</td>
            <td ng-bind="terrace.terraceName"></td>
            <td ng-click="loadCourse(terrace)"><table-btn>选择</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--选择课程--%>
<div class="tablebox" id="course" ng-if="show=='2'">
    <table class="table">
        <thead>
        <th hidden>terraceId</th>
        <th>课程代码</th>
        <th>中文名称</th>
        <th>承担单位</th>
        <th>课程所属专业</th>
        <%--  <th>班级所属专业</th>--%>
        <th>课程类别</th>
        <th>所在班级</th>
        <th>任课教师</th>
        <th>开课人数</th>
        <th>人数范围</th>
        <th>已选人数</th>
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
            <%-- <td ng-bind="course.tcm_majorid"></td>--%>
            <td ng-bind="search(course.tcm_grade,course.majorName,course.courseId,course.terraceId)"></td>
            <td ng-bind="course.tc_class"></td>
            <td ng-bind="course.teacherName"></td>
            <td ng-bind="course.tc_studentnum"></td>
            <td ng-bind="course.tc_numrange"></td>
            <td ng-bind="course.sumcourse"></td>
            <td ng-bind="course.totalCredit"></td>
            <td ng-bind="course.totalTime"></td>
            <td ng-bind="'第'+course.tc_thweek_start+'至'+course.tc_thweek_end+'周|'+course.tc_teachodd" ></td>
            <td >
                <b ng-repeat="weektime in course.times">
                    <span ng-bind="'星期'+weektime.al_timeweek"></span>
                    <b ng-repeat="jieshu in weektime.jie">
                        <span ng-bind="'第'+jieshu.al_timepitch+'节|地点'+jieshu.classroomName"></span>
                    </b>
                    <br/>
                </b>
            </td>
            <td><table-btn ng-click="showCourse(course)">查看详情</table-btn>
                <b style="margin-right: 10px"></b>
                <span ng-if="(!tiaoji)&&(!tiaojiconfirm)">
                <table-btn ng-click="chooseCourse(course)" ng-if="judgeselect(course.majorId,course.courseId,course.tc_class,course.terraceId)&&(!comfirm)">选修</table-btn>
                <table-btn ng-click="exitCourse(course)" ng-if="(!judgeselect(course.majorId,course.courseId,course.tc_class,course.terraceId))&&(!comfirm)">退选</table-btn>
                <table-btn  style="color:#449d44;" ng-if="comfirm">已确认</table-btn>
                </span>
                <span ng-if="tiaoji">
                    <table-btn  style="color:#449d44;" ng-if="judgetiaojiselect(course.majorId,course.courseId,course.tc_class,course.terraceId)=='已选'">已选</table-btn>
                    <table-btn ng-click="chooseCourse(course)"ng-if="judgetiaojiselect(course.majorId,course.courseId,course.tc_class,course.terraceId)=='选修'">选修</table-btn>
                    <table-btn ng-click="exitCourse(course)" ng-if="judgetiaojiselect(course.majorId,course.courseId,course.tc_class,course.terraceId)=='退选'">调剂退选</table-btn>
                </span>
                <span ng-if="tiaojiconfirm">
                    <span ng-if="!confirmtiaoji">
                         <table-btn  style="color:#449d44;" ng-if="judgetiaojiselect(course.majorId,course.courseId,course.tc_class,course.terraceId)=='已选'">已选</table-btn>
                         <table-btn ng-click="choosetiaojiCourse(course)" ng-if="judgetiaojiselect(course.majorId,course.courseId,course.tc_class,course.terraceId)=='选修'">选修</table-btn>
                         <table-btn ng-click="exitCourse(course)" ng-if="judgetiaojiselect(course.majorId,course.courseId,course.tc_class,course.terraceId)=='退选'">调剂退选</table-btn>
                    </span>
                    <table-btn ng-if="confirmtiaoji" style="color:#449d44;" ng-if="comfirm">已确认</table-btn>
                </span>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<%--查看课程详情--%>
<div class="table-courseshow">
    <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
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
    <%-- <table-btn class="bttn" ng-click="modify()">选修</table-btn><table-btn class="bttn" ng-click="other()">辅修</table-btn>--%>
</div>
<div class="black"></div>
<div class="pagingbox" ng-if="show=='2'">
    <paging></paging>
</div>

<%--已选选择课程--%>
<div class="tablebox" id="selectcourse"  ng-if="show=='2'">
    <div class="btn-selectcourse" <%--ng-if="Var"--%> ng-if="(!tiaojiconfirm)&&(!tiaoji)">
        <table-btn class="confirm" id="selectconfirm" style="color:#5c307d; background-color: #fff;border-color: #5c307d" ng-click="selectconfirm()" ng-if="!comfirm"
                   >确认选择以下课程</table-btn>
        <table-btn class="confirm" id="selectconfirm" style="color:#449d44; background-color: #fff" ng-if="comfirm">已确认本学期课程,无法更改</table-btn>
    </div>
    <div class="btn-selectcourse" ng-if="tiaojiconfirm">
        <table-btn class="confirm"  ng-if="!confirmtiaoji" style="color:#5c307d; background-color: #fff;border-color: #5c307d" ng-click="confirmtiaojiend()"
                  >确认选择以下课程</table-btn>
        <table-btn class="confirm" ng-if="confirmtiaoji" style="color:#449d44; background-color: #fff">已确认本学期课程,无法更改</table-btn>
    </div>
    <table class="table">
        <caption>已选课程</caption>
        <thead>
        <th hidden>terraceId</th>
        <th>课程代码</th>
        <th>中文名称</th>
        <th>承担单位</th>
        <th>课程所属专业</th>
        <th>所在班级</th>
        <th>任课教师</th>
        <th>开课人数</th>
        <th>人数范围</th>
        <th>已选人数</th>
        <th>总学分</th>
        <th>总学时</th>
        <th>上课周</th>
        <th>时间/地点</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="course in selectcourses">
            <td ng-bind="course.terraceId" hidden></td>
            <td ng-bind="course.courseCode"></td>
            <td ng-bind="course.chineseName"></td>
            <td ng-bind="course.assumeUnit"></td>
            <td ng-bind="course.majorName"></td>
            <td ng-bind="course.class"></td>
            <td ng-bind="course.teacherName"></td>
            <td ng-bind="course.tc_studentnum"></td>
            <td ng-bind="course.tc_numrange"></td>
            <td ng-bind="course.sumcourse"></td>
            <td ng-bind="course.totalCredit"></td>
            <td ng-bind="course.totalTime"></td>
            <td ng-bind="'第'+course.tc_thweek_start+'至'+course.tc_thweek_end+'周|'+course.tc_teachodd" ></td>
            <td >
                <b ng-repeat="weektime in course.times">
                    <span ng-bind="'星期'+weektime.al_timeweek"></span>
                    <b ng-repeat="jieshu in weektime.jie">
                        <span ng-bind="'第'+jieshu.al_timepitch+'节|地点'+jieshu.classroomName"></span>
                    </b>
                    <br/>
                </b>
            </td>
            <td ng-if="(!tiaoji)&&(!tiaojiconfirm)">
                <table-btn ng-click="exit(course)" ng-if="!comfirm">退选</table-btn>
                <table-btn style="color:#449d44;"  ng-if="comfirm">已确认</table-btn>
            </td>
            <td ng-if="tiaoji">
                <table-btn ng-click="exit(course)" ng-if="course.iscomfirm==''||course.iscomfirm==null">调剂退选</table-btn>
                <table-btn ng-click="exit(course)" ng-if="course.iscomfirm=='0'">调剂退选</table-btn>
                <table-btn style="color:#449d44;"  ng-if="course.iscomfirm=='1'">已选</table-btn>
            </td>
            <td ng-if="tiaojiconfirm">
                <span ng-if="!confirmtiaoji">
                <table-btn ng-click="exit(course)" ng-if="((!judgetiaojicomfirm(course.courseId,course.class))&&course.iscomfirm!='1')||course.iscomfirm=='2'">调剂退选</table-btn>
                <table-btn style="color:#449d44;"  ng-if="course.iscomfirm=='1'||(judgetiaojicomfirm(course.courseId,course.class)&&course.iscomfirm!='2')">已选</table-btn>
                </span>
                <table-btn style="color:#449d44;"  ng-if="confirmtiaoji">已确认</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<%--查看课表--%>
<div class="findArgmCour" id="findArgmCourTable">
    <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close2()">
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
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.Var=false;
        $scope.thischoose=false;
        $scope.otherchoose=false;
        $scope.thatchoose=false;
        $scope.tiaoji=false;
        $scope.tiaojiconfirm=false;
        pageSize=5;
        $scope.checklist=[];
        $scope.checkitem={};
        $scope.majors = [];
        $scope.show=0;
        $scope.comfirm=false;
        $scope.confirmtiaoji=false;
        //加载第一页数据
        $scope.loadData = function () {
            loading();//加载
            $scope.show=0;
            /* $(".pagingbox,.black,#terrace,#course,#selectcourse").hide();
             $("#fisrtpage,#tiaojipage").show();*/
            remotecall("basic_coursechoosetime_load",'',function (data) {
                if(data!=null&&data!=""){
                    $scope.thischoosestart = data[0].thischoosestart;
                    $scope.thischooseend = data[0].thischooseend;
                    $scope.otherchoosestart = data[0].otherchoosestart;
                    $scope.otherchooseend = data[0].otherchooseend;
                    $scope.thatchoosestart = data[0].thatchoosestart;
                    $scope.thatchooseend = data[0].thatchooseend;
                    $scope.tiaojistart=data[0].tiaojistart;
                    $scope.tiaojiend=data[0].tiaojiend;
                    $scope.tiaojicomfirmstart=data[0].tiaojicomfirmstart;
                    $scope.tiaojicomfirmend=data[0].tiaojicomfirmend;
                }
                else{
                    parent.pMsg("当前未设置选课时间");
                }
            },function (data) {
                parent.pMsg("加载时间失败");
            });
            remotecall("basic_creditsRange_load",'',function (data) {
                $scope.mincredits = data[0].mincredits;
                $scope.maxcredits = data[0].maxcredits;
            },function (data) {
                parent.pMsg("加载学分失败");
            });
            remotecall("basic_studentMajor_load",'',function (data) {
                $scope.student = data[0];
            },function (data) {
                parent.pMsg("加载专业失败");
            });
            closeLoading();
        };
        $scope.loadcollege=function(){
            remotecall("stu_major_load",'',function (data) {
                $scope.colleges = data;
            },function (data) {
                parent.pMsg("加载学院失败,或连接数据库失败！");
            });
        }
        $scope.wgy = {
            college: '',
            keyMajor: ''
        }
        //根据选择的学院加载相应学院下的专业
        $scope.loadMajor = function(){
            if(!$scope.wgy.college){
                $scope.majors = [];
                return ;
            }
            $scope.majors = $scope.colleges.filter(function(college){
                return college.majorCollege == $scope.wgy.college;
            })[0].majors;
        }
        $scope.loadCourse1=function () {
            pageNum=1;
            //console.log( $scope.wgy.keyMajor ) ;
            $scope.loadCourse();
        }
        //确认现在是什么时间 该显示什么
        $scope.inittime=function () {
            var date = new Date();
            var seperator1 = "-";
            var seperator2 = ":";
            var month = date.getMonth() + 1;
            var strDate = date.getDate();
            if (month >= 1 && month <= 9) {
                month = "0" + month;
            }
            if (strDate >= 0 && strDate <= 9) {
                strDate = "0" + strDate;
            }
            var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
                + " " + date.getHours() + seperator2 + date.getMinutes()
                + seperator2 + date.getSeconds();
            var time=ConvertDateFromString(currentdate);
            if(ConvertDateFromString($scope.thischoosestart)<time&&time<ConvertDateFromString($scope.thischooseend)){
                $scope.thischoose=true;
                $scope.Var=true;
                $scope.loadcollege();
            }if(ConvertDateFromString($scope.thatchoosestart)<time&&time<ConvertDateFromString($scope.thatchooseend)){
                $scope.thatchoose=true;
                $scope.Var=true;
                $scope.loadcollege();
            }if(ConvertDateFromString($scope.otherchoosestart)<time&&time<ConvertDateFromString($scope.otherchooseend)){
                $scope.otherchoose=true;
                $scope.Var=true;
                $scope.loadcollege();
            }if(ConvertDateFromString($scope.tiaojistart)<time&&time<ConvertDateFromString($scope.tiaojiend)){
                $scope.tiaoji=true;
                $scope.loadcollege();
            }if(ConvertDateFromString($scope.tiaojicomfirmstart)<time&&time<ConvertDateFromString($scope.tiaojicomfirmend)){
                $scope.tiaojiconfirm=true;
                $scope.loadcollege();
            }
        }

        $scope.loadData();
        $scope.inittime();
        //加载平台页面
        $scope.loadTerrace = function  () {
            $scope.show=1;
            /* $("#terrace,.title").show();*/
            $(".pagingbox,.table-nav,.black").hide();
            loading();//加载
            remotecall("basic_stuterraceManage_load",{searchStr:''},function (data) {
                $scope.terraces = data;
                closeLoading();//关闭加载层
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
        };
        //已选分数
        $scope.load=function () {
            loading();//加载（总）
            remotecall("basic_creditshave_load",'',function (data) {
                closeLoading();//关闭加载层
                if(data.length>0){
                    $scope.totalfenshu = data[0].totalfenshu;
                    if(data[0].totalfenshu==null){
                        $scope.totalfenshu=0;
                    }
                }else{
                    $scope.totalfenshu=0;
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载失败");
            });
            loading();//加载（已选分数（本学期,不限平台）
            remotecall("basic_creditsthishave_load",'',function (data) {
                closeLoading();//关闭加载层
                if(data.length>0){
                    $scope.totalthisfenshu = data[0].totalthisfenshu;
                    if(data[0].totalthisfenshu==null){
                        $scope.totalthisfenshu=0;
                    }
                }else{
                    $scope.totalthisfenshu=0;
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载失败");
            });
        }
        $scope.loadscore=function () {
            var terraceId= $scope.checkitem.terraceId;
            loading();//加载（总）
            remotecall("basic_credit_load",{terraceId:terraceId},function (data) {
                closeLoading();//关闭加载层
                if(data.length>0){
                    $scope.scoreall = data[0].scoreall;
                    $scope.scoretotal=data[0].scoretotal;
                    $scope.scorethis=data[0].scorethis;
                    $scope.scoreother=data[0].scoreother;
                    if(data[0].scoreall==null){
                        $scope.scoreall=0;
                    }if(data[0].scoretotal==null){
                        $scope.scoretotal=0;
                    }if(data[0].scorethis==null){
                        $scope.scorethis=0;
                    }if(data[0].scoreother==null){
                        $scope.scoreother=0;
                    }
                }else{
                    $scope.scoreall = 0;
                    $scope.scoretotal=0;
                    $scope.scorethis=0;
                    $scope.scoreother=0;
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载失败");
            });
        }
        //是否这学期这个平台已经确认选课了
        $scope.checkconfirm=function () {
            loading();
            var terraceId= $scope.checkitem.terraceId;
            remotecall("teacher_stuhavachooseCourse_load",{terraceId:terraceId},function (data) {
                closeLoading();
                if(data.total>0){
                    $scope.comfirm=true;
                }else{
                    $scope.comfirm=false;
                }
            },function (data) {
                closeLoading();
            });
        };
        //是否这个平台中确认调剂了
        $scope.istiaojicomfirm=function(){
            loading();
            var terraceId= $scope.checkitem.terraceId;
            remotecall("basic_stuistiaojicomfirm_load",{terraceId:terraceId},function (data) {
                closeLoading();//关闭加载层
                if(data.total>0){
                    $scope.confirmtiaoji=false;
                }else{
                    $scope.confirmtiaoji=true;
                }
            },function (data) {
                closeLoading();//关闭加载层
                /* parent.pMsg("加载数据失败");*/
            });
        };
        $scope.loadhavethis=function () {
            var terraceId= $scope.checkitem.terraceId;
            loading();//加载（已选分数（本学期,平台）
            remotecall("basic_creditsthistracehave_load",{terraceId:terraceId},function (data) {
                closeLoading();//关闭加载层
                if(data.length>0){
                    $scope.thistotalfenshu = data[0].thistotalfenshu;
                    if(data[0].thistotalfenshu==null){
                        $scope.thistotalfenshu=0;
                    }
                }else{
                    $scope.thistotalfenshu=0;
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载失败");
            });
        }
        //加载第三页课程
        $scope.loadCourse = function  (terrace) {
            $scope.load();
            $scope.checklist.push(terrace);
            $scope.checkitem=$scope.checklist[0];
            if($scope.thischoose||$scope.thatchoose||$scope.otherchoose){
                $scope.checkconfirm();
            }else{
                $scope.istiaojicomfirm();
            }
            var studentMajor='';
            var otherMajor='';
            $scope.show=2;
            $(".pagingbox").show();
            var keytname=$("#keytname").val();
            var keyroom=$("#keyroom").val();
            var keyunit=$("#keyunit").val();
            var keytime=$("#keytime").val();
            var keyMajor=$scope.wgy.keyMajor ;
            if($scope.wgy.keyMajor==null){
                keyMajor='';
            }
            var majorName='';
            var terraceId= $scope.checkitem.terraceId;
            $scope.loadhavethis();
            $scope.loadselectCourse();
            $scope.loadscore();
            loading();//加载
            if($scope.thischoose&&$scope.thatchoose&&(!$scope.otherchoose)){//主修 輔修時間到了
                studentMajor=$scope.student.studentMajor;
                if($scope.student.otherMajor!=''&&$scope.student.otherMajor!=null)
                {
                    otherMajor=$scope.student.otherMajor;
                }
            }else if($scope.thischoose&&(!$scope.thatchoose)&&(!$scope.otherchoose)){//只主修時間
                studentMajor=$scope.student.studentMajor;
                otherMajor='';
            }else if($scope.thatchoose&&(!$scope.thischoose)&&(!$scope.otherchoose)){//只輔修時間
                if($scope.student.otherMajor!=''&&$scope.student.otherMajor!=null)
                {
                    otherMajor=$scope.student.otherMajor;
                }
                studentMajor='';
            }else if($scope.otherchoose){//其他專業
                otherMajor='';
                studentMajor='';
            }
            remotecall("teacher_majorchoosecourse_load",{pageNum:pageNum,pageSize:pageSize,keyMajor:keyMajor,terraceId:terraceId,studentMajor:studentMajor,otherMajor:otherMajor,keytname:keytname,keyroom:keyroom, keyunit:keyunit,keytime:keytime},function (data) {
                closeLoading();//关闭加载层
                $scope.courses = data.rows;
                console.log($scope.courses[0].sumcourse);
                pageCount = parseInt((data.total-1)/pageSize)+1;//页码总数
                // 分页逻辑开始
                $scope.allPage=[];
                $scope.sliPage=[];
                for(var i=1;i<=Math.ceil(data.total/5);i++){
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

                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无可选课程");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        //课程的类别是必修还是选修
        $scope.search= function (tcm_grade,majorName,courseId,terraceId) {
            loading();
            var courseCategory_1='';
            var t = remotecall("teacher_courseCategory_1_load", {ep_grade:tcm_grade,ep_major:majorName,courseId:courseId,terraceId:terraceId},function (data) {
                closeLoading();//关闭加载层
                if(data.total>0){
                    courseCategory_1=data.rows[0].courseCategory_1;
                }else{
                    courseCategory_1='';
                }
            },function (data) {
                closeLoading();
                parent.pMsg("网络故障");
            });
            return courseCategory_1;
        }
        //课程专属类别
        /*$scope.search2= function (tc_majorId) {
         loading();
         var majorName='';
         if(tc_majorId==''||tc_majorId==null){ majorName='全部专业可选';}
         else{
         var t = remotecall("teacher_majorname_load", {tc_majorId:tc_majorId},function (data) {
         closeLoading();//关闭加载层
         if(data){
         majorName=data[0].majorName+'可选';
         }
         });
         }
         return majorName;
         }*/
        //加载本学期我在该平台已选择的课程
        $scope.loadselectCourse = function  () {
            var terraceId= $scope.checkitem.terraceId;
            loading();//加载
            remotecall("basic_stuselectcourse_load",{terraceId:terraceId},function (data) {
                closeLoading();//关闭加载层
                $scope.selectcourses = data.rows;
            } ,function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        }
        //判断选修还是未选修
        $scope.judgeselect=function (majorId,courseId,tc_class,terraceId) {
            loading();
            var t=true;
            remotecall("basic_stuisselect_load",{majorId:majorId,courseId:courseId,tc_class:tc_class,terraceId:terraceId},function (data) {
                closeLoading();//关闭加载层
                if(data.total>0){
                    t=false;
                }
            },function (data) {
                closeLoading();//关闭加载层
                /* parent.pMsg("加载数据失败");*/
            });
            return t;
        }
        //调剂确认阶段 课程人数如果达到开课人数，显示已选(不限平台)
        $scope.judgetiaojicomfirm=function (courseId,cl) {
            var r=false;
            loading();
            remotecall("basic_stuiselect2_load",{courseId:courseId,tc_class:cl},function (data) {
                closeLoading();//关闭加载层
                r=data.result;
            },function (data) {
                closeLoading();//关闭加载层
            });
            return r;
        };
        //调剂阶段与调剂确认阶段 课程状态
        $scope.judgetiaojiselect=function (majorId,courseId,tc_class,terraceId) {
            //是否在已选课成表中
            loading();
            var t='';
            if($scope.tiaojiconfirm){
                remotecall("basic_stuisselect_load",{majorId:majorId,courseId:courseId,tc_class:tc_class,terraceId:terraceId},function (data) {
                    closeLoading();//关闭加载层
                    if(data.total>0){
                        //显示退选还是显示已选
                        loading();
                        remotecall("basic_stuiselect1_load",{majorId:majorId,courseId:courseId,tc_class:tc_class,terraceId:terraceId},function (data) {
                            closeLoading();
                            if(data.total>0){
                                t='已选';
                            }else {
                                loading();
                                remotecall("basic_stuiselect3_load", {majorId: majorId,courseId: courseId,tc_class:tc_class,terraceId:terraceId}, function (data) {
                                    closeLoading();
                                    if (data.total > 0) {
                                        t = '退选'
                                    } else {
                                        //调剂阶段课程 已选列表中的人数达到规定的
                                        loading();
                                        remotecall("basic_stuiselect2_load", { majorId: majorId, courseId: courseId,tc_class: tc_class}, function (data) {
                                            closeLoading();
                                            if (data.result) {
                                                t = '已选';
                                            } else {
                                                t = '退选'
                                            }
                                        }, function (data) {
                                            closeLoading();//关闭加载层
                                        });
                                    }
                                }, function (data) {
                                    closeLoading();//关闭加载层
                                });
                            }
                        },function (data) {
                          closeLoading();//关闭加载层
                     });
                    }else{t='选修';}
                },function (data) {
                    closeLoading();//关闭加载层
                });
            }else{
                remotecall("basic_stuisselect_load",{majorId:majorId,courseId:courseId,tc_class:tc_class,terraceId:terraceId},function (data) {
                    closeLoading();//关闭加载层
                    if(data.total>0){
                        //显示退选还是显示已选                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ·
                        remotecall("basic_stuiselect1_load",{majorId:majorId,courseId:courseId,tc_class:tc_class,terraceId:terraceId},function (data) {
                            if(data.total>0){
                                t='已选';
                            }else{
                                t='退选';
                            }
                        },function (data) {
                            closeLoading();//关闭加载层
                        });
                    }else{
                        t='选修';
                    }

                },function (data) {
                    closeLoading();//关闭加载层
                });
            } return t;
        }
        //退选
        $scope.exitCourse=function (course) {
            parent.pConfirm("确认退选该课程吗？", function () {
                loading();
                remotecall("teacher_stuexitCourse_del", course, function (data) {
                    closeLoading();//关闭加载层
                    if(data)
                    {   parent.pMsg("退选成功");
                        //重新加载菜单
                        $scope.loadCourse();
                        $scope.$apply();
                    }}, function (data) {
                });
            }, function (data) {
            });
        }
        //退选
        $scope.exit=function (course) {
            parent.pConfirm("确认退选该课程吗？", function () {
                loading();
                remotecall("teacher_stuexitCourse_del2", course, function (data) {
                    closeLoading();//关闭加载层
                    if(data)
                    {   parent.pMsg("退选成功");
                        //重新加载菜单
                        $scope.loadCourse();
                        $scope.$apply();
                    }}, function (data) {
                });
            }, function (data) {
            });
        }
        //上一步
        $scope.previous1=function () {
            $scope.show=0;
        }
        //上一步
        $scope.previous2=function () {
            $scope.show=1;
            pageNum=1;
            $scope.checklist=[];
            $scope.checkitem={};
        }
        //查看详情
        $scope.showCourse=function (course) {
            $scope.course=course;
            $('.table-courseshow,.black').show();
        }
        //选课
        $scope.chooseCourse=function (course) {
            loading();
            remotecall("teacher_stuchooseCourse_add",course,function (data) {
                closeLoading();
                if(data.result==0){
                    $scope.load();
                    $scope.loadhavethis();
                    $scope.loadselectCourse();
                    if(data.errormessage==''||data.errormessage==null){
                        parent.pMsg("选课成功")
                    }else {
                        parent.pMsg("选课成功,该课程先行课为："+data.errormessage)
                    }
                }else if (data.result==1) {
                    parent.pMsg(data.errormessage);
                }else if (data.result==2) {
                    parent.pMsg("本课程与 "+data.row+" 时间冲突");
                }else if (data.result==3) {
                    parent.pMsg(data.errormessage);
                }else if(data.result==4) {
                    parent.pMsg("选课请求失败");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("选课请求失败");
            });
        }
        //调剂确认阶段选课（只能选择人数达到范围的）
        $scope.choosetiaojiCourse=function (course) {
            loading();
            remotecall("teacher_stutiaojiCourse_add",course,function (data) {
                closeLoading();
                if(data.result==0){
                    $scope.load();
                    $scope.loadselectCourse();
                    if(data.errormessage==''||data.errormessage==null){
                        parent.pMsg("选课成功")
                    }else {
                        parent.pMsg("选课成功,该课程先行课为："+data.errormessage)
                    }
                }else if (data.result==1) {
                    parent.pMsg(data.errormessage);
                }else if (data.result==2) {
                    parent.pMsg("本课程与 "+data.row+" 时间冲突");
                }else if (data.result==3) {
                    parent.pMsg(data.errormessage);
                }else if(data.result==4) {
                    parent.pMsg("选课请求失败");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("选课请求失败");
            });
        }
        //确认选课
        $scope.selectconfirm=function () {
            parent.pConfirm("一经确认,不可更改，是否确认提交课程", function () {
                var terraceId = $scope.checkitem.terraceId;
                var isautotiaoji = ''
                if ($scope.mincredits > $scope.totalthisfenshu) {
                    parent.pMsg("学分不够,再选一些！");
                    return;
                }
                if ($scope.totalthisfenshu > $scope.maxcredits) {
                    parent.pMsg("学分超出，请退选一些！");
                    return;
                }
                window.parent.layer.confirm('如果课程人数不足，是否进入自动调剂？', {
                    btn: ['否', '是'],
                    closeBtn: 0
                }, function () {
                    isautotiaoji = 0;
                    loading();
                    remotecall("basic_stucomfirmcou_add", {
                        terraceId: terraceId,
                        isautotiaoji: isautotiaoji
                    }, function (data) {
                        closeLoading();//关闭加载层
                        if (data) {
                            parent.pMsg("确认成功");
                            $scope.comfirm = true;
                            //重新加载菜单
                            $scope.loadStuArgmCour0();
                            $('.findArgmCour,.black').show();
                            $scope.$apply();
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                }, function () {
                    isautotiaoji = 1;
                    loading();
                    remotecall("basic_stucomfirmcou_add", {
                        terraceId: terraceId,
                        isautotiaoji: isautotiaoji
                    }, function (data) {
                        closeLoading();//关闭加载层
                        if (data) {
                            parent.pMsg("确认成功");
                            $scope.comfirm = true;
                            //重新加载菜单
                            $scope.loadStuArgmCour0();

                            $scope.$apply();
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                });
            });
        }
        //调剂确认阶段的确定
        $scope.confirmtiaojiend=function(){
            parent.pConfirm(" 调剂一经确认,不可更改，是否确认提交课程", function () {
                var terraceId= $scope.checkitem.terraceId;
                if($scope.mincredits>$scope.totalthisfenshu){
                    parent.pMsg("学分不够,再选一些！");
                    return;
                }
                if($scope.totalthisfenshu>$scope.maxcredits){
                    parent.pMsg("学分超出，请退选一些！");
                    return;
                }
                loading();
                remotecall("basic_stucomfirmtiaojicou_add",{terraceId:terraceId},function (data) {
                    closeLoading();//关闭加载层
                    if(data.result)
                    {   parent.pMsg("确认成功");
                        $scope.confirmtiaoji=true;
                        //重新加载菜单
                        $scope.loadStuArgmCour();
                        $scope.$apply();
                    }else{
                        parent.pMsg(data.errormessage);
                    }
                },function (data) {
                    closeLoading();
                    parent.pMsg("数据库请求失败");
                });});
        }
        //关闭详情
        $scope.close=function () {
            $('.table-courseshow,.black').hide();
        }
        $scope.close2=function () {
            $('.findArgmCour,.black').hide();
        }
        //加载调剂确认课表信息
        $scope.loadStuArgmCour=function () {
            loading();//加载
            remotecallasync("basic_StuArgmCour_load",'',function (data) {
                closeLoading();
                $scope.scheduleByRooms = data;//加载的数据对象，‘courses’根据不同需求而变
                $('.findArgmCour,.black').show();
                $scope.$apply();
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        }
        $scope.canloadTerrace=function () {
            loading();//加载
            remotecall("basic_checktiaojiable_load",'',function (data) {
                closeLoading();//关闭加载层
                if(data.result){
                    //如果可以进去，把istiaojicomfirm='2',然后加载平台,否则进去了把调剂的课去掉，这个人全部课已开课，再也就进不去了
                    loading();
                    remotecall("basic_checktiaojiable_edit",'',function (data) {
                        closeLoading();
                        if(data.result){
                            $scope.loadTerrace();
                        }else{
                            parent.pMsg("网络故障");
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("加载数据失败");
                    });
                }else{
                    if($scope.tiaojiconfirm){
                        parent.pMsg("您的课程已全部开课，不能在进入调剂系统");
                    }else{
                        parent.pMsg("您的课程已全部开课,如需调剂课程,请填写调剂申请");
                    }

                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        }
        //加载选课确认课表信息
        $scope.loadStuArgmCour0=function () {
            loading();//加载
            remotecallasync("basic_StuArgmCour_load2",'',function (data) {
                closeLoading();
                $scope.scheduleByRooms = data;//加载的数据对象，‘courses’根据不同需求而变
                $('.findArgmCour,.black').show();
                $scope.$apply();
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
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
                $scope.loadCourse();
            }
        };
    });
    //时间：将字符型转为时间型，值为毫秒
    function ConvertDateFromString(dateString) {
        if (dateString) {
            /* var arr1 = dateString.split(" ");
             var sdate = arr1[0].split('-');
             var mdate = arr1[1].split(':');*/
            var date = new Date(dateString).getTime();
            return date;
        }
    }
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>