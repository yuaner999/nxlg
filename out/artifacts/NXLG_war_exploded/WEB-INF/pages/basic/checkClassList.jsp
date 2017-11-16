<%--
  Created by IntelliJ IDEA.
  User: NEUNB_Lisy
  Date: 2017/6/2
  Time: 15:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@include file="../commons/common.jsp"%><!--单引js-->
<script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>

<style>
    .tablebox_stu{
        display: none;
    }
    .tablesearchbtn{
        width: 130px !important;
        margin-left: 5px !important;
    }
</style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：查看班级学生名单
<hr>
<div class="table-load">
    <div class="tablebox_class a-show a-hide">
        <div class="title">
            <span class="span_width">课程名称：</span><input class="tablesearchbtn" type="text"  placeholder="请输入课程名称" ng-model="searchStr.chineseName"/>
            <span class="span_width">课程代码：</span><input class="tablesearchbtn" type="text"  placeholder="请输入课程代码" ng-model="searchStr.courseCode"/>
            <span class="span_width">负责教师：</span><input class="tablesearchbtn" type="text"  placeholder="请输入负责教师" ng-model="searchStr.teacherName"/>
            <span class="span_width">班级名称：</span><input class="tablesearchbtn" type="text"  placeholder="请输入班级名称" ng-model="searchStr.tc_class"/>
            <span class="span_width">授课方式：</span><input class="tablesearchbtn" type="text"  placeholder="请输入授课方式" ng-model="searchStr.tc_teachway"/>
            <span class="span_width">年级：</span><input class="tablesearchbtn" type="text"  placeholder="请输入年级" ng-model="searchStr.tc_grade"/>
            <table-btn id="search" ng-click="loadData()">搜索</table-btn>
        </div>
        <table class="table">
            <thead>
                <th>课程名称</th>
                <th>课程代码</th>
                <th>负责教师</th>
                <th>班级名称</th>
                <th>授课方式</th>
                <th>年级</th>
                <th>班级人数</th>
                <th>上课周时</th>
                <th>操作</th>
            </thead>
            <tbody>
                <tr ng-repeat="data in datas">
                    <td ng-bind="data.chineseName"></td>
                    <td ng-bind="data.courseCode"></td>
                    <td ng-bind="data.teacherName"></td>
                    <td ng-bind="data.tc_class"></td>
                    <td ng-bind="data.tc_teachway"></td>
                    <td ng-bind="data.tc_grade"></td>
                    <td ng-bind="data.tc_studentnum"></td>
                    <td><span ng-bind="data.tc_thweek_start"></span>至<span ng-bind="data.tc_thweek_end"></span>周(<span ng-bind="data.tc_teachodd"></span>)</td>
                    <td><table-btn ng-click="loadDataStu(data)">查看学生</table-btn></td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="tablebox_stu a-show a-hide">
        <div class="title">
            <span class="span_width">学号：</span><input class="tablesearchbtn" type="text"  placeholder="请输入学生学号" ng-model="searchStu.studentNum"/>
            <span class="span_width">姓名：</span><input class="tablesearchbtn" type="text"  placeholder="请输入学生姓名" ng-model="searchStu.studentName"/>
            <span class="span_width">年级：</span><input class="tablesearchbtn" type="text"  placeholder="请输入学生年级" ng-model="searchStu.studentGrade"/>
            <span class="span_width">学院：</span><input class="tablesearchbtn" type="text"  placeholder="请输入学院" ng-model="searchStu.studentCollege"/>
            <span class="span_width">专业：</span><input class="tablesearchbtn" type="text"  placeholder="请输入专业" ng-model="searchStu.studentMajor"/>
            <span class="span_width">班级：</span><input class="tablesearchbtn" type="text"  placeholder="请输入学生班级" ng-model="searchStu.studentClass"/>
            <span class="span_width">校区：</span><input class="tablesearchbtn" type="text"  placeholder="请输入校区" ng-model="searchStu.studentSchoolAddress"/>
            <table-btn id="search" ng-click="loadDataStu(0)">搜索</table-btn>
            <table-btn ng-click="goback()">返回</table-btn>
            <table-btn style="width: 170px;margin-left: 50px;margin-top: 20px;" ng-click="btnExcel()" class="btnExcel">导出班级学生信息</table-btn>
            <form id="exportTo" method="post" hidden>
            </form>
        </div>
        <table class="table">
            <thead>
            <th>学号</th>
            <th>姓名</th>
            <th>性别</th>
            <th>手机</th>
            <th>邮箱</th>
            <th>年级</th>
            <th>学院</th>
            <th>专业</th>
            <th>班级</th>
            <th>培养层次</th>
            <th>学习形式</th>
            <th>所在校区</th>
            </thead>
            <tbody>
            <tr ng-repeat="data in studatas">
                <td ng-bind="data.studentNum"></td>
                <td ng-bind="data.studentName"></td>
                <td ng-bind="data.studentGender"></td>
                <td ng-bind="data.studentPhone"></td>
                <td ng-bind="data.studentEmail"></td>
                <td ng-bind="data.studentGrade"></td>
                <td ng-bind="data.studentCollege"></td>
                <td ng-bind="data.studentMajor"></td>
                <td ng-bind="data.studentClass"></td>
                <td ng-bind="data.studentLevel"></td>
                <td ng-bind="data.studentForm"></td>
                <td ng-bind="data.studentSchoolAddress"></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
</body>
<script>
var app = angular.module('app',[]);
app.controller('ctrl',function  ($scope) {
    $scope.searchStr= {
        chineseName: "",
        courseCode: "",
        teacherName: "",
        tc_class: "",
        tc_teachway: "",
        tc_grade: ""
    };
    $scope.searchStu={
        studentNum:"",
        studentName:"",
        studentGrade:"",
        studentCollege:"",
        studentMajor:"",
        studentClass:"",
        studentSchoolAddress:""
    };
    var chineseName,courseCode,teacherName,tc_class,tc_teachway,tc_grade;
    var studentNum,studentName,studentGrade,studentCollege,studentMajor,studentClass,studentSchoolAddress;
    $scope.loadData=function () {
        loading();//加载
        chineseName=$scope.searchStr.chineseName;
        courseCode=$scope.searchStr.courseCode;
        teacherName=$scope.searchStr.teacherName;
        tc_class=$scope.searchStr.tc_class
        tc_teachway=$scope.searchStr.tc_teachway;
        tc_grade=$scope.searchStr.tc_grade;
        remotecall("checkClassList_load",{pageNum:pageNum,pageSize:pageSize,chineseName:chineseName,courseCode:courseCode,teacherName:teacherName,tc_class:tc_class,tc_teachway:tc_teachway,tc_grade:tc_grade},function (data) {
            closeLoading();//关闭加载层
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

            $scope.datas=data.rows;
            if(data.total==0){
                parent.pMsg("暂无数据");
                $(".pagingbox").hide();
            }else {
                $(".pagingbox").show();
            }
        },function (data) {
            $(".pagingbox").hide();
            closeLoading();//关闭加载层
            parent.pMsg("加载数据失败" );
            console.log(data);
        });
    };

    //查看该班级学生
    $scope.tcid={};
    var isSearch=false;
    $scope.loadDataStu=function (tr) {
        if(tr==0){
            tr=$scope.tcid;
            isSearch=true;
        }else{
            $scope.tcid=tr;
            isSearch=false;
        }
        studentNum=$scope.searchStu.studentNum;
        studentName=$scope.searchStu.studentName;
        studentGrade=$scope.searchStu.studentGrade;
        studentCollege=$scope.searchStu.studentCollege;
        studentMajor=$scope.searchStu.studentMajor;
        studentClass=$scope.searchStu.studentClass;
        studentSchoolAddress=$scope.searchStu.studentSchoolAddress;
        loading();
        remotecall("checkClassStu_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr,tc_id:tr.tc_id,studentNum:studentNum,studentName:studentName,studentGrade:studentGrade,
            studentCollege:studentCollege,studentMajor:studentMajor,studentClass:studentClass,studentSchoolAddress:studentSchoolAddress},function (data) {
            closeLoading();
            if(data.total==0){
                if (isSearch){
                    parent.pMsg("未找到搜索结果");
                }else {
                    parent.pMsg("该班级暂无学生报名");
                }
            }else {
                $(".pagingbox").show();
                $(".tablebox_class").hide();
                $(".tablebox_stu").show();
                $scope.studatas=data.rows;
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
            $scope.loadData();
        }
    };
//导出到信息到Excel
    $scope.btnExcel=function () {
        var url="../../export/exportClassStudentInfo.form?searchStr="
            +searchStr+"&tc_id="+$scope.tcid.tc_id+"&studentNum="+$scope.searchStu.studentNum+"&studentName="+$scope.searchStu.studentName
            +"&studentGrade="+$scope.searchStu.studentGrade+"&studentCollege="+$scope.searchStu.studentCollege+"&studentMajor="+$scope.searchStu.studentMajor+"&studentClass="+$scope.searchStu.studentClass
            +"&studentSchoolAddress="+$scope.searchStu.studentSchoolAddress;
        $("#exportTo").attr("action",url);
        $("#exportTo").submit();
    }
    //返回按钮
    $scope.goback=function () {
        $(".tablebox_stu").hide();
        $(".tablebox_class").show();
        $scope.searchCl= {
            chineseName: "",
            courseCode: "",
            teacherName: "",
            tc_class: "",
            tc_teachway: "",
            tc_grade: ""
        };
        $scope.searchStu={
            studentNum:"",
            studentName:"",
            studentGrade:"",
            studentCollege:"",
            studentMajor:"",
            studentClass:"",
            studentSchoolAddress:""
        };
    };

    //初始化时加载
    $scope.loadData();
});
</script>
</html>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
