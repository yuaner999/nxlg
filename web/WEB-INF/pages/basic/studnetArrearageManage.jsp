<%--
  Created by IntelliJ IDEA.
  User: gq
  Date: 2017/6/3
  Time: 13:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
    <style>
        #modal .mask {
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            background-color: #000;
            opacity: 0.5;
        }
        #modal {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            z-index: 999;
            display:none
        }
        #insert-form {
            z-index: 9999;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：欠费学生列表
<hr>
<div class="title">
    <span >学院名称：</span>
    <select  ng-model="para.collegeName" name="collegeName" class="forminput" id="collegeName" >
        <option value="" >--请选择--</option>
        <option ng-repeat="college in colleges" value="{{college.wordbookValue}}">{{college.wordbookValue}}</option>
    </select>
    <span >班级名称：</span>
    <select  ng-model="para.studentClass" name="studentClass" class="forminput" id="studentClass"  >
        <option value="" >--请选择--</option>
        <option ng-repeat="class in classes" value="{{class.className}}">{{class.className}}</option>
    </select>
    <span >学期名称：</span>
    <select  ng-model="para.semester" name="semester" class="forminput" id="semester"  >
        <option value="" >--请选择--</option>
        <option ng-repeat="semester in semesters" value="{{semester.semester}}">{{semester.semester}}</option>
    </select>
    <input class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入学生姓名进行查询..." onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th>学号</th>
        <th>姓名</th>
        <th>班级</th>
        <th>学院</th>
        <th>学期</th>
        <th>电话</th>
        <th>邮箱</th>
        <th>欠费数额</th>
        <th>缴费情况</th>
        </thead>
        <tbody>
        <tr ng-repeat="student in students">
            <td ng-bind="student.studentNum"></td>
            <td ng-bind="student.studentName"></td>
            <td ng-bind="student.studentClass"></td>
            <td ng-bind="student.studentCollege"></td>
            <td ng-bind="student.semester"></td>
            <td ng-bind="student.studentPhone"></td>
            <td ng-bind="student.studentEmail"></td>
            <td ng-bind="student.shouldPay"></td>
            <td ng-bind="student.status"></td>
        </tr>
        </tbody>
    </table>
</div>
<%--遮罩层--%>
<div id="modal">
    <div class="mask"></div>
</div>
<!--分页-->
<div class="pagingbox">
    <paging></paging>
</div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        var num=0;
        $scope.para={};
//        加载筛选条件下拉选
        remotecall("teacher_loadCoMaGrInfo",{},function (data) {
            $scope.classes = data.class;
            $scope.semesters = data.newsemester;
            $scope.colleges = data.college;
        },function (data) {
        });

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadStudent();
        }

        //加载数据
        $scope.loadStudent = function () {
            loading();//加载层
            $scope.students=[];
            $('#insert-form').hide();
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("studentPaymentManage_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr,
                college:$scope.para.collegeName,studentClass:$scope.para.studentClass,semester:$scope.para.semester},function (data) {
                closeLoading();
                if(!data.rows) data.rows=[];
                for (var j = 0; j < data.rows.length; j++) {
                    var obj = data.rows[j];
                    if(obj.status==='未缴费'){
                        $scope.students.push(obj);
                    }
                }
//                $scope.students = data.rows;//加载的数据对象，‘students’根据不同需求而变
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
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            $scope.checkitem={};
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
                $scope.loadStudent();
            }
        };
        $scope.insert=function () {
            $("#modal").show();
            $('#insert-form').show();

        };
        $scope.close=function () {
            $('#insert-form').hide();
            $("#modal").hide();
            $("#valid_result,#file").empty();

        };
        //首次加载
        $scope.loadStudent();
        $scope.checkitem={};


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