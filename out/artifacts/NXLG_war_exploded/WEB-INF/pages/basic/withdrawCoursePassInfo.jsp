<%--
  Created by IntelliJ IDEA.
  User: gq
  Date: 2017/6/3
  Time: 15:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：查看退课学生
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <span>专业名称：</span>
    <select  ng-model="para.majorName" name="majorName" class="forminput" id="majorName" >
        <option value="" >--请选择--</option>
        <option ng-repeat="major in majors" value="{{major.majorId}}">{{major.majorName}}</option>
    </select>

    <span style="margin-left: 20px">课程名称：</span>
    <select  ng-model="para.courseName" name="courseName" class="forminput" id="courseName" >
        <option value="" >--请选择--</option>
        <option ng-repeat="course in courses" value="{{course.courseId}}">{{course.chineseName}}</option>
    </select>

    <%--<input  class="tablesearchbtn" ng-model="para.termName" name="termName" class="forminput" id="termName" placeholder="请输入想要搜索的学期名称"/>--%>
    <input style="width: 280px;" class="tablesearchbtn" type="text" placeholder="请输入想要搜索的学期或学生学号或姓名" onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadData()">搜索</table-btn>
    <table-btn class="top_1" ng-click="btnExcel()">导出到Excel</table-btn>
    <form class="top_1" method="post" hidden></form>
</div>
<!--选修课程列表-->
<div class="tablebox" id="allInfo">
    <table class="table">
        <thead>
        <th>学号</th>
        <th>姓名</th>
        <th>课程代码</th>
        <th>课程名</th>
        <th>平台</th>
        <th>所在班级</th>
        <th>专业名称</th>
        <th>教师</th>
        <th>学期</th>
        <th>状态</th>
        <th>申请理由</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td ng-bind="data.studentNum"></td>
            <td ng-bind="data.studentName"></td>
            <td ng-bind="data.courseCode"></td>
            <td ng-bind="data.chineseName"></td>
            <td ng-bind="data.terraceName"></td>
            <td ng-bind="data.class"></td>
            <td ng-bind="data.majorName"></td>
            <td ng-bind="data.teacherName"></td>
            <td ng-bind="data.term"></td>
            <td ng-bind="data.scc_status"></td>
            <td ng-bind="data.Areason"></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载数据
        $scope.datalist = [];
        $scope.dataitem = {};
        $scope.para = {};
        remotecall("withdrawCoursePassInfo_loadoptions",{}, function (data) {
            $scope.courses=data.course;
            $scope.semesters=data.semester;
            $scope.majors=data.major;
        }, function (data) {
        });
        $scope.loadData = function (){
            loading();//加载
            remotecall("withdrawCoursePassInfo_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr,
                course:$scope.para.courseName, semester:$scope.para.termName, major:$scope.para.majorName}, function (data) {
                closeLoading();
                if(data==0){
                    parent.pMsg("该用户没有权限");
                }else if(data.total==0){
                    parent.pMsg("无退课数据");
                    $scope.datas = data.rows;
                }else{
                    $scope.datas = data.rows;
                }
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
            }, function (data) {
                closeLoading();
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
                //重新加载用户信息
                $scope.loadData
            }
        };

        //导出到课程信息到Excel
        $scope.btnExcel=function () {
            var url="../../export/exportWithdrawCourseInfo.form?searchStr="+searchStr+"&course="+$scope.para.courseName
                +"&semester"+$scope.para.termName+"&major="+$scope.para.majorName;
            $(".top_1").attr("action",url);
            $(".top_1").submit();
        }
        $scope.loadData();
    });

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>