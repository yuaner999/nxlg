<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-17
  Time: 10:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <!--单引css-->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/myinfo.css"/>
    <!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/myinfo.js" type="text/javascript" charset="utf-8"></script>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：信息管理
<hr>
    <div class="photo" ng-if="true">
        <div class="photobox">
            <img ng-src="{{serverimg(user.UCimage)}}" id="HeadIcon"/>
        </div>
        <table-btn ng-click="uploadIcon('#HeadIcon')"><img src="<%=request.getContextPath()%>/images/tablechange_07.png"/>更换头像</table-btn>
    </div>
    <div class="information">
        <div class="phone" ng-if="user.typeName!='管理员'">
                    <span>
                        <img src="<%=request.getContextPath()%>/images/userphone_03.png"/>
                        <span ng-bind="user.UCphone"></span>
                    </span>
            <table-btn ng-click="editPhone()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png"/>修改手机号</table-btn>
                    <span style="margin-left: 60px;">
                        <img src="<%=request.getContextPath()%>/images/useremail_06.png"/>
                        <span ng-bind="user.UCemail"></span>
                    </span>
            <table-btn ng-click="editEmail()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png"/>修改邮箱</table-btn>
        </div>
        <div ng-if="user.typeName=='学生'">
            <ul>
                <li>
                    <b>学号</b><span ng-bind="user.studentNum"></span>
                </li>
                <li>
                    <b>姓名</b><span ng-bind="user.studentName"></span>
                </li>
                <li>
                    <b>姓名全拼</b><span ng-bind="user.namePinYin"></span>
                </li>
                <li>
                    <b>曾用名</b><span ng-bind="user.usedName"></span>
                </li>
                <li>
                    <b>身份证号</b><span ng-bind="user.studentIDCard"></span>
                </li>
                <li>
                    <b>性别</b><span ng-bind="user.studentGender"></span>
                </li>
                <li>
                    <b>出生日期</b><span ng-bind="user.studentBirthday"></span>
                </li>
                <li>
                    <b>民族</b><span ng-bind="user.studentNation"></span>
                </li>
                <li>
                    <b>政治面貌</b><span ng-bind="user.studentPolitics"></span>
                </li>
            </ul>
            <ul>
                <li>
                    <b>其他联系人</b><span ng-bind="user.linkMan"></span>
                </li>
                <li>
                    <b>联系人电话</b><span ng-bind="user.linkManPhone"></span>
                </li>
                <li>
                    <b>联系人地址</b><span ng-bind="user.linkManaddress"></span>
                </li>
                <li>
                    <b>联系人邮编</b><span ng-bind="user.linkManPostcode"></span>
                </li>
            </ul>
            <ul>
                <li>
                    <b>考号</b><span ng-bind="user.examNumber"></span>
                </li>
                <li>
                    <b>高考所在省</b><span ng-bind="user.province"></span>
                </li>
                <li>
                    <b>毕业中学</b><span ng-bind="user.highSchool"></span>
                </li>
                <li>
                    <b>入学日期</b><span ng-bind="user.entranceDate"></span>
                </li>
                <li>
                    <b>年级</b><span ng-bind="user.studentGrade"></span>
                </li>
                <li>
                    <b>学院</b><span ng-bind="user.studentCollege"></span>
                </li>
                <li>
                    <b>专业</b><span ng-bind="user.studentMajor"></span>
                </li>
                <li>
                    <b>班级</b><span ng-bind="user.studentClass"></span>
                </li>
                <li>
                    <b>培养层次</b><span ng-bind="user.studentLevel"></span>
                </li>
                <li>
                    <b>学制</b><span ng-bind="user.studentLength"></span>
                </li>
                <li>
                    <b>学习形式</b><span ng-bind="user.studentForm"></span>
                </li>
                <li>
                    <b>校区</b><span ng-bind="user.studentSchoolAddress"></span>
                </li>
            </ul>
        </div>
        <div ng-if="user.typeName=='教师'">
            <ul>
                <li>
                    <b>工号</b><span ng-bind="user.teacherNumber"></span>
                </li>
                <li>
                    <b>教师姓名</b><span ng-bind="user.teacherName"></span>
                </li>
                <li>
                    <b>性别</b><span ng-bind="user.teacherGender"></span>
                </li>
                <li>
                    <b>民族</b><span ng-bind="user.nation"></span>
                </li>
                <li>
                    <b>政治面貌</b><span ng-bind="user.politics"></span>
                </li>
                <li>
                    <b>加入时间</b><span ng-bind="user.politicsDate"></span>
                </li>
                <li>
                    <b>身份证号</b><span ng-bind="user.IDCard"></span>
                </li>
                <li>
                    <b>出生日期</b><span ng-bind="user.birthday"></span>
                </li>
                <li>
                    <b>来校时间</b><span ng-bind="user.schoolDate"></span>
                </li>
                <li>
                    <b>所属部门</b><span ng-bind="user.department"></span>
                </li>
                <li>
                    <b>行政职务</b><span ng-bind="user.administrative"></span>
                </li>
                <li>
                    <b>任教单位</b><span ng-bind="user.teachUnit"></span>
                </li>
            </ul>
            <ul>
                <li>
                    <b>专业技术职务</b><span ng-bind="user.duty"></span>
                </li>
                <li>
                    <b>专业技术职务任职资格时间</b><span ng-bind="user.dutyDate"></span>
                </li>
                <li>
                    <b>专业技术职务等级</b><span ng-bind="user.dutyLevel"></span>
                </li>
                <li>
                    <b>学历</b><span ng-bind="user.education"></span>
                </li>
                <li>
                    <b>学历学习时间</b><span ng-bind="user.educationDate"></span>
                </li>
                <li>
                    <b>学历专业</b><span ng-bind="user.educationMajor"></span>
                </li>
                <li>
                    <b>学历获取机构</b><span ng-bind="user.educationSchool"></span>
                </li>
                <li>
                    <b>学缘结构</b><span ng-bind="user.educationStructure"></span>
                </li>
                <li>
                    <b>学位</b><span ng-bind="user.degree"></span>
                </li>
                <li>
                    <b>学位学习时间</b><span ng-bind="user.degreeDate"></span>
                </li>
                <li>
                    <b>学位所学专业</b><span ng-bind="user.degreeMajor"></span>
                </li>
                <li>
                    <b>学位获取机构</b><span ng-bind="user.degreeSchool"></span>
                </li>
            </ul>
            <ul>
                <li>
                    <b>高等教育资格证</b><span ng-bind="user.certificate"></span>
                </li>
                <li>
                    <b>高等教育资格证获得时间</b><span ng-bind="user.certificateDate"></span>
                </li>
                <li>
                    <b>从教时间</b><span ng-bind="user.teachDate"></span>
                </li>
                <li>
                    <b>任教学院</b><span ng-bind="user.teachCollege"></span>
                </li>
                <li>
                    <b>任教专业</b><span ng-bind="user.teachMajor"></span>
                </li>
                <li>
                    <b>任教学段</b><span ng-bind="user.teachSection"></span>
                </li>
                <li>
                    <b>任课状况</b><span ng-bind="user.teachStatus"></span>
                </li>
                <li>
                    <b>从事领域</b><span ng-bind="user.teachArea"></span>
                </li>
                <li>
                    <b>是否事业编制</b><span ng-bind="user.isCompile"></span>
                </li>
                <li>
                    <b>签订合同情况</b><span ng-bind="user.contract"></span>
                </li>
                <li>
                    <b>五险一金</b><span ng-bind="user.fiveOne"></span>
                </li>
                <li>
                    <b>是否双师</b><span ng-bind="user.doubleTeacher"></span>
                </li>
            </ul>
            <ul>
                <li>
                    <b>职业资格证书等级</b><span ng-bind="user.certificateLevel"></span>
                </li>
                <li>
                    <b>是否有行业背景</b><span ng-bind="user.bBackground"></span>
                </li>
                <li>
                    <b>是否有工程背景</b><span ng-bind="user.pBackground"></span>
                </li>
                <li ng-if="user.employ=='是'">
                    <b>外聘工作单位</b><span ng-bind="user.employUnit"></span>
                </li>
                <li ng-if="user.employ=='是'">
                    <b>外聘日期</b><span ng-bind="user.employDate"></span>
                </li>
                <li ng-if="user.employ=='是'">
                    <b>外聘来源</b><span ng-bind="user.employSource"></span>
                </li>
                <li>
                    <b>户籍所在地</b><span ng-bind="user.native"></span>
                </li>
                <li>
                    <b>家庭地址</b><span ng-bind="user.address"></span>
                </li>
                <li>
                    <b>是否在岗</b><span ng-bind="user.onGuard"></span>
                </li>
                <li>
                    <b>状态</b><span ng-bind="user.status"></span>
                </li>
            </ul>
        </div>
        <div ng-if="user.typeName=='管理员'">
            <ul>
                <li>
                    <b style="width: 126px">姓名</b><span ng-bind="user.adminName"></span>
                </li>
                <li>
                    <b style="width: 126px">电话</b><span ng-bind="user.UCphone"></span>
                </li>
                <li>
                    <b style="width: 126px">邮箱</b><span ng-bind="user.UCemail"></span>
                </li>
            </ul>
            <ul>
                <li >
                    <table-btn ng-click="editPhone()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png"/>修改手机号</table-btn><span class="tabble-btn"></span>
                    <table-btn ng-click="editEmail()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png"/>修改邮箱</table-btn>
                </li>
            </ul>
        </div >
    </div>
</body>
</html>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>