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
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
    <style>
        .span_width{
            width: 90px;
        }
        .forminput_gray{
            border:1px solid gray;
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
        .resultlesson{
            display: none;
        }
        .resulttitle{
            display: none;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：辅助排课
<hr>
<div class="title">
    <input class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadeducateTask()">搜索</table-btn>
    <form class="top_1" method="post" hidden></form>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th>课程名</th>
        <th>所分班级</th>
        <th>班级教师</th>
        <th>人数范围</th>
        <th>授课方式</th>
        <th>授课周时</th>
        <th>单双周</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="teachtask in teachtasks">
            <td ng-bind="teachtask.chineseName"></td>
            <td ng-bind="teachtask.tc_class"></td>
            <td ng-bind="teachtask.teacherName"></td>
            <td ng-bind="teachtask.tc_numrange"></td>
            <td ng-bind="teachtask.tc_teachway"></td>
            <td><span ng-bind="teachtask.tc_thweek_start"></span>至<span ng-bind="teachtask.tc_thweek_end"></span>周</td>
            <td ng-bind="teachtask.tc_teachodd"></td>
            <td><table-btn ng-click="arrange(teachtask)">排课</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<!--分页-->
<div class="pagingbox">
    <paging></paging>
</div>

<%--点击排课时，显示新建和搜索按钮--%>
<div class="resulttitle title">
    <table-btn class="top_1" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" />新建</table-btn>
    <form class="top_1" method="post" hidden></form>
    <table-btn ng-click="goback()">返回</table-btn>
</div>
<%--每门课程的上课时间和地点--%>
<div class="resultlesson">
    <table class="table">
        <thead>
        <th>课程名</th>
        <th>所分班级</th>
        <th>班级教师</th>
        <th>人数范围</th>
        <th>授课方式</th>
        <th>授课学期</th>
        <th>授课周时</th>
        <th>单双周</th>
        <th>上课地点</th>
        <th>上课日期</th>
        <th>上课时间</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="resultlesson in resultlessons | orderBy:resultlesson.al_timeweek:'desc'">
            <td ng-bind="arrangeitem.chineseName"></td>
            <td ng-bind="arrangeitem.tc_class"></td>
            <td ng-bind="arrangeitem.teacherName"></td>
            <td ng-bind="arrangeitem.tc_numrange"></td>
            <td ng-bind="arrangeitem.tc_teachway"></td>
            <td ng-bind="resultlesson.semester"></td>
            <td><span ng-bind="arrangeitem.tc_thweek_start"></span>至<span ng-bind="arrangeitem.tc_thweek_end"></span>周</td>
            <td ng-bind="arrangeitem.tc_teachodd"></td>
            <td ng-bind="resultlesson.classroomName"></td>
            <td ng-switch="resultlesson.al_timeweek">
                <span ng-switch-when="1">星期一</span>
                <span ng-switch-when="2">星期二</span>
                <span ng-switch-when="3">星期三</span>
                <span ng-switch-when="4">星期四</span>
                <span ng-switch-when="5">星期五</span>
                <span ng-switch-when="6">星期六</span>
                <span ng-switch-when="7">星期天</span>
            </td>
            <td ng-switch="resultlesson.al_timepitch">
                <span ng-switch-when="1">第一节</span>
                <span ng-switch-when="2">第二节</span>
                <span ng-switch-when="3">第三节</span>
                <span ng-switch-when="4">第四节</span>
                <span ng-switch-when="5">第五节</span>
                <span ng-switch-when="6">第六节</span>
                <span ng-switch-when="7">第七节</span>
                <span ng-switch-when="8">第八节</span>
                <span ng-switch-when="9">第九节</span>
                <span ng-switch-when="10">第十节</span>
            </td>
            <td>
                <table-btn ng-click="edit(resultlesson)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="delete(resultlesson)">删除</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>

<%--添加或者修改--%>
<div class="table-addform container-fluid a-show">
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：辅助排课 > 修改
    <hr>
    <form id="Form">
        <div class="row">
            <br class="col-sm-3 col-xs-3">
            <li style="display: none"><span class="span_width">al_Id：</span><input type="text" ng-model="editresultlesson.al_Id" name="al_Id" class="forminput forminput_gray" id="al_Id"/></li>
            <li style="display: none"><span class="span_width">课程ID：</span><input type="text" ng-model="arrangeitem.courseId" name="courseId" class="forminput forminput_gray" id="courseId"/></li>
            <li style="display: none"><span class="span_width">班级课程ID：</span><input type="text" ng-model="arrangeitem.tc_id" name="tc_id" class="forminput forminput_gray" id="tc_id"/></li>
            <li style="display: none"><span class="span_width">学期ID：</span><input type="text" ng-model="semesterNow.acId" name="acId" class="forminput forminput_gray" id="acId"/></li>
            <li><span class="span_width">课程名：</span><span ng-bind="arrangeitem.chineseName"  name="chineseName" class="forminput forminput_gray" id="chineseName"></span></li>
            <li><span class="span_width">所分班级：</span><span ng-bind="arrangeitem.tc_class" name="tc_class" class="forminput forminput_gray" id="tc_class"></span></li>
            <li><span class="span_width">班级教师：</span><span ng-bind="arrangeitem.teacherName" name="teacherName1" class="forminput forminput_gray" id="teacherName1"></span></li>
            <li><span class="span_width">人数范围：</span><span ng-bind="arrangeitem.tc_numrange" name="tc_numrange" class="forminput forminput_gray" id="tc_numrange"></span></li>
            <li><span class="span_width">授课方式：</span><span ng-bind="arrangeitem.tc_teachway" name="tc_teachway" class="forminput forminput_gray" id="tc_teachway"></span></li>
            <li><span class="span_width">授课学期：</span><span ng-bind="semesterNow.semester" name="semester" class="forminput forminput_gray" id="semester"></span></li>
            <li><span class="span_width">授课周时：</span><span class="forminput forminput_gray"><font ng-bind="arrangeitem.tc_thweek_start" name="tc_thweek_start" id="tc_thweek_start"></font>至<font ng-bind="arrangeitem.tc_thweek_end" name="tc_thweek_end" id="tc_thweek_end"></font>周</span></li>
            <li><span class="span_width">单双周：</span><span ng-bind="arrangeitem.tc_teachodd" name="tc_teachodd" class="forminput forminput_gray" id="tc_teachodd"></span></li>
            <li>
                <span class="span_width">选择教室：</span>
                <select type="text" ng-model="editresultlesson.classroomId" name="classroomId" class="forminput" id="classroomId"/>
                <option value="">--请选择--</option>
                <option ng-repeat="usingClassRoom in usingClassRooms" value="{{usingClassRoom.classroomId}}">{{usingClassRoom.classroomName}}</option>
                </select>
            </li>
            <li>
                <span class="span_width">上课日期：</span>
                <select type="text" ng-model="editresultlesson.al_timeweek" name="al_timeweek" class="forminput" id="al_timeweek"/>
                <option value="">--请选择--</option>
                <option value="1">星期一</option>
                <option value="2">星期二</option>
                <option value="3">星期三</option>
                <option value="4">星期四</option>
                <option value="5">星期五</option>
                <option value="6">星期六</option>
                <option value="7">星期天</option>
                </select>
            </li>
            <li>
                <span class="span_width">排课节次：</span>
                <select type="text" ng-model="editresultlesson.al_timepitch" name="al_timepitch" class="forminput" id="al_timepitch"/>
                <option value="">--请选择--</option>
                <option value="1">第一节</option>
                <option value="2">第二节</option>
                <option value="3">第三节</option>
                <option value="4">第四节</option>
                <option value="5">第五节</option>
                </select>
            </li>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel(arrangeitem)">取消</span>
        </div>
    </form>
</div>
</body>
</html>
<script>
    var add_edit=false;
    var load_all=false;
    var num=0;
    var resultLessons=new Array();//判断该课程在该时间段是否已经上课时需要
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.arrangeitem={};//存储要新建或修改排课的课程的信息
        //加载初始数据
        $scope.loadeducateTask=function () {
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("CourseArrEducateTask_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                closeLoading();//关闭加载层
                $scope.teachtasks = data.rows;//加载的数据对象，‘courses’根据不同需求而变
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
                for(i=0;i<$scope.teachtasks.length;i++){
                    $scope.teachtasks[i].td0=false;
                }
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无课程");
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
                    $scope.loadeducateTask();
                }
                else{
                    pageNum = pn;//改变当前页
                    //重新加载用户信息
                    $scope.loadeducateTask();
                }
            }
        };

        //加载使用中的教室
        $scope.loadUsingClassRoom = function () {
            loading();//加载
            remotecall("classroom_load",'',function (data) {
                if(data){
                    $scope.usingClassRooms=[];
                    $scope.usingClassRooms = data;
                    closeLoading();//关闭加载层
                }else if(data.total==0){
                    closeLoading();//关闭加载层
                    parent.pMsg("暂无可使用教室");
                }else{
                    closeLoading();//关闭加载层
                    parent.pMsg("加载教室失败");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载教室失败" );
                console.log(data);
            });
        };

        //“排课”功能
        $scope.arrange=function (tr) {
            loading();//加载
            $(".tablebox").hide();
            $(".pagingbox").hide();
            $(".resultlesson").show();
            $(".resultlesson").addClass("a-show");
            $(".title").hide();
            $(".resulttitle").show();
            $(".resulttitle").addClass("a-show");

            $scope.loadUsingClassRoom();

            if(tr.chineseName){
                $scope.arrangeitem=tr;
            }

            remotecall("subsidiaryCourseArrangement_load",tr,function (data) {
                closeLoading();//关闭加载层
                $scope.resultlessons = data.rows;//加载的数据对象，‘courses’根据不同需求而变
                resultLessons=$scope.resultlessons;
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("该课程暂时未排课");

                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
        };

        /*新建*/
        $scope.add=function () {
            $scope.editresultlesson={};
            $scope.semesterNow={};
            add_edit=true;
            loading();//加载层
            $(".resultlesson").hide();
            $(".resultlesson").addClass("a-hide");
            $(".table-addform").show();
            $(".table-addform").addClass("a-show");

            remotecall("subsidiaryCourseArrangement_query_semester","",function (data) {
                if(data.length!=0){
                    $scope.semesterNow=data[0];//存储得到的当前的学期数据
                    closeLoading();//关闭加载层
                }else {
                    parent.pMsg("没有得到当前学期");
                    closeLoading();//关闭加载层
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });

        }

        //修改操作
        $scope.edit=function (tr) {
            add_edit=false;
            $(".resultlesson").hide();
            $(".resultlesson").addClass("a-hide");
            $(".resulttitle").hide();
            $(".resulttitle").addClass("a-hide");
            $(".table-addform").show();
            $(".table-addform").addClass("a-show");

            $scope.editresultlesson={};
            $scope.checklist.splice(0, 1,tr);
            $scope.editresultlesson=$scope.checklist[0];

            remotecall("subsidiaryCourseArrangement_query_semester","",function (data) {
                if(data.length!=0){
                    $scope.semesterNow=data[0];//存储得到的当前的学期数据
                    closeLoading();//关闭加载层
                }else {
                    parent.pMsg("没有得到当前学期");
                    closeLoading();//关闭加载层
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });

        }

        //点击取消按钮
        $scope.cancel=function (tr) {
            $(".table-addform").removeClass("a-show");
            $(".table-addform").hide();
            $(".table-addform").addClass("a-hide");

            $(".resulttitle").removeClass("a-hide");
            $(".resulttitle").show();
            $(".resulttitle").addClass("a-show");

            $(".resultlesson").removeClass("a-hide")
            $(".resultlesson").show();
            $(".resultlesson").addClass("a-show");

            $scope.arrange(tr);
        };

        //返回按钮
        $scope.goback=function () {
            $(".tablebox").show();
            $(".tablebox").addClass("a-show");
            $(".pagingbox").show();
            $(".pagingbox").addClass("a-show");
            $(".resultlesson").hide();
            $(".resultlesson").removeClass("a-show");
            $(".title").show();
            $(".title").addClass("a-show");
            $(".resulttitle").hide();
            $(".resulttitle").removeClass("a-show");
            $scope.loadeducateTask();
        };

        //删除操作
        $scope.delete=function (tr) {
            parent.pConfirm("确认删除选中的课程吗？",function () {
                remotecall("subsidiaryCourseArrangement_del",tr,function (data) {
                    if(data){
                        parent.pMsg("删除成功");
                        $scope.arrange($scope.arrangeitem);
                        $scope.$apply();
                    }else {
                        parent.pMsg("删除失败");
                    }
                });
            },function () {});
        }

        //批量删除
        $scope.deletes=function () {

        }

        //表单验证
        $("#Form").validate({
            submitHandler:function(form){
                //验证通过,然后就保存
                if(add_edit){//如果是添加
                    var parames = $("#Form").serializeObject();//参数
                    var isUsroom=true;
                    var isTeaching=true;
                    var isExitTime=true;
                    var addCourse = Object.assign($scope.arrangeitem,parames);
                    //判断该教室是否有课
                    remotecall("subsidiaryCourseArrangement_query_classroom",parames,function (data) {
                        $scope.classRoomItems=data;
                        for(var i=0;i<$scope.classRoomItems.length;i++){
                            if($scope.classRoomItems[i].al_timepitch==parames.al_timepitch&&$scope.classRoomItems[i].al_timeweek==parames.al_timeweek){
                                if($scope.classRoomItems[i].tc_thweek_start>$scope.arrangeitem.tc_thweek_end||$scope.classRoomItems[i].tc_thweek_end<$scope.arrangeitem.tc_thweek_start){
                                    isUsroom=true;
                                }else {
                                    isUsroom=false;
                                }
                            }
                        }
                    },function (data) {
                        parent.pMsg("加载该教室信息失败");
                    });
                    //判断该教师是否有课
                    remotecall("subsidiaryCourseArrangement_query_teacher",$scope.arrangeitem,function (data) {
                        $scope.teacherTimeItems=data;
                        for (var i=0;i<$scope.teacherTimeItems.length;i++){
                            if($scope.teacherTimeItems[i].al_timepitch==parames.al_timepitch&&$scope.teacherTimeItems[i].al_timeweek==parames.al_timeweek){
                                if($scope.teacherTimeItems[i].tc_thweek_start>$scope.arrangeitem.tc_thweek_end||$scope.teacherTimeItems[i].tc_thweek_end<$scope.arrangeitem.tc_thweek_start){
                                    isTeaching=true;
                                }else {
                                    isTeaching=false;
                                }
                            }
                        }
                    },function (data) {
                        parent.pMsg("加载教师信息失败");
                    });
                    //判断该课程是否有课
                    remotecall("subsidiaryCourseArrangement_query_time",parames,function (data) {
                        $scope.classClassItems=data;
                        if($scope.classClassItems.length==0){
                            isExitTime=true;
                        }else{
                            for(var i=0;i<$scope.classClassItems.length;i++){
                                if($scope.classClassItems[i].al_timepitch==parames.al_timepitch&&$scope.classClassItems[i].al_timeweek==parames.al_timeweek){
                                    isExitTime=false;
                                }
                            }
                        }
                    },function (data) {
                        parent.pMsg("加载该课程信息失败");
                    });
                    if(isUsroom&&isTeaching&&isExitTime){
                        for(var i=0;i<$scope.usingClassRooms.length;i++){
                            if($scope.usingClassRooms[i].classroomId==addCourse.classroomId){
                                addCourse=Object.assign(addCourse, $scope.usingClassRooms[i]);
                            }
                        }
                        remotecallasync("subsidiaryCourseArrangement_add",addCourse,function(data) {
                            if(data){
                                parent.pMsg("添加成功");
                                closeLoading();//关闭加载层
                                //重新加载
                                $('.table-addform').hide();
                                $('.resultlesson').show();
                                $('#Form input').text("");
                                $scope.arrange(parames);
                                $scope.$apply();
                            }else {
                                parent.pMsg("添加失败");
                                closeLoading();//关闭加载层
                            }
                        },function (data) {
                            parent.pMsg("数据库请求失败");
                            closeLoading();//关闭加载层
                        });
                    }else{
                        if(!isUsroom){
                            parent.pMsg("该教室已被占用");
                        }
                        if(!isTeaching){
                            parent.pMsg("该教师在该时间段已经上课");
                        }
                        if(!isExitTime){
                            parent.pMsg("该时间段该课程已经在上课");
                        }
                    }
                }else{//修改
                    var parames = $("#Form").serializeObject();//参数
                    var isUsroom=true;
                    var isTeaching=true;
                    var isExitTime=true;
                    var addCourse = Object.assign($scope.arrangeitem,parames);//要添加的信息
                    //判断该教室是否有课
                    remotecall("subsidiaryCourseArrangement_query_classroom",parames,function (data) {
                        $scope.classRoomItems=data;
                        for(var i=0;i<$scope.classRoomItems.length;i++){
                            if(parames.al_Id!=$scope.classRoomItems[i].al_Id&&$scope.classRoomItems[i].al_timepitch==parames.al_timepitch&&$scope.classRoomItems[i].al_timeweek==parames.al_timeweek){
                                if($scope.classRoomItems[i].tc_thweek_start>$scope.arrangeitem.tc_thweek_end||$scope.classRoomItems[i].tc_thweek_end<$scope.arrangeitem.tc_thweek_start){
                                    isUsroom=true;
                                }else {
                                    isUsroom=false;
                                }
                            }
                        }
                    },function (data) {
                        parent.pMsg("加载该教室信息失败");
                    });
                    //判断该教师是否有课
                    remotecall("subsidiaryCourseArrangement_query_teacher",$scope.arrangeitem,function (data) {
                        $scope.teacherTimeItems=data;
                        for (var i=0;i<$scope.teacherTimeItems.length;i++){
                            if(parames.al_Id!=$scope.teacherTimeItems[i].al_Id&&$scope.teacherTimeItems[i].al_timepitch==parames.al_timepitch&&$scope.teacherTimeItems[i].al_timeweek==parames.al_timeweek){
                                if($scope.teacherTimeItems[i].tc_thweek_start>$scope.arrangeitem.tc_thweek_end||$scope.teacherTimeItems[i].tc_thweek_end<$scope.arrangeitem.tc_thweek_start){
                                    isTeaching=true;
                                }else {
                                    isTeaching=false;
                                }
                            }
                        }
                    },function (data) {
                        parent.pMsg("加载教师信息失败");
                    });
                    //判断该课程是否有课
                    remotecall("subsidiaryCourseArrangement_query_time",parames,function (data) {
                        $scope.classClassItems=data;
                        for(var i=0;i<$scope.classClassItems.length;i++){
                            if(parames.classroomId==$scope.classClassItems[i].classroomId&&$scope.classClassItems[i].al_timepitch==parames.al_timepitch&&$scope.classClassItems[i].al_timeweek==parames.al_timeweek){
                                isExitTime=false;
                            }
                        }
                    },function (data) {
                        parent.pMsg("加载该课程信息失败");
                    });
                    if(isUsroom&&isTeaching&&isExitTime){
                        for(var i=0;i<$scope.usingClassRooms.length;i++){
                            if($scope.usingClassRooms[i].classroomId==addCourse.classroomId){
                                addCourse=Object.assign(addCourse, $scope.usingClassRooms[i]);
                            }
                        }
                        remotecallasync("subsidiaryCourseArrangement_edit",addCourse,function (data) {
                            if(data){
                                parent.pMsg("修改成功");
                                //重新加载信息
                                $(".table-addform").removeClass("a-show");
                                $(".table-addform").hide();
                                $(".table-addform").addClass("a-hide");

                                $(".resulttitle").removeClass("a-hide");
                                $(".resulttitle").show();
                                $(".resulttitle").addClass("a-show");

                                $(".resultlesson").removeClass("a-hide")
                                $(".resultlesson").show();
                                $(".resultlesson").addClass("a-show");
                                $scope.arrange(parames);
                                $scope.$apply();
                            }else {
                                parent.pMsg("修改失败");
                                closeLoading();//关闭加载层
                            }
                        },function (data) {
                            parent.pMsg("数据库请求失败");
                            console.log(data);
                        });
                    }else{
                        if(!isUsroom){
                            parent.pMsg("该教室已被占用");
                        }
                        if(!isTeaching){
                            parent.pMsg("该教师在该时间段已经上课");
                        }
                        if(!isExitTime){
                            parent.pMsg("该时间段该课程已经在上课");
                        }
                    }
                }
            },
            rules:{
                classroomId:{
                    required:true,
                    maxlength:45
                },
                al_timeweek:{
                    required:true,
                    maxlength:45
                },
                al_timepitch:{
                    required:true,
                    maxlength:5
                }
            },
            messages:{
                classroomId:{
                    required:"请选择教室",
                    maxlength:"长度不超过45个字符"
                },
                al_timeweek:{
                    required:"请选择上课日期",
                    maxlength:"长度不超过45个字符"
                },
                al_timepitch:{
                    required:"请选择节次",
                    maxlength:"长度不超过45个字符"
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
            /* 失去焦点时不验证 */
            onfocusout: false
        });

        //获取当前时间
        /*$scope.getTime=function () {
            $scope.semesters={};//存储学期
            //获取当前时间，判断当前学期
            var mydate = new Date();
            var nowtime=mydate.toLocaleString();//获取当前时间
            var nowtiemes=new Array();
            nowtiemes=nowtime.split("-");//将当前时间分割为数组
            if(nowtiemes[1]<7){
                $scope.semesters[0]=(parseInt(nowtiemes[0])-1).toString()+"-"+(parseInt(nowtiemes[0])).toString()+"-"+"下学期";
                $scope.semesters[1]=(parseInt(nowtiemes[0])).toString()+"-"+(parseInt(nowtiemes[0])+1).toString()+"-"+"上学期";
                $scope.semesters[2]=(parseInt(nowtiemes[0])).toString()+"-"+(parseInt(nowtiemes[0])+1).toString()+"-"+"下学期";
                $scope.semesters[3]=(parseInt(nowtiemes[0])+1).toString()+"-"+(parseInt(nowtiemes[0])+2).toString()+"-"+"上学期";
            }else {
                $scope.semesters[0]=(parseInt(nowtiemes[0])).toString()+"-"+(parseInt(nowtiemes[0])+1).toString()+"-"+"上学期";
                $scope.semesters[1]=(parseInt(nowtiemes[0])).toString()+"-"+(parseInt(nowtiemes[0])+1).toString()+"-"+"下学期";
                $scope.semesters[2]=(parseInt(nowtiemes[0])+1).toString()+"-"+(parseInt(nowtiemes[0])+2).toString()+"-"+"上学期";
                $scope.semesters[3]=(parseInt(nowtiemes[0])+1).toString()+"-"+(parseInt(nowtiemes[0])+2).toString()+"-"+"下学期";
            }
        }*/

        //首次加载课程
        $scope.loadeducateTask();
        //checked 复选框判断
        $scope.all = false;
        $scope.checklist=[];
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
