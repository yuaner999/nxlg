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
    <style>
        .span_width{
            width: 90px;
            display:inline-block;
        }
        .title .tablesearchbtn {
            width: 130px;
            margin-left: 0px;
        }
        .forminput2{
            margin-right:12px !important;
            border: 1px solid #c5add7;
            height: 26px;
            width: 130px;
            padding: 0 0px;
        }
    </style>
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

    <span class="span_width">承担单位：</span>
    <select type="text" ng-model="collegeName" name="collegeName" class="forminput2"
            id="collegeName">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="college in colleges" value="{{college.wordbookValue}}"
                ng-bind="college.wordbookValue"></option>
    </select>
    <span class="span_width">课程代码：</span>
    <input class="tablesearchbtn" type="text" id="classCode" ng-model="courseCode" placeholder="请输入课程代码" />
    <span class="span_width">课程名称：</span>
    <input class="tablesearchbtn" type="text" id="className" ng-model="chineseName" placeholder="请输入中文名称" />
    <span class="span_width">英文名称：</span>
    <input class="tablesearchbtn" type="text" id="searchenglishName" ng-model="englishName" placeholder="请输入英文名称" />
    </div>
    <div class="title">
    <span class="span_width">课程类别三：</span>
    <select type="text" ng-model="courseCategory_3" name="courseCategory_3" class="forminput2"
            id="searchcourseCategory_3">
        <option value="">--请选择--</option>
        <option value="课程课">课程课</option>
        <option value="实践课">实践课</option>
    </select>
    <span class="span_width">课程类别四：</span>
    <select type="text" ng-model="courseCategory_4" name="courseCategory_4" class="forminput2"
            id="searchcourseCategory_4">
        <option value="">--请选择--</option>
        <option value="普通课">普通课</option>
        <option value="上机课">上机课</option>
        <option value="实验课">实验课</option>
        <option value="实训课">实训课</option>
        <option value="体育课">体育课</option>
        <option value="外语课">外语课</option>
    </select>
    <span class="span_width">课程类别五：</span>
    <select type="text" ng-model="courseCategory_5" name="courseCategory_5" class="forminput2"
            id="searchcourseCategory_5">
        <option value="">--请选择--</option>
        <option value="自然科学类">自然科学类</option>
        <option value="计算机科学类">计算机科学类</option>
        <option value="国际化类">国际化类</option>
    </select>
    </div>
<div class="title">
    <span class="span_width">学分：</span>
    <input class="tablesearchbtn" type="text" id="totalCredit" ng-model="totalCredit" placeholder="请输入学分" />
    <span class="span_width">学时：</span>
    <input class="tablesearchbtn" type="text" id="totalTime" ng-model="totalTime" placeholder="请输入学时" />
    <span ng-show="showInfo==1"  class="span_width">审核类别：</span>
    <select ng-show="showInfo==1"  type="text" ng-model="checktype" name="checktype" class="forminput2" id="checktype"/>
    <option value="">--请选择--</option>
    <option value="新增">新增</option>
    <option value="修改">修改</option>
    <option value="删除">删除</option>
    </select>
    <span ng-show="show=='2'" class="span_width">审核状态：</span>
    <select ng-show="show=='2'" type="text" ng-model="checkstatus" name="checkstatus" class="forminput2"
            id="checkstatus"/>
    <option value="">--请选择--</option>
    <option value="未通过">未通过</option>
    <option value="待写教材">待写教材</option>
    </select>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
    <table-btn ng-if="show==1"  ng-click="pass()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>通过</table-btn>
    <%--<table-btn ng-if="show==1"  ng-click="reject()"><img src="<%=request.getContextPath()%>/images/tablereject.png"/>拒绝</table-btn>--%>
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
        <th>英文名称</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th>学分</th>
        <th>学时</th>
        <th>承担单位</th>
        <th>负责教师</th>
        <th>教材</th>
        <th>课程状态</th>
        <th>审核类别</th>
        <th>审核状态</th>
        <th ng-if="show==2">未通过原因</th>
        <th ng-if="show==1">操作设置</th>
        </thead>
        <tbody>
        <tr ng-repeat="course in courses">
            <td ng-if="show==1"class="thischecked" ng-click="thischecked(course)">
                <input  type="checkbox" id="kind" ng-model="course.td0" name="courseIdSelect" value="{{course.courseId}}"/><%--ng-checked="all"--%>
            </td>
            <td ng-bind="course.courseCode"></td>
            <td ng-bind="course.chineseName"></td>
            <td ng-bind="course.englishName"></td>
            <td ng-bind="course.courseCategory_3"></td>
            <td ng-bind="course.courseCategory_4"></td>
            <td ng-bind="course.courseCategory_5"></td>
            <td ng-bind="course.totalCredit"></td>
            <td ng-bind="course.totalTime"></td>
            <td ng-bind="course.teachCollege"></td>
            <td ng-bind="course.teacherName"></td>
            <td ng-bind="course.name"></td>
            <td ng-bind="course.courseStatus"></td>
            <td ng-bind="course.checkType"></td>
            <td ng-bind="course.checkStatus"></td>
            <td ng-if="show==2" ng-bind="course.refuseReason" class="Ar" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"
                ng-click="ReasonDetail(course.refuseReason,$index)"></td>
            <td ng-if="show==1"><table-btn  ng-click="reject(course)">拒绝</table-btn></td>
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
    var oldsearchchecktype="";
    var oldsearchcheckstatus="";
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.show=1;
        $scope.showInfo=1;
//加载学院
        remotecall("studentManage_loadCollege", '', function (data) {
            $scope.colleges = data;
            loadCollege = true;
        }, function (data) {
            parent.pMsg("加载学院失败,或连接数据库失败！");
        });
        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadCourse();
        }

        //加载数据
        $scope.loadCourse = function () {
            if($scope.show==3){
            }else if($scope.show==1){
                oldsearchchecktype=$scope.checktype;
            }else if($scope.show==2){
                oldsearchchecktype=$scope.checktype;
                oldsearchcheckstatus=$scope.checkstatus;
            }
            console.log($scope.courseCategory_3);
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("courseCheck_loadCourse", {
                pageNum: pageNum,
                pageSize: pageSize,
                filter: filter,
                courseCode: $scope.courseCode,
                chineseName: $scope.chineseName,
                collegeName:$scope.collegeName,
                englishName:$scope.englishName,
                courseCategory_3:$scope.courseCategory_3,
                courseCategory_4:$scope.courseCategory_4,
                courseCategory_5:$scope.courseCategory_5,
                totalCredit:$scope.totalCredit,
                totalTime:$scope.totalTime,
                checkType: $scope.checktype,
                checkStatus: $scope.checkstatus
            }, function (data) {
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
                $scope.showInfo=1;
                $scope.checktype=oldsearchchecktype;
                $scope.checkstatus=oldsearchcheckstatus;

//                $scope.$watch('$viewContentLoaded', function() {
//                    $('.thischecked').hide();
//                    $('.checked').hide();
//                });
            }else if(str==0){
                $scope.showInfo=1;
                $scope.show=1;
                $scope.checktype=oldsearchchecktype;
                $scope.checkstatus="";
            }else if(str==1){
                $scope.show=3;
                $scope.showInfo=2;
                $scope.checktype="";
                $scope.checkstatus="";
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
        $scope.reject = function (course) {
            $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").show();
            $(".layui-layer-shade").hide();
            $scope.checkitem=course;
            layer.prompt({
                title: '未通过原因',
                formType: 2,
                value: ' ', //初始时的值，默认空字符
            }, function (value) {
                if (value) {
                    remotecallasync("course_reject",{courseId:$scope.checkitem.courseId,reason:value},function (data) {
                        if(data){
                            $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                            $scope.loadCourse();
                            $scope.dofilter(0);
                            $scope.$apply();
                        }else {
                            parent.pMsg("驳回原因不能为空");
                        }
                    },function (data) {
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                    return false;
                }
            });

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
            var _classCode = $("#classCode").val();
            var _className = $("#className").val();
            var url="../../export/exportNowCourse.form?_classCode="+_classCode+"&_className="+_className;
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
