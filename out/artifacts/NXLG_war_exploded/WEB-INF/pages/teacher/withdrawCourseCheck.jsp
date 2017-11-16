<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/23
  Time: 19:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：退选审核
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <input class="tablesearchbtn" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadData()">搜索</table-btn>
</div>
<!--选修课程列表-->
<div class="tablebox" id="allInfo">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th>学号</th>
        <th>姓名</th>
        <th>课程代码</th>
        <th>课程名</th>
        <th>平台</th>
        <th>所在班级</th>
        <th>教师</th>
        <th>当前学期</th>
        <th>状态</th>
        <th>申请理由</th>
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
            <td ng-bind="data.scc_status"></td>
            <td ng-bind="data.Areason" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%" class="Ar"
                ng-click="ReasonDetail(data.Areason,$index)"></td>
            <td><table-btn ng-click="pass(data)">通过</table-btn>&nbsp;&nbsp;<table-btn ng-click="reject(data)">拒绝</table-btn></td>
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
        $scope.loadData = function (){
            loading();//加载
            remotecall("withdrawCourseCheck_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr}, function (data) {
                closeLoading();
                if(data==0){
                    parent.pMsg("该用户没有权限");
                }else if(data.total==0){
                    parent.pMsg("无退课数据");
                    $scope.datas={};
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

                //分页加载跳转到指定页

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
                        $scope.loadData();
                    }
                };
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
        }
        $scope.loadData();
        $scope.pass=function(tr){
            $scope.datalist.push(tr);
            $scope.dataitem = $scope.datalist[0];
            var scc=$scope.dataitem.scc;
            loading();
            remotecall("withdrawCourseCheck_pass",{studentId:$scope.dataitem.studentId,scc:scc},function (data) {
                closeLoading();//关闭加载层
                if(data==0){
                    parent.pMsg("该学生不是系统用户");
                }else if(data){
                    parent.pMsg("退课成功，已通知该学生");
                    $scope.loadData();
                    $scope.$apply();
                }else{
                    parent.pMsg("退课失败");
                }
            },function (data) {
                parent.pMsg("退课通过请求失败");
                closeLoading();//关闭加载层
            });
        }
        $scope.reject=function(tr){
            $scope.datalist.push(tr);
            $scope.dataitem = $scope.datalist[0];
            var scc=$scope.dataitem.scc;
            layer.prompt({
                title: '拒绝退课理由',
                formType: 2,
            }, function (str) {
                loading();
                remotecall("withdrawCourseCheck_reject",{studentId:$scope.dataitem.studentId,scc:scc,str:str},function (data) {
                    closeLoading();//关闭加载层
                    if(data==0){
                        parent.pMsg("该学生不是系统用户");
                    }else if(data){
                        parent.pMsg("退课拒绝，已通知该学生");
                        $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                        $scope.loadData();
                        $scope.$apply();

                    }else{
                        parent.pMsg("退课拒绝失败");
                    }
                },function (data) {
                    parent.pMsg("退选拒绝请求失败");
                    closeLoading();//关闭加载层
                });
            },function () {
            });
        }
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

    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>

