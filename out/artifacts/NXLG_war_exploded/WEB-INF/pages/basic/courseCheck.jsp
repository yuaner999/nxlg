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
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：课程审核
<hr>
<table-nav>
    <li ng-click="dofilter(0)" class="sele">待审核列表</li>
    <li ng-click="dofilter(1)">现有课程列表</li>
    <li ng-click="dofilter(2)" >其它课程列表</li>
</table-nav>
<div class="title">
    <table-btn ng-if="show==1"  ng-click="pass()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>通过</table-btn>
    <table-btn ng-if="show==1"  ng-click="reject()"><img src="<%=request.getContextPath()%>/images/tablereject.png"/>拒绝</table-btn>
    <input class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadCourse()">搜索</table-btn>
    <table-btn ng-if="show==3" ng-click="btnExcel()">导出到Excel</table-btn>
    <form id="export_fm" method="post" hidden></form>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th ng-if="show==1" class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
        <th>课程代码</th>
        <th>中文名称</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th>学分</th>
        <th>学时</th>
        <th>负责教师</th>
        <th>教材</th>
        <th>课程状态</th>
        <th>审核类别</th>
        <th>审核状态</th>
        <th ng-if="show==2">未通过原因</th>
        </thead>
        <tbody>
        <tr ng-repeat="course in courses">
            <td ng-if="show==1"class="thischecked" ng-click="thischecked(course)">
                <input  type="checkbox" id="kind" ng-model="course.td0" name="courseIdSelect" value="{{course.courseId}}"/><%--ng-checked="all"--%>
            </td>
            <td ng-bind="course.courseCode"></td>
            <td ng-bind="course.chineseName"></td>
            <td ng-bind="course.courseCategory_3"></td>
            <td ng-bind="course.courseCategory_4"></td>
            <td ng-bind="course.courseCategory_5"></td>
            <td ng-bind="course.totalCredit"></td>
            <td ng-bind="course.totalTime"></td>
            <td ng-bind="course.teacherName"></td>
            <td ng-bind="course.name"></td>
            <td ng-bind="course.courseStatus"></td>
            <td ng-bind="course.checkType"></td>
            <td ng-bind="course.checkStatus"></td>
            <td ng-if="show==2" ng-bind="course.refuseReason" class="Ar" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"
                ng-click="ReasonDetail(course.refuseReason,$index)"></td>
        </tr>
        </tbody>
    </table>
</div>
<!--分页-->
<div class="pagingbox">
    <paging></paging>
</div>
<!--新建表单-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
</body>
</html>
<script>
    var load_all=true;
    var num=0;
    var filter=0;
    var str = '';
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.show=1;
        //加载数据
        $scope.loadCourse = function () {
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("courseCheck_loadCourse",{pageNum:pageNum,pageSize:pageSize,filter:filter,searchStr:searchStr},function (data) {
                closeLoading();//关闭加载层
                $scope.courses = data.rows;//加载的数据对象，‘courses’根据不同需求而变
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
                num=0;
                $scope.all = false;
                for(i=0;i<$scope.courses.length;i++){
                    $scope.courses[i].td0=false;
                }
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
                if(load_all){
                    pageNum = pn;//改变当前页
                    //重新加载用户信息
                    $scope.loadCourse();
                }
                else{
                    pageNum = pn;//改变当前页
                    //重新加载用户信息
                    $scope.loadCourse();
                }
            }
        };
        $scope.dofilter=function(str){
            pageNum=1;
            $scope.show="";
            if(str==2){
                $scope.show=2;
//                $scope.$watch('$viewContentLoaded', function() {
//                    $('.thischecked').hide();
//                    $('.checked').hide();
//                });
            }else if(str==0){
                $scope.show=1;
            }else if(str==1){
                $scope.show=3;
//                $scope.$watch('$viewContentLoaded', function() {
//                    $('.thischecked').hide();
//                    $('.checked').hide();
//                });
            }
            filter = str;
            $scope.loadCourse();
        }

        //审核通过
        $scope.pass = function () {
            var checknum=$scope.checklist.length;;
            if(checknum<1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else{
                parent.pConfirm("确认通过选中的所有内容吗？",function () {
                    remotecallasync("course_pass",{passIds:$scope.checklist},function (data) {
                        if(data){
                            parent.pMsg("审核通过");
                            //重新加载菜单
                            $scope.dofilter(0);
                            $scope.loadCourse();
                            $scope.$apply();
                        }else {
                            parent.pMsg("审核不通过");
                        }
                    },function (data) {
                        parent.pMsg("审核请求失败");
                        console.log(data);
                    });
                },function () {});
            }
        };


        //审核拒绝
        $scope.reject = function () {
            var checknum=$scope.checklist.length;
            if(checknum!=1) {
                parent.pMsg("只能选择一条记录");
                return;
            }
            else{
                $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").show();
                $(".layui-layer-shade").hide();
                $scope.checkitem=$scope.checklist[0];
                layer.prompt({
                    title: '未通过原因',
                    formType: 2,
                }, function (str) {
                    if (str) {
                        remotecallasync("course_reject",{courseId:$scope.checkitem.courseId,reason:str},function (data) {
                            if(data){
                                $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                                $scope.loadCourse();
                                $scope.dofilter(0);
                                $scope.$apply();
                            }else {
                                parent.pMsg("添加失败");
                            }
                        },function (data) {
                            parent.pMsg("数据库请求失败");
                            console.log(data);
                        });
                        return false;
                    }
                });
            }
        };

        //首次加载课程
        $scope.loadCourse();
        //checked 复选框判断
        $scope.all = false;
        $scope.checklist=[];
        $scope.checkitem={};
        $scope.allfn = function  () {
            if($scope.all == false){
                $scope.all =true;
                for(i=0;i<$scope.courses.length;i++){
                    $scope.courses[i].td0=true;
                    $scope.checklist.push($scope.courses[i]);
                }
                num=$scope.courses.length;
            }else{
                $scope.all =false;
                for(i=0;i<$scope.courses.length;i++){
                    $scope.courses[i].td0=false
                }
                $scope.checklist=[];
                $scope.checkitem={};
                num=0;
            }
        };
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.checklist.push(tr);
            }else{
                num--;
                tr.td0 = false;
                $scope.all=false;
                var index = $scope.checklist.indexOf(tr);
                if (index > -1) {
                    $scope.checklist.splice(index, 1);
                }
            }
            if(num==$scope.courses.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        //理由详情
        $scope.ReasonDetail=function(data,i){
            if(data==null||data==""||data.length<=5)return;
            $(".Ar:eq("+i+")").addClass("RRR");
            layer.tips(data,".RRR" ,{
                tips: [4, '#c5add7'],
                time: 3000
            });
            $(".Ar:eq("+i+")").removeClass("RRR");
        }

        //导出到课程信息到Excel
        $scope.btnExcel=function () {
            var url="../../export/exportNowCourse.form?searchStr="+searchStr;
            $("#export_fm").attr("action",url);
            $("#export_fm").submit();

        }
    });

    //绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchkey").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
