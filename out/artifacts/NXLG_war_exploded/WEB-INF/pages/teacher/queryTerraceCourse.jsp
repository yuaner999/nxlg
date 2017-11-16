<%--
  Created by IntelliJ IDEA.
  User: gq
  Date: 2017/6/6
  Time: 20:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <%--打印课表的js插件--%>
    <script src="<%=request.getContextPath()%>/js/explore_tabexcle/jquery-migrate-1.2.1.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/explore_tabexcle/jquery.jqprint-0.3.js"></script>
</head>
<style>
    <%--查看详情--%>
    .table-score{
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
    .scorecol{
        margin-left:10px;
    }
    .scorecol li{
        margin-bottom:5px;
    }
    .scorecol li span{
        margin-right:5px;
        width:230px;
        display: inline-block;
    }
    .bttn{
        margin-left: 26%;
        margin-top:30px;
        border: 1px solid #c5add7;
        height: 26px;
        background: #edeaf1;
    }
    .show ul{
        width: 30%;
        padding-left: 40px;
        margin-left: 100px;
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
    .show li>span:first-child,.tips li>span:first-child{
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
        filter: alpha(opacity= 0.5);
        z-index: 9;
        display: none;
    }
    .tips ul{
        float:left;
        margin:20px 0px 10px 30px;
    }
    .sel{
        margin-left:-5px;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：查看开课课程
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <span>学院名称：</span>
    <select  ng-model="para.collegeName" name="collegeName" class="forminput" id="collegeName" ng-change="changeCollege(para.collegeName)">
        <option value="" >--请选择--</option>
        <option ng-repeat="college in colleges" value="{{college.wordbookValue}}">{{college.wordbookValue}}</option>
    </select>
    <span>专业名称：</span>
    <select  ng-model="para.majorName" name="majorName" class="forminput" id="majorName" >
        <option value="" >--请选择--</option>
        <option ng-repeat="major in newMajors" value="{{major.majorId}}">{{major.majorName}}</option>
    </select>

    <span style="margin-left: 20px">平台名称：</span>
    <select  ng-model="para.terraceName" name="terraceName" class="forminput" id="terraceName" >
        <option value="" >--请选择--</option>
        <option ng-repeat="terrace in terraces" value="{{terrace.terraceId}}">{{terrace.terraceName}}</option>
    </select>

    <span style="margin-left: 20px">学期：</span>
    <select  ng-model="para.termName" name="termName" class="forminput" id="termName" >
        <option ng-repeat="semester in semesters" value="{{semester.semester}}">{{semester.semester}}</option>
    </select>

    <%--<input  class="tablesearchbtn" ng-model="para.termName" name="termName" class="forminput" id="termName" placeholder="请输入想要搜索的学期名称"/>--%>
    <table-btn id="search" ng-click="loadData(1)">搜索</table-btn>
    <table-btn class="top_1" ng-click="btnExcel()">导出到Excel</table-btn>
    <%--<table-btn style="width: 100px;margin-left: 20px;" onclick="exploretable()">打印课表</table-btn>--%>
    <form class="top_1" method="post" id="exportTo" hidden></form>
    <%--<table-btn class="top" ng-click="delete()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>--%>
</div>
<!--平台课程列表-->
<div class="tablebox" id="allInfo">
    <table class="table">
        <thead>
        <th>学院</th>
        <th>专业</th>
        <th>培养层次</th>
        <th>平台</th>
        <th>课程</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th>开课学期</th>
        <th>主修/辅修</th>
        <th>备注</th>
        <th>审核状态</th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-bind="Info.majorCollege"></td>
            <td ng-bind="Info.majorName"></td>
            <td ng-bind="Info.level"></td>
            <td ng-bind="Info.terraceName"></td>
            <td ng-bind="Info.chineseName"></td>
            <td ng-bind="Info.courseCategory_3"></td>
            <td ng-bind="Info.courseCategory_4"></td>
            <td ng-bind="Info.courseCategory_5"></td>
            <td ng-bind="Info.mtc_courseTerm"></td>
            <td ng-bind="Info.mtc_majorWay"></td>
            <td ng-bind="Info.mtc_note"></td>
            <td ng-bind="Info.mtc_checkStatus"></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
<div class="black"></div>
</body>
</html>
<script>
    var add_edit=true;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载下拉选项
        $scope.para={
            collegeName:"",
            majorName:"",
            terraceName:"",
            termName:""
        };
        remotecall("teacher_loadCoMaGrInfo",{},function (data) {
            $scope.colleges=data.college;
            $scope.majors=data.major;
            $scope.newMajors=data.major;
            $scope.grades=data.grade;
            $scope.classes=data.class;
            $scope.newClasses=data.class;
            $scope.para.termName=data.semNow[0].semester;
            $scope.semesters=data.newsemester;
            $scope.terraces=data.terrace;
        },function (data) {});


        //加载数据
        $scope.loadData = function (tr) {
            if(tr==1){
                $scope.gotoPage(1,0);
            }
            loading();//加载
            remotecallasync("queryTerraceCourse_load", {collegeName:$scope.para.collegeName,majorName:$scope.para.majorName,terraceName:$scope.para.terraceName,
                termName:$scope.para.termName,pageNum: pageNum,pageSize: pageSize,searchStr:searchStr }, function (data) {
                closeLoading();//关闭加载层
                if (data.result == false) {
                    showmsgpc(data.errormessage);
                    return;
                }
                $scope.allInfo = data.rows;
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

                $scope.$apply();

                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        }

        $scope.loadData();
        //学院下拉选 change事件
        $scope.changeCollege=function (college){
            var newMajors=[];
            for (var i = 0; i < $scope.majors.length; i++) {
                var obj = $scope.majors[i];
                if(obj.majorCollege==college){
                    newMajors.push(obj)
                }
            }
            $scope.newMajors=newMajors;
        };
        //右侧菜单栏
        $scope.dofilter=function(str){
            if(str==0){//审核列表
                $scope.Var=true;
            }else if(str==1){
                $scope.Var=false;
            }
            filter = str;
            $scope.loadData();
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
                $scope.loadData();
            }
        };
        //导出Excel
        $scope.btnExcel=function () {
            var url="../../export/exportqueryTerraceCourse.form?collegeName="+$scope.para.collegeName+"&majorName="+$scope.para.majorName
                +"&terraceName="+$scope.para.terraceName+"&termName="+$scope.para.termName;
            $("#exportTo").attr("action",url);
            $("#exportTo").submit();
        }
    });
    var exploretable=function () {
        $("#allInfo").jqprint();
    }
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>