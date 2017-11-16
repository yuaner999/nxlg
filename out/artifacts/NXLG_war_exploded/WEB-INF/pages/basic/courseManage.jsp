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
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：课程管理
<hr>
<table-nav>
    <li ng-click="dofilter(1)" class="sele">现有课程列表</li>
    <li ng-click="dofilter(0)" >待审核列表</li>
    <li ng-click="dofilter(2)" >其它课程列表</li>
</table-nav>
<div class="title">
    <table-btn ng-if="show==1" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" />新建</table-btn>
    <table-btn  ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <input class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadCourse()">搜索</table-btn>
    <table-btn ng-if="show==1" ng-click="btnExcel()">导出到Excel</table-btn>
    <form ng-if="show==1" class="top_1" method="post" hidden></form>
</div>
<!--表格-->
<div class="tablebox" style="width: 100%;">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
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
        <th ng-if="show==2||show==3">审核类别</th>
        <th>审核状态</th>
        <th ng-if="show==3">未通过原因</th>
        <th style="width: 12%;"></th>
        </thead>
        <tbody>
        <tr ng-repeat="course in courses">
            <td class="thischecked" ng-click="thischecked(course)">
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
            <td ng-if="show==2||show==3" ng-bind="course.checkType"></td>
            <td ng-bind="course.checkStatus"></td>
            <td ng-if="show==3" ng-bind="course.refuseReason" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"
                ng-click="ReasonDetail(course.refuseReason,$index)" class="Ar"></td>
            <td><table-btn ng-if="show==1" ng-click="edit(course)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="delete(course)">删除</table-btn></td>
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
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：课程管理 > 新增/修改
    <hr>
    <form id="Form">
        <div class="row">
            <br class="col-sm-3 col-xs-3">
            <li style="display: none;"><span>ID：</span><input type="text" name="courseId" class="forminput" /></li>
            <li><span class="span_width">课程代码：</span><input type="text" ng-model="checkitem.courseCode" name="courseCode" class="forminput" id="courseCode"/></li>
            <li><span class="span_width">中文名称：</span><input type="text" ng-model="checkitem.chineseName" name="chineseName" class="forminput" id="chineseName"/></li>
            <li><span class="span_width">英文名称：</span><input type="text" ng-model="checkitem.englishName" name="englishName" class="forminput" id="englishName"/></li>
            <%--<li id="assumeU">
                <span class="span_width">承担单位：</span>
                <select  type="text" ng-model="checkitem.assumeUnit" name="assumeUnit" class="forminput" id="assumeUnit">
                    <option value="" selected="selected">--请选择--</option>
                    <option value="{{college.wordbookValue}}" ng-repeat="college in colleges" ng-bind="college.wordbookValue"></option>
                </select>
            </li>--%>
            <li>
                <span class="span_width">课程类别三：</span>
                <select type="text" ng-model="checkitem.courseCategory_3" name="courseCategory_3" class="forminput" id="courseCategory_3"/>
                <option value="">--请选择--</option>
                <option value="课程课">课程课</option>
                <option value="实践课">实践课</option>
                </select>
            </li>
            <li>
                <span class="span_width">课程类别四：</span>
                <select type="text" ng-model="checkitem.courseCategory_4" name="courseCategory_4" class="forminput" id="courseCategory_4"/>
                <option value="">--请选择--</option>
                <option value="普通课">普通课</option>
                <option value="上机课">上机课</option>
                <option value="实验课">实验课</option>
                <option value="实训课">实训课</option>
                <option value="体育课">体育课</option>
                <option value="外语课">外语课</option>
                </select>
            </li>
            <li>
                <span class="span_width">课程类别五：</span>
                <select type="text" ng-model="checkitem.courseCategory_5" name="courseCategory_5" class="forminput" id="courseCategory_5"/>
                <option value="">--请选择--</option>
                <option value="自然科学类">自然科学类</option>
                <option value="计算机科学类">计算机科学类</option>
                <option value="国际化类">国际化类</option>
                </select>
            </li>
            <li><span class="span_width">学分：</span><input type="text" ng-model="checkitem.totalCredit" name="totalCredit" class="forminput" id="totalCredit"/></li>
            <%--<li><span class="span_width">理论学分：</span><input type="text" ng-model="checkitem.theoreticalCredit" name="theoreticalCredit" class="forminput" id="theoreticalCredit"/></li>--%>
            <%--<li><span class="span_width">实践学分：</span><input type="text" ng-model="checkitem.practiceCredit" name="practiceCredit" class="forminput" id="practiceCredit"/></li>--%>
            <%--<li><span class="span_width">讲授学时：</span><input type="text" ng-model="checkitem.teachingTime" name="teachingTime" class="forminput" id="teachingTime"/></li>--%>
            <%--<li><span class="span_width">实验学时：</span><input type="text" ng-model="checkitem.experimentalTime" name="experimentalTime" class="forminput" id="experimentalTime"/></li>--%>
            <%--<li><span class="span_width">上机学时：</span><input type="text" ng-model="checkitem.machineTime" name="machineTime" class="forminput" id="machineTime"/></li>--%>
            <%--<li><span class="span_width">其他学时：</span><input type="text" ng-model="checkitem.otherTime" name="otherTime" class="forminput" id="otherTime"/></li>--%>
            <li><span class="span_width">学时：</span><input type="text" ng-model="checkitem.totalTime" name="totalTime" class="forminput" id="totalTime"/></li>
            <li>
                <span class="span_width">课程状态：</span>
                <select type="text" ng-model="checkitem.courseStatus" name="courseStatus" class="forminput" id="courseStatus"/>
                <option value="">--请选择--</option>
                <option value="启用">启用</option>
                <option value="停用">停用</option>
                </select>
            </li>
            <li style="display: none"><span class="span_width">审核状态：</span><input type="text" ng-model="checkitem.checkStatus" name="checkStatus" class="forminput" id="checkStatus"/></li>
            <li>
                <span>负责教师：</span>
                <select  ng-model="checkitem.mainteacherid" name="mainteacherid" class="forminput" id="mainteacherid">
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in options" value="{{option.teacherId}}" ng-bind="option.teacherName"></option>
                </select>
            </li>
            <li ng-if="changebook">
                <span>是否发送消息更改教材：</span>
                <select  ng-model="checkitem.changebook" name="changebook" class="forminput" id="changebook">
                    <option value="">--请选择--</option>
                    <option value="是">是</option>
                    <option value="否">否</option>
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
    var add_edit=true;
    var num=0;
    var filter=1;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        var DelInfo=true;
        $scope.all = false;
        $scope.show=1;
        $scope.changebook=false;
        $scope.checklist=[];
        $scope.checkitem={};
        //加载数据
        $scope.loadCourse = function () {
            DelInfo=true;
            $scope.checklist=[];
            $scope.checkitem={};
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("courseManage_loadCourse",{pageNum:pageNum,pageSize:pageSize,filter:filter,searchStr:searchStr},function (data) {
                closeLoading();//关闭加载层
                if(data.result==false){
                    showmsgpc(data.errormessage);
                    return;
                }
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
            remotecall("courseManage_loadTeacher",'',function (data) {
                $scope.options = data;
                teacherId=data[0].teacherId;
                closeLoading();//关闭加载层
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载教师失败");
                console.log(data);
            });
        };
        //首次加载课程
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
                pageNum = pn;//改变当前页
                //重新加载用户信息
                $scope.loadCourse();
            }
        };
        $scope.dofilter=function(str){
            pageNum=1;
            if(str==1){
                $scope.show=1;
                filter=1;
                $scope.loadCourse();
            }else if(str==0){
                $scope.show=2;
                filter=0;
                $scope.loadCourse();
            }else if(str==2){
                $scope.show=3;
                filter=2;
                $scope.loadCourse();
            }
            filter = str;
            $scope.loadCourse();
        }
        //删除功能
        $scope.delete=function (tr) {
//            $('#all').attr("checked",false);
//            $scope.allfn();
//            tr.td0 = false;
//            $scope.thischecked(tr);
            $scope.checklist.splice(0, 2,tr);
            $scope.checkitem = $scope.checklist[0];
            parent.pConfirm("确认删除选中的课程吗？",function () {
                loading();
                remotecall("courseManage_deleteCourse",$scope.checkitem,function (data) {
                    if(data===2){
                        parent.pMsg("删除失败:该课程存在未审核的操作");
                        closeLoading();//关闭加载层
                        //重新加载课程
                    }else if(data){
                        parent.pMsg("删除成功");
                        closeLoading();//关闭加载层
                        //重新加载课程
                        $scope.loadCourse();
                        $scope.$apply();
                    }else {
                        parent.pMsg("删除失败");
                        closeLoading();//关闭加载层
                    }
                },function (data) {
                    parent.pMsg("删除失败");
                    closeLoading();//关闭加载层
                    console.log(data);
                });
            },function () {});
        };
        //批量删除功能
        $scope.deletes = function () {
            //获取所选择的行
            if($("input[name='courseIdSelect']:checked").length<1){
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='courseIdSelect']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            $scope.checkitem = $scope.checklist;
            loading();//加载层
            parent.pConfirm("确认删除选中的所有的课程吗？",function () {
                loading();
                for(var i=0;i<$scope.checkitem.length;i++){
                    if(DelInfo){
                        remotecall("courseManage_deleteCourse",$scope.checkitem[i],function (data) {
                            closeLoading();//关闭加载层
                            if(data===2){
                                parent.pMsg("删除失败:该课程存在未审核的操作");
                                DelInfo=false;
                            }else if(!data){
                                parent.pMsg("删除失败");
                                DelInfo=false;
                            }
                        },function (data) {
                            parent.pMsg("删除失败");
                            closeLoading();//关闭加载层
                            DelInfo=false;
                        });
                    }
                }
                if(DelInfo){
                    parent.pMsg("删除成功");
                }
                //重新加载课程
                $scope.loadCourse();
                $scope.$apply();
            },function () {});
        };
        //判断是否是老师角色
        $scope.isTeacher=function(){
            remotecall("teacher_educatePlan_loadteacher",'',function (data) {
                if(data){
                    $("#assumeU").hide();
                    $scope.checkitem.assumeUnit = data[0].teachCollege;
                    console.log($scope.checkitem.assumeUnit);
                }else{
                    $("#assumeU").show();
                    //加载任教学院下拉选
                    remotecall("teacherManage_loadcollege",{},function (data) {
                        closeLoading();//关闭加载层
                        $scope.colleges=data.rows;
                    },function (data) {closeLoading();});//关闭加载层
                }
            },function (data) {
                parent.pMsg("暂无数据");
            });
        }
        //新建
        $scope.add = function () {
            add_edit=true;
            $scope.changebook=false;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table').hide();
            $('.table-addform').show();
            $scope.isTeacher();
            $("#Form input").value="";
        };
        //修改
        $scope.edit= function (tr) {
            add_edit=false;
            $scope.changebook=true;
            $scope.checkitem={};
//            $('#all').attr("checked",false);
//            $scope.allfn();
//            tr.td0 = true;
            $scope.checklist.splice(0, 1,tr);
            $scope.checkitem=$scope.checklist[0];
            $scope.isTeacher();
            var json="[{课程代码："+$scope.checkitem.courseCode+"},{中文名称："+$scope.checkitem.chineseName+"},{英文名称：" +$scope.checkitem.englishName+"},{承担单位："
                    +$scope.checkitem.assumeUnit+"},{课程类别三："+$scope.checkitem.courseCategory_3+"},{课程类别四："+$scope.checkitem.courseCategory_4+"},{课程类别五："
                    +$scope.checkitem.courseCategory_5+"},{总学分："+$scope.checkitem.totalCredit+"},{理论学分："+$scope.checkitem.theoreticalCredit+"},{实践学分："
                    +$scope.checkitem.practiceCredit+"},{讲授学时："+$scope.checkitem.teachingTime+"},{实验学时："+$scope.checkitem.experimentalTime+"},{上机学时："
                    +$scope.checkitem.machineTime+"},{其他学时："+$scope.checkitem.otherTime+"},{总学时："+$scope.checkitem.totalTime+"},{课程状态："+$scope.checkitem.courseStatus+"}]";
            $scope.checkitem.json1=json;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-addform').show();
            $('table').hide();
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
            num=0;
            $scope.all = false;
            $scope.loadCourse();
            for(i=0;i<$scope.courses.length;i++){
                $scope.courses[i].td0=false;
            }
        };
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
                    $scope.courses[i].td0=false;
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
        //表单验证
        $("#Form").validate({
            submitHandler:function(form){
                //验证通过,然后就保存
                if(add_edit){//如果是添加
                    var parames = $("#Form").serializeObject();//参数
                    parames = Object.assign($scope.options[0],parames);
                    remotecallasync("courseCode_unique", parames, function (data) {//查询课程代码是否已经存在
                        if (data.length == '0') {//如果课程代码不存在
                            remotecallasync("courseManage_addCourse",parames,function(data) {
                                if(data===10){
                                    parent.pMsg("该课程已添加");
                                }else if(data===0){
                                    parent.pMsg("该负责教师不是系统用户");
                                }else if(data===1){
                                    parent.pMsg("填写教材通知发送失败");
                                }else if(data===2){
                                    parent.pMsg("添加成功，负责教师请查收站内通知");
                                    $('.table-addform').hide();
                                    $('table').show();
                                    $scope.loadCourse();
                                    $scope.$apply();
                                    $scope.checklist=[];
                                    $scope.checkitem={};
                                }else {
                                    parent.pMsg("添加失败");
                                    closeLoading();//关闭加载层
                                }
                            },function (data) {
                                parent.pMsg("数据库请求失败");
                                closeLoading();//关闭加载层
                                console.log(data);
                            });
                        } else {
                            parent.pMsg("课程代码已经存在，请重新输入");
                            closeLoading();//关闭加载层
                        }
                    }, function (data) {
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                }else{//修改
                    var edit_name = $("input[name='courseIdSelect']:checked").map(function(index,elem) {
                        return $(elem).val();
                    }).get();
                    var parames = $("#Form").serializeObject();//参数
                    parames["courseId"]=edit_name[0];
                    parames["relationId"]=$scope.checkitem.relationId;
                    parames = Object.assign($scope.options[0],parames);
                    remotecallasync("courseCode_unique_update", parames, function (data) {//查询输入的课程代码是否存在
                        if (data.length == 0) { //1、课程代码不存在 2、课程id的已有
                            remotecallasync("courseManage_editcourse",$scope.checkitem,function (data) {
                                if(data==10){
                                    parent.pMsg("该课程已添加");
                                }else if(data==9){
                                    parent.pMsg("修改失败:该课程存在未审核的操作");
                                }else if(data==0){
                                    parent.pMsg("该负责教师不是系统用户");
                                }else if(data==1){
                                    parent.pMsg("消息发送失败");
                                }else if(data==2){
                                    parent.pMsg("修改申请失败");
                                }else if(data==3){
                                    parent.pMsg("修改申请成功，负责教师请查收站内通知，历史记录保存失败");
                                }else if(data==4){
                                    parent.pMsg("修改申请成功，负责教师请查收站内通知");
                                    $('.table-addform').hide();
                                    $('table').show();
                                    $scope.loadCourse();
                                    $scope.$apply();
                                }else if(data==5){
                                    parent.pMsg("修改申请失败");
                                }else if(data==6){
                                    parent.pMsg("修改申请成功，历史记录保存失败");
                                }else if(data==7){
                                    parent.pMsg("修改申请成功，不更改教材");
                                    $('.table-addform').hide();
                                    $('table').show();
                                    $scope.loadCourse();
                                    $scope.$apply();
                                }else if(data==11){
                                    parent.pMsg("当前该课程正在审核");
                                    $('.table-addform').hide();
                                    $('table').show();
                                    $scope.loadCourse();
                                    $scope.$apply();
                                }
                            },function (data) {
                                parent.pMsg("请求失败");
                            });
                        } else {
                            parent.pMsg("课程代码已经存在，请重新输入");
                        }
                    }, function (data) {
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                }
            },
            rules:{
                courseCode:{
                    required:true
                },
                chineseName:{
                    required:true
                },
                assumeUnit:{
                    required:true
                },
                courseCategory_3:{
                    required:true
                },
                courseCategory_4:{
                    required:true
                },
                courseCategory_5:{
                    required:true
                },
                totalCredit:{
                    required:true,digits: true
                },
                theoreticalCredit:{
                    required:true
                },
                practiceCredit:{
                    required:true
                },
                teachingTime:{
                    required:true
                },
                experimentalTime:{
                    required:true
                },
                machineTime:{
                    required:true
                },
                otherTime:{
                    required:true
                },
                totalTime:{
                    required:true,digits: true
                },
                courseStatus:{
                    required:true
                },
                mainteacherid:{
                    required:true
                }
            },
            messages:{
                courseCode:{
                    required:"请输入课程代码"
                },
                chineseName:{
                    required:"请输入中文名称"
                },
                assumeUnit:{
                    required:"请输入承担单位"
                },
                courseCategory_3:{
                    required:"请选择课程类别三"
                },
                courseCategory_4:{
                    required:"请选择课程类别四"
                },
                courseCategory_5:{
                    required:"请选择课程类别五"
                },
                totalCredit:{
                    required:"请输入总学分",digits: "只能输入数字"
                },
                theoreticalCredit:{
                    required:"请输入理论学分"
                },
                practiceCredit:{
                    required:"请输入实践学分"
                },
                teachingTime:{
                    required:"请输入讲授学时"
                },
                experimentalTime:{
                    required:"请输入实验学时"
                },
                machineTime:{
                    required:"请输入上机学时"
                },
                otherTime:{
                    required:"请输入其他学时"
                },
                totalTime:{
                    required:"请输入总学时",digits: "只能输入数字"
                },
                courseStatus:{
                    required:"请选择课程状态"
                },
                mainteacherid:{
                    required:"请选择负责教师"
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

        //导出到课程信息到Excel
        $scope.btnExcel=function () {
            loading();
            remotecall("courseManage_loadTeacherCollege","",function (data) {
                closeLoading();
                var url="../../export/conditions_1.form?searchStr="+searchStr+"&teachCollege="+data[0].teachCollege;
                $(".top_1").attr("action",url);
                $(".top_1").submit();
            },function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
                console.log(data);
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

    //绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchkey").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>


