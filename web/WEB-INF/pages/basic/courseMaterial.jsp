<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/17
  Time: 11:54
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
    <style>
        .span_width{
            width: 90px;
        }
        .row{
            padding-left: 252px !important;
        }
        .forminput{
            margin-right:80px !important;
        }
        .text-center{
            position: absolute;
            left:33%;
        }
        .btn{
            position: absolute;
            top: 185px;
            left: 45px;
            color: #f2f2f2;
            background: #c5add7;
        }
        .title .tablesearchbtn {
            margin-left: 0px;
            margin-right: 12px;
            width: 170px;
            vertical-align: middle;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：设置课程使用教材
<hr>
<div class="title">
    <span  class="span_width">课程代码：</span>
    <input  class="tablesearchbtn" type="text" ng-model="courseCode" placeholder="请输入关键字查询..."
           onkeyup="getSearchStr(this)"/>
    <span class="span_width">课程名称：</span>
    <input  class="tablesearchbtn" type="text" ng-model="chineseName" placeholder="请输入关键字查询..."
           onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th>课程代码</th>
        <th>中文名称</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th>学分</th>
        <th>学时</th>
        <th>负责教师</th>
        <%--<th>首选教材</th>--%>
        <%--<th>备用教材</th>--%>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="course in courses">
            <td ng-bind="course.courseCode"></td>
            <td ng-bind="course.chineseName"></td>
            <td ng-bind="course.courseCategory_3"></td>
            <td ng-bind="course.courseCategory_4"></td>
            <td ng-bind="course.courseCategory_5"></td>
            <td ng-bind="course.totalCredit"></td>
            <td ng-bind="course.totalTime"></td>
            <td ng-bind="course.teacherName"></td>
            <%--<td ng-bind="course.coursebookid"></td>--%>
            <%--<td ng-bind="course.sparecoursebookid"></td>--%>
            <td><table-btn ng-click="edit(course)">设置教材</table-btn></td>
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
<div class="table-addform container-fluid a-show">
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：设置课程使用教材 > 设置教材
    <hr>
    <form id="Form1">
        <div class="row">
            <br class="col-sm-3 col-xs-3">
            <li><span class="span_width">首选教材：</span>
                <select  ng-model="checkitem.coursebookid" name="coursebookid" class="forminput" id="coursebookid">
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in options" value="{{option.tmId}}" ng-bind="option.name"></option>
                </select>
            </li>
        </div>
        <div class="row">
            <br class="col-sm-3 col-xs-3">
            <li><span class="span_width">备用教材：</span>
                <select  ng-model="checkitem.coursebook" name="coursebook" class="forminput" id="coursebook">
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in options" value="{{option.tmId}}" ng-bind="option.name"></option>
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
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.checklist=[];
        $scope.checkitem={};
        $scope.loadDataFirst = function () {
            pageNum = 1;
            $scope.loadCourse();
        }
        //加载数据
        $scope.loadCourse = function () {
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("courseMaterial_loadCourse",{
                pageNum:pageNum,
                pageSize:pageSize,
                courseCode: $scope.courseCode,
                chineseName: $scope.chineseName
            },function (data) {
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
                $scope.all = false;
                for(i=0;i<$scope.courses.length;i++){
                    $scope.courses[i].td0=false;
                }
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("该用户没有课程信息");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            remotecall("courseMaterial_teachingmaterials",'',function (data) {
                $scope.options = data;
                closeLoading();//关闭加载层
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载教师失败");
            });
            $scope.checklist=[];
            $scope.checkitem={};
        };
        //首次加载课程
//        $('.table-addform').show();
        $scope.loadCourse();
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
        //修改
        $scope.edit= function (tr) {
            $scope.checklist.splice(0, 1,tr);
            $scope.checkitem=$scope.checklist[0];
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-addform').show();
            $('table,.pagingbox').hide();
        };
        //隐藏
        $scope.cancel=function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            },300);
            $('table,.title,.pagingbox').show();
            $scope.checklist=[];//清空选中
            $scope.checkitem={};
            $scope.all = false;
            $scope.loadCourse();
            for(i=0;i<$scope.courses.length;i++){
                $scope.courses[i].td0=false;
            }
        };
        //表单验证
        $("#Form1").validate({
            submitHandler:function(form){
                loading();
                if($scope.checkitem.coursebookid==""||$scope.checkitem.coursebookid==null||$scope.checkitem.coursebook==""||$scope.checkitem.coursebook==null)
                {
                    closeLoading();
                    parent.pMsg("首选教材、备用教材信息不能为空");
                    return;
                }
                closeLoading();
                if($("#coursebookid option:selected").text() == $("#coursebook option:selected").text()){
                    parent.pMsg("首选教材、备用教材信息不能相同");
                    return;
                }
                remotecallasync("courseMaterial_editcourse",$scope.checkitem,function (data) {
                    if(data){
                        closeLoading();
                        parent.pMsg("教材填写完毕，进入课程审核阶段");
                        $('.table-addform').hide();
                        $('table').show();
                        $scope.loadCourse();
                        $scope.$apply();
                    }else {
                        closeLoading();
                        parent.pMsg("教材填写失败");
                    }
                },function (data) {
                    closeLoading();
                    parent.pMsg("教材填写请求失败");
                });
            },
            rules:{
                coursebookid:{
                    required:true
                },
                coursebook:{
                    required:true
                }
            },
            messages:{
                coursebookid:{
                    required:"必填项"
                },
                coursebook:{
                    required:"必填项"
                }
            },
            //重写showErrors
            showErrors: function (errorMap, errorList) {
                var msg = "";
                $.each(errorList, function (i, v) {
                    //msg += (v.message + "\r\n");
                    //在此处用了layer的方法,显示效果更美观
                    layer.tips(v.message, v.element, { time: 2000 });
                    return false;
                });
            },
            onfocusout: false
        });
    });

    //绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#search").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
