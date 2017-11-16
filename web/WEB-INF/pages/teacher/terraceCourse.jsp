<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/27
  Time: 8:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
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
    .span_width{
        margin-left: 20px;
    }
    #search{
        margin-left: 20px;
    }
    .span_width{
        width: 90px;
        display:inline-block;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：开课课程
<hr>
<!--导航筛选-->
<table-nav class="table-nav">
    <li ng-click="dofilter(1)" class="sele">现有开课课程</li>
    <li ng-click="dofilter(0)">待审核列表</li>
    <li ng-click="dofilter(2)">未通过列表</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <%--<input ng-show="show=='0'" class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>--%>

    <span class="span_width" ng-show="show=='0'">平&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;台：</span>
    <select type="text" ng-model="terraceName" name="terraceName" class="forminput" id="terraceName" ng-show="show=='0'">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="terrace in terraces" value="{{terrace.terraceId}}" ng-bind="terrace.terraceName"></option>
    </select>

    <span class="span_width" ng-show="show=='0'">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;院：</span>
    <select type="text" ng-model="collegeName" name="collegeName" class="forminput"
            id="collegeName"
            ng-change="loadMajorBox(this)" ng-show="show=='0'">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="college in colleges" value="{{college.wordbookValue}}"
                ng-bind="college.wordbookValue"></option>
    </select>

    <span class="span_width" ng-show="show=='0'">专&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;业：</span>
    <select type="text" ng-model="majorName" name="majorName" class="forminput" id="majorName" ng-show="show=='0'">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="major in majors" value="{{major.majorId}}" ng-bind="major.majorName"></option>
    </select>
        <span class="span_width" ng-show="show=='0'">培养层次：</span>
        <select  ng-show="show=='0'" type="text" ng-model="majorLevel" name="majorLevel" class="forminput" id="majorLevel">
            <option value="" selected="selected">--请选择--</option>
            <option ng-repeat="majorLevel in majorLevels" value="{{majorLevel.wordbookValue}}" ng-bind="majorLevel.wordbookValue"></option>
        </select>
    <table-btn ng-if="show=='1'" ng-click="previous1()">返回</table-btn>
    <table-btn ng-if="show=='2'" ng-click="previous2()">返回</table-btn>
    <table-btn ng-if="show=='3'" ng-click="previous3()">返回</table-btn>
</div>

<div class="title">
    <span class="span_width" ng-show="show=='0'">开课学期：</span>
    <select ng-show="show=='0'" ng-model="termName" name="termName" class="forminput" id="termName"/>
    <option value="">--请选择--</option>
    <option ng-repeat="option in terms" value="{{option.semester}}" ng-bind="option.semester"></option>
    </select>
    <span ng-show="show==0&&Var" class="span_width">审核类别：</span>
    <select type="text" ng-model="checkType" name="checkType" class="forminput" id="checkType" ng-show="show==0&&Var"/>
    <option value="">--请选择--</option>
    <option value="新增">新增</option>
    <option value="修改">修改</option>
    <option value="删除">删除</option>
    </select>
    <%--<span ng-show="show=='0'&&Var" class="span_width">审核状态：</span>--%>
    <%--<select ng-show="show=='0'&&Var" type="text" ng-model="checkStatus" name="checkStatus" class="forminput" id="checkStatus"/>--%>
    <%--<option value="">--请选择--</option>--%>
    <%--<option value="未通过">未通过</option>--%>
    <%--<option value="待审核">待审核</option>--%>
    <%--</select>--%>
    <table-btn ng-show="show=='0'" id="search" ng-click="loadDataFirst()">搜索</table-btn>
    <table-btn ng-if="showExcel==0" ng-click="btnExcel()">导出到Excel</table-btn>
    <table-btn class="top" ng-click="add()" ng-if="Var"><img src="<%=request.getContextPath()%>/images/tableadd_07.png"/>新建—专业平台课程</table-btn>
    <form class="top_1" method="post" hidden></form>
</div>

<!--平台课程列表-->
<div class="tablebox" id="allInfo">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th>年级</th>
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
        <th >备注</th>
        <th>审核状态</th>
        <th ng-if="Var">审核类别</th>
        <th ng-if="Var&&tab=='未通过'">未通过原因</th>
        <th style="width: 160px;"></th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-bind="Info.mtc_grade"></td>
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
            <td ng-bind="Info.mtc_note" style="word-break:break-all"></td>
            <td ng-bind="Info.mtc_checkStatus"></td>
            <td  ng-if="Var" ng-bind="Info.mtc_checkType"></td>
            <td  ng-if="Var&&tab=='未通过'" ng-bind="Info.mtc_refuseReason" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"
                 ng-click="ReasonDetail(Info.mtc_refuseReason,$index)" class="Ar"></td>
            <td><table-btn  ng-if="!Var" ng-click="edit(Info)">修改</table-btn><b style="margin-right: 10px"></b><table-btn ng-click="del(Info)">删除</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<!--专业列表-->
<div class="tablebox" id="major" style="display: none">
    <table class="table">
        <thead>
        <th>院(系)/部</th>
        <th>专业名称</th>
        <th>所属学科</th>
        <th>培养层次</th>
        <th>学制</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="major in majors">
            <td ng-bind="major.majorCollege"></td>
            <td ng-bind="major.majorName"></td>
            <td ng-bind="major.subject"></td>
            <td ng-bind="major.level"></td>
            <td ng-bind="major.length"></td>
            <td ng-click="loadTerrace(major)"><table-btn>设置</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--平台列表--%>
<div class="tablebox" id="terrace" style="display: none">
    <table class="table">
        <thead>
        <th>平台名称</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="terrace in terraces">
            <td ng-bind="terrace.terraceName"></td>
            <td ng-click="loadCourse(terrace)"><table-btn>设置</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--课程列表，培养计划里面的--%>
<div class="tablebox" id="course"  style="display: none">
    <table class="table">
        <thead>
        <th>年級</th>
        <th>课程代码</th>
        <th>课程名</th>
        <th>课程类别一</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th>总学分</th>
        <th>总学时</th>
        <th>培养平台</th>
        <th>考核方式</th>
        <th>周时</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="course in courses">
            <td ng-bind="course.ep_grade"></td>
            <td ng-bind="course.courseCode"></td>
            <td ng-bind="course.chineseName"></td>
            <td ng-bind="course.courseCategory_1"></td>
            <td ng-bind="course.courseCategory_3"></td>
            <td ng-bind="course.courseCategory_4"></td>
            <td ng-bind="course.courseCategory_5"></td>
            <td ng-bind="course.totalCredit"></td>
            <td ng-bind="course.totalTime"></td>
            <td ng-bind="course.ep_terrace"></td>
            <td ng-bind="course.ep_checkway"></td>
            <td ng-bind="course.ep_week"></td>
            <td><table-btn ng-click="setCourse(course)">设置</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--课程设置页面--%>
<div class="table-score">
    <form id="MenuForm">
        <div class="row">
            <ul class="scorecol">
                <li><span>开课学期：</span>
                    <select ng-model="courseset.mtc_courseTerm" name="mtc_courseTerm" class="forminput sel" id="mtc_courseTerm"/>
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options_term" value="{{option.semester}}" ng-bind="option.semester"></option>
                    </select>
                </li>
                <%--<li><span>方式(主修/辅修)：</span><input type="text"  ng-model="courseset.mtc_majorWay" name="mtc_majorWay" class="forminput" id="mtc_majorWay"/></li>--%>
                <li><span>备注：</span><input type="text"  ng-model="courseset.mtc_note" name="mtc_note" class="forminput" id="mtc_note"/></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
<div class="black"></div>
<div class="pagingbox">
    <paging></paging>
</div>
</body>
</html>
<script>
    var filter=1;
    var add_edit=true;
    var oldsearchchecktype="";
    var oldsearchcheckstatus="";
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        var loadTerrace = false;
        var loadCollege = false;
        var loadMajor = false;
        var loadmajorLevel = false;
        $scope.tab="已通过";
        $scope.show=0;
        $scope.Var=false;
        $scope.majorlist=[];
        $scope.majoritem={};
        $scope.terracelist=[];
        $scope.terraceitem={};
        $scope.checklist=[];
        $scope.checkitem={};
        $scope.checklist=[];
        $scope.checkitem={};
        $scope.coursesets=[];
        $scope.courseset={};

        //加载平台信息
        remotecall("terraceBox_loading",'',function (data) {
            $scope.terraces = data;
            console.log($scope.terraces);
            loadTerrace = true;
        },function (data) {
            parent.pMsg("加载数据失败");
        });

        //加载学院
        remotecall("studentManage_loadCollege", '', function (data) {
            $scope.colleges = data;
            loadCollege = true;
        }, function (data) {
            parent.pMsg("加载学院失败,或连接数据库失败！");
        });
        //加载专业
        remotecall("studentManage_loadMajor", {}, function (data) {
            $scope.majors = data;
            loadMajor = true;
        }, function (data) {
            parent.pMsg("加载专业失败,或连接数据库失败！");
        });

        //加载开学学期
        remotecall("teacher_terraceCourse_loadterm","",function (data) {
            closeLoading();//关闭加载层
            $scope.terms = data;
        },function (data) {
            closeLoading();//关闭加载层
            parent.pMsg("请求数据库失败");
        });

        //加载培养层次
        remotecall("majorLevelBox_loading", {}, function (data) {
            console.log(data)
            $scope.majorLevels = data;
            loadmajorLevel = true;
        }, function (data) {
            parent.pMsg("加载培养层次数据失败！");
        });


        //根据选择的学院加载相应学院下的专业
        $scope.loadMajorBox = function (obj) {
            loading();
            var majorCollege = $scope.collegeName;
            remotecall("studentManage_loadMajor", {majorCollege: majorCollege}, function (data) {
                closeLoading();//关闭加载层
                $scope.majors = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载专业失败,或连接数据库失败！");
            });
        };


        //初始化数据
        $scope.init = function () {
            if (loadTerrace && loadCollege && loadMajor && loadmajorLevel) {
                $scope.loadData();
            }
        }

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadData();
        }

        //加载数据
        $scope.loadData = function (){
            var pageSize = 5;
            if(filter == 1 ){
                $scope.showExcel = 0;
            }else{
                $scope.showExcel = 1;
            }
            $scope.show=0;
            if(!$scope.Var){

                $(".table-nav li:first").addClass("sele");
                $(".table-nav li:last").removeClass("sele");
            }else{
                $(".table-nav li:last").addClass("sele");
                $(".table-nav li:first").removeClass("sele");
                oldsearchchecktype=$scope.checkType;
                oldsearchcheckstatus=$scope.checkStatus;
            }
            console.log($scope.checkType);
            console.log($scope.checkStatus);
            $("#allInfo,.title,.pagingbox,.table-nav").show();
            $("#major,#terrace,#course,.table-score,.black").hide();
            loading();//加载
            remotecallasync("teacher_terraceCourse_load", {
                filter: filter,
                pageNum: pageNum,
                pageSize: pageSize,
                terraceName:$scope.terraceName,
                collegeName:$scope.collegeName,
                majorName:$scope.majorName,
                termName:$scope.termName,
                majorLevel:$scope.majorLevel,
                checkType: $scope.checkType,
                checkStatus:''
            },function (data) {
                    closeLoading();//关闭加载层
                    if(data.result==false){
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
                    if(data.total==0){
                        parent.pMsg("暂无数据");
                    }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("请求数据库失败");
            });
            remotecall("teacher_terraceCourse_loadcheckWay",'',function (data) {
                closeLoading();//关闭加载层
                $scope.options_checkWay = data;
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("请求数据库失败");
            });
            remotecall("teacher_terraceCourse_loadterm","",function (data) {
                closeLoading();//关闭加载层
                $scope.options_term = data;
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("请求数据库失败");
            });
        }
        $scope.loadMajor = function () {
            $scope.show=1;
            $scope.showExcel = 1;
            $scope.Var=false;
            $scope.majorlist=[];
            $scope.majoritem={};
            $("#major,.pagingbox,.title").show();
            $(".table-nav,#allInfo,#terrace,#course,.table-score,.black").hide();

            loading();//加载
            remotecall("teacher_terraceCourse_majorList",{pageNum:pageNum,pageSize:pageSize},function (data) {
                closeLoading();//关闭加载层
                if(data.result==false){
                    showmsgpc(data.errormessage);
                    return;
                }
                $scope.majors = data.rows;
                //$scope.$apply();
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

                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败" );
            });
        };
        //设置专业、平台、课程
        $scope.loadTerrace = function  (tr) {
            $scope.show=2;
            $scope.showExcel = 1;
            $scope.Var=false;
            $scope.majorlist.push(tr);
            $scope.majoritem=$scope.majorlist[0];
            $("#terrace,.title").show();
            $("#major,.pagingbox,.table-nav,#allInfo,#course,.table-score,.black").hide();

            loading();//加载
            remotecallasync("teacher_terraceCourse_loadterrace","",function (data) {
                closeLoading();//关闭加载层
                $scope.terraces = data;
                //$scope.$apply();
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
            $scope.terracelist=[];
            $scope.terraceitem={};
        };
        $scope.loadCourse = function  (tr) {
            filter=1;
            $scope.show=3;
            $scope.showExcel = 1;
            $scope.Var=false;
            $scope.checklist=[];
            $scope.checkitem={};
            $scope.terracelist.push(tr);
            $scope.terraceitem=$scope.terracelist[0];
            $("#course,.pagingbox,.title").show();
            $("#major,.table-nav,#allInfo,#terrace,.table-score,.black").hide();

            loading();//加载
            remotecallasync("teacher_terraceCourse_loadEP",{pageNum:pageNum,pageSize:pageSize,majorCollege:$scope.majoritem.majorCollege,ep_major:$scope.majoritem.majorName,terraceName:$scope.terraceitem.terraceName},function (data) {
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
                $scope.$apply();
                setTimeout(function () {
                    $('.paging li').eq(dx).addClass('sele')
                },100);

                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("该专业和平台上无培养计划");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        $scope.setCourse = function  (tr) {
            $scope.checklist.push(tr);
            $scope.checkitem=$scope.checklist[0];
            $(".table-score,.black").show();
            $('#MenuForm input').val("");
        };

        //初始化
        $scope.init();

        //新建—专业平台课程
        $scope.add = function () {
            add_edit=true;
            $('#major').addClass('a-show');
            $('#major').removeClass('a-hide');
            $('.table-nav,.title,#allInfo').hide();
            $('#major').show();
            $scope.loadMajor();
        };
        //右侧菜单栏
        $scope.dofilter=function(str){
            if(str==0){//审核列表
                $scope.tab="待审核";
                $scope.Var=true;
                $scope.checkType=oldsearchchecktype;
                $scope.checkStatus=oldsearchcheckstatus;
            }else if(str==1){
                $scope.tab="已通过";
                $scope.Var=false;
                $scope.checkType="";
                $scope.checkStatus="";
            }else if(str==2){//审核列表
                $scope.tab="未通过";
                $scope.Var=true;
                $scope.checkType=oldsearchchecktype;
                $scope.checkStatus=oldsearchcheckstatus;
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
                //重新加载菜单
                if($("#major").css("display")!="none"){
                    $scope.loadMajor();
                }else if($("#course").css("display")!="none"){
                    $scope.loadCourse();
                }else {
                    if($scope.Var){
                        filter=0;
                    }else{
                        filter=1;
                    }
                    $scope.loadData();
                }
            }
        };
        //返回上一级
        $scope.previous1=function(){
            filter=0;
            $scope.Var=true;
            $scope.loadData();
        }
        $scope.previous2=function(){
            $scope.loadMajor();
        }
        $scope.previous3=function(){
            $scope.loadTerrace();
        }
        //取消
        $scope.cancel=function () {
            $('.table-score,.black').hide();
            //$(".table-nav,.title,#allInfo,.pagingbox").show();
            //清空选中
            $scope.coursesets=[];
            $scope.courseset={};
        }
        //修改
        $scope.edit= function (tr) {
            add_edit=false;
            $scope.coursesets=[];
            $scope.courseset={};
            $scope.coursesets.push(tr);
            $scope.courseset=$scope.coursesets[0];
            $('.table-score').addClass('a-show');
            $('.table-score').removeClass('a-hide');
            $('.table-score,.black').show();
        };
        //确定
        $("#MenuForm").validate({
            submitHandler:function(form){
//                if($scope.courseset.mtc_majorWay!="主修"&&$scope.courseset.mtc_majorWay!="辅修"){parent.pMsg("必须选择必修或辅修");return;}
                loading();
                $scope.courseset.majorId=$scope.majoritem.majorId;
                $scope.courseset.terraceId=$scope.terraceitem.terraceId;
                $scope.courseset.courseId=$scope.checkitem.courseId;
                $scope.courseset.ep_grade=$scope.checkitem.ep_grade;
                $scope.courseset.ep_id=$scope.checkitem.ep_id;
                $scope.courseset.mtc_majorWay=$scope.checkitem.courseCategory_1;
                if(add_edit){
                    remotecallasync("teacher_terraceCourse_add",$scope.courseset,function (data) {
                        closeLoading();//关闭加载层
                        if(data==0){
                            parent.pMsg("该专业平台课程已添加");
                        }else if(data){
                            parent.pMsg("添加成功");
                            $('.table-score,.black').hide();
                            $scope.coursesets=[];
                            $scope.courseset={};
                            $('#MenuForm input').val("");
                            filter=1;
                            $scope.loadData();
                            $scope.$apply();
                        }else {
                            parent.pMsg("添加失败");
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                }else{
                    remotecallasync("teacher_terraceCourse_edit", $scope.courseset, function (data) {
                        closeLoading();//关闭加载层
                        if(data==0){
                            parent.pMsg("数据异常，请联系管理员");
                        }else if(data==1){
                            parent.pMsg("系统正在审核，该专业不能进行新的操作");
                        }else if (data==2) {
                            parent.pMsg("修改成功");
                            $scope.loadData();
                            $scope.$apply();
                            //清空选中
                            $scope.coursesets=[];
                            $scope.courseset={};
                        }else {
                            parent.pMsg("修改失败");
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                }
            },
            rules:{
                mtc_courseTerm:{
                    required:true,
                    maxlength:45
                },
                mtc_majorWay:{
                    required:true,
                    maxlength:45
                }
            },
            messages:{
                mtc_courseTerm:{
                    required:"必填项",
                    maxlength:"长度不超过45个字符"
                },
                mtc_majorWay:{
                    required:"必填项",
                    maxlength:"长度不超过45个字符"
                }
            },
            //重写showErrors
            showErrors: function (errorMap, errorList) {
                $.each(errorList, function (i, v) {
                    layer.tips(v.message, v.element, { time: 2000 });
                    return false;
                });
            },
            onfocusout: false,
            onclick:false,
            onkeyup:false
        });
        //删除一个
        $scope.del = function (tr) {
            $scope.coursesets=[];
            $scope.courseset={};
            $scope.coursesets.push(tr);
            $scope.courseset=$scope.coursesets[0];
            loading();
            remotecall("teacher_terraceCourse_del", $scope.courseset, function (data) {
                closeLoading();//关闭加载层
                if (data==1) {
                    parent.pMsg("系统正在审核，该专业不能进行新的操作")
                } else {
                    parent.pConfirm("确认删除选中的内容吗？", function () {
                        if (data==2) {
                            parent.pMsg("删除成功");
                            //重新加载菜单
                            $scope.loadData();
                            $scope.$apply();
                            //清空选中
                            $scope.coursesets=[];
                            $scope.courseset={};
                        } else {
                            parent.pMsg("删除失败");
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                    });
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("删除请求失败");
                console.log(data);
            });
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
            loading();
            remotecall("courseManage_loadTeacherCollege","",function (data) {
                var teachCollege = ''
                if(data.length > 0){
                    teachCollege = data[0].teachCollege;
                }
                closeLoading();
                var url="../../export/teacherTerraceCourseList.form?filter="+filter
                        +"&terraceName="+$scope.terraceName
                        +"&collegeName="+$scope.collegeName
                        +"&majorName="+$scope.majorName
                        +"&termName="+$scope.termName
                        +"&majorLevel="+$scope.majorLevel
                        +"&teachCollege="+teachCollege;
                $(".top_1").attr("action",url);
                $(".top_1").submit();
            },function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
                console.log(data);
            });


        }
    });
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#search").click();
        }
    });


</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>