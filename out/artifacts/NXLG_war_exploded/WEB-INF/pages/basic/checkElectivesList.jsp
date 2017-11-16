<%--
  Created by IntelliJ IDEA.
  User: NEUNB_Lisy
  Date: 2017/6/5
  Time: 17:34
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
</head>
<style>
    .major{
        margin-top: 10px;
    }
    .class{
        margin-top: 10px;
    }
    .stu{
        margin-top: 10px;
    }
    #search{
        margin-left: 15px;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：课程选修学生名单
<hr>

<input class="tablesearchbtn" id="tablesearchbtn1" ng-show="show=='1'" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>
<input class="tablesearchbtn" id="tablesearchbtn2" ng-show="show=='2'" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr2(this)"/>
<input class="tablesearchbtn" id="tablesearchbtn3" ng-show="show=='3'" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr3(this)"/>
<table-btn style="margin-top: -3px;" id="search" ng-click="searchWhich()">搜索</table-btn>

<table-btn style="margin-top: -3px;" ng-if="show=='2'" ng-click="gobackToMajor()">返回</table-btn>

<table-btn style="margin-top: -3px;" ng-if="show=='3'" style="width: 170px;margin-left: 20px;" ng-click="btnExcel()" class="btnExcel">导出课程选修学生</table-btn>
<table-btn style="margin-top: -3px;" ng-if="show=='3'" ng-click="gobackToCourse()">返回</table-btn>

<div  class="table_major" ng-if="show=='1'">
    <table class="table major">
        <thead>
            <th>所属学院</th>
            <th>专业代码</th>
            <th>专业名称</th>
            <th>所属学科</th>
            <th>培养层次</th>
            <th>学制</th>
            <th>查看</th>
        </thead>
        <tbody>
            <tr ng-repeat="major in majors">
                <td ng-bind="major.majorCollege"></td>
                <td ng-bind="major.majorCode"></td>
                <td ng-bind="major.majorName"></td>
                <td ng-bind="major.subject"></td>
                <td ng-bind="major.level"></td>
                <td ng-bind="major.length"></td>
                <td><table-btn ng-click="loadClass(major,true)">查看课程</table-btn></td>
            </tr>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
<div class="table_class" ng-if="show=='2'">
    <table class="table class">
        <thead>
            <th>课程名称</th>
            <th>班级</th>
            <th>教师</th>
            <th>教学方式</th>
            <th>周时</th>
            <th>上课时间</th>
            <th>查看</th>
        </thead>
        <tbody>
            <tr ng-repeat="course in courses">
                <td ng-bind="course.chineseName"></td>
                <td ng-bind="course.tc_class"></td>
                <td ng-bind="course.teacherName"></td>
                <td ng-bind="course.tc_teachway"></td>
                <td><span ng-bind="course.tc_thweek_start"></span>至<span ng-bind="course.tc_thweek_end"></span>周（<span ng-bind="course.tc_teachodd"></span>）</td>
                <td><span ng-repeat="time in course.times">
                    星期<span ng-bind="time.al_timeweek"></span>&nbsp;第<span ng-bind="time.al_timepitch"></span>节&nbsp;<span ng-bind="time.classroomName"></span><br>
                </span></td>
                <td><table-btn ng-click="loadStu(course,true)">查看课程学生</table-btn></td>
            </tr>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
<div ng-if="show=='3'">
    <form id="exportTo" method="post" hidden>
    </form>
    <table class="table stu">
        <thead>
        <th>学号</th>
        <th>姓名</th>
        <th>性别</th>
        <th>民族</th>
        <th>年级</th>
        <th>学院</th>
        <th>专业</th>
        <th>班级</th>
        <th>培养层次</th>
        <th>学习形式</th>
        <th>校区</th>
        </thead>
        <tbody>
        <tr ng-repeat="stu in stus">
            <td ng-bind="stu.studentNum"></td>
            <td ng-bind="stu.studentName"></td>
            <td ng-bind="stu.studentGender"></td>
            <td ng-bind="stu.studentNation"></td>
            <td ng-bind="stu.studentGrade"></td>
            <td ng-bind="stu.studentCollege"></td>
            <td ng-bind="stu.studentMajor"></td>
            <td ng-bind="stu.studentClass"></td>
            <td ng-bind="stu.studentLevel"></td>
            <td ng-bind="stu.studentForm"></td>
            <td ng-bind="stu.studentSchoolAddress"></td>
        </tr>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
<%--<div class="pagingbox">
    <paging></paging>
</div>--%>
</body>
<script>
    var oldPageNum=1;
    var oldClassPageNum=1;
var app=angular.module("app",[]);
app.controller("ctrl",function ($scope) {
    pageSize=2;
    $scope.show=0;
    $scope.theMajor={};//存储查询的专业
    $scope.theCoruse={};//存储查询的课程
    $scope.loadData=function () {
        if($scope.show!=1){
            $scope.show=1;
            $scope.gotoPage(1,0);
        }
        loading();
        remotecall("checkElectivesList_loadMajor",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
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
            closeLoading();
            $scope.majors=data.rows;
            if(data.rows.length==0){
                parent.pMsg("暂无专业");
            }
        },function (data) {
            closeLoading();
            console.log(data);
            parent.pMsg("加载数据失败");
        });

    };

    //查看该专业的开课课程
    $scope.loadClass=function (tr,isfirst) {
        if(isfirst){
            oldPageNum=pageNum;
            pageNum=1;
            $('#tablesearchbtn2').val("");
            searchStr2="";
        }
        $scope.courses=[];
        if(tr==1){
            tr=$scope.theMajor;
        }else{
//            $('.tablesearchbtn').val("");
//            searchStr2="";
            $scope.theMajor=tr;
        }
        if($scope.show!=2){
            $scope.show=2;
            $scope.gotoPage(1,0);
        }
        loading();
        remotecall("checkElectivesList_loadCourse",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr2,majorId:tr.majorId},function (data) {
            closeLoading();
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
            if (data.rows.length==0){
                parent.pMsg("该专业暂无课程");
            }else{
                $scope.courses=data.rows;
                /*for (var i=0;i<$scope.courses.length;i++){
                    $scope.courses[i].al="星期"+$scope.courses[i].times[0].al_timeweek+" 第"+$scope.courses[i].times[0].al_timepitch+"节";
                }*/
                /*var x=0;
                $scope.coursesItems=[];
                $scope.coursesItems[0]=$scope.courses[0]
                for(var i=1;i<$scope.courses.length;i++){
                    if($scope.coursesItems[x].tc_id==$scope.courses[i].tc_id){
                        $scope.coursesItems[x].al= $scope.coursesItems[x].al+" "+$scope.courses[i].al;
                    }else {
                        $scope.coursesItems.push($scope.courses[i]);
                        x++;
                    }
                }*/
            }
        },function (data) {
            closeLoading();
            console.log(data);
            parent.pMsg("加载数据失败");
        });
//        searchStr2=null;
    };

    //查看该班级的学生
    $scope.loadStu=function (tr,isfirst) {
        if(isfirst){
            oldClassPageNum=pageNum;
            pageNum=1;
            $('#tablesearchbtn3').val("");
            searchStr3="";
        }
        if (tr==1){
            tr=$scope.theCoruse;
        }else {
//            $('.tablesearchbtn3').val("");
//            searchStr3="";
            $scope.theCoruse=tr;
        }
        if($scope.show!=3){
            $scope.show=3;
            $scope.gotoPage(1,0);
        }
        loading();
        remotecall("checkElectivesList_loadStu",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr3,tc_id:tr.tc_id},function (data) {
            closeLoading();

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
            if(data.rows.length==0){
                $scope.stus=[];
                parent.pMsg("该课程暂无学生");
            }else {

                $scope.stus=data.rows;
            }
        },function (data) {
            closeLoading();
            parent.pMsg("加载数据失败");
            console.log(data);
        });
    };

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
            if( $scope.show==1){
                $scope.loadData();
            }else if($scope.show==2){
                $scope.loadClass($scope.theMajor);
            }else if($scope.show==3){
                $scope.loadStu($scope.theCoruse);
            }
        }
    };

    //从课程列表返回专业列表
    $scope.gobackToMajor=function () {
        pageNum=oldPageNum;
//        searchStr=null;
        $scope.show=1;
//        $scope.gotoPage(1);
        $scope.loadData();
//        $('.tablesearchbtn').val("");
    };

    //从学生列表返回课程列表
    $scope.gobackToCourse=function () {
        pageNum=oldClassPageNum;
//        searchStr=null;
        $scope.show=2;
//        $scope.gotoPage(1);
        $scope.loadClass(1);
//        $('.tablesearchbtn').val("");
    }
//导出到信息到Excel
    $scope.btnExcel=function () {
        var url="../../export/exportCourseStudentInfo.form?searchStr="
            +searchStr3+"&tc_id="+$scope.theCoruse.tc_id;
        $("#exportTo").attr("action",url);
        $("#exportTo").submit();
    }

//    搜索哪一项内容
    $scope.searchWhich=function () {
        if($scope.show==1){
            $scope.loadData();
        }else if($scope.show==2){
            $scope.loadClass(1);
        }else  if($scope.show==3){
            $scope.loadStu(1);
        }
    }
    //预加载
    $scope.loadData();

});
</script>
</html>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>