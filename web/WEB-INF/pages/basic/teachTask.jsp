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
        .col {
            width: 40%;
        }

        .row {
            padding-left: 252px !important;
        }

        .forminput {
            margin-right: 80px !important;
            color: #000;
        }
        .forminput2{
            margin-right:10px !important;
            border: 1px solid #c5add7;
            height: 26px;
            width: 150px;
            padding: 0 5px;
        }

        .text-center {
            position: absolute;
            left: 33%;
        }

        .btn {
            position: absolute;
            top: 185px;
            left: 45px;
            color: #f2f2f2;
            background: #c5add7;
        }

        .table-majorshow {
            position: absolute;
            top: 20%;
            left: 20% !important;
            z-index: 100;
            max-width: 1026px;
            min-width: 750px;
            padding: 70px;
            border: 1px solid #c5add7;
            background-color: #edeaf1;
        }
        .tableSetMajor{
            max-width: 70%;
        }

        .black {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            background: #000;
            opacity: 0;
            filter: alpha(opacity=0);
            z-index: 9;
            display: none;
        }

        .title .tablesearchbtn {
            margin-left: 0px;
            margin-right: 12px;
            width: 150px;
            vertical-align: middle;
        }

    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：开课班级
<hr>
<!--导航筛选 此页不需要-->
<table-nav ng-if="show=='0'">
    <li ng-click="dofilter(1)" class="sele">现有开课班级</li>
    <li ng-click="dofilter(0)">待审核开课班级</li>
    <li ng-click="dofilter(2)">未通过列表</li>
</table-nav>
<div class="title">

    <span  ng-show="show=='0'" class="span_width">负责教师：</span>
    <input ng-show="show=='0'" class="tablesearchbtn" type="text" ng-model="teacherName" placeholder="请输入关键字查询..."
           onkeyup="getSearchStr(this)"/>
    <span  ng-show="show=='0'" class="span_width">所分班级：</span>
    <input ng-show="show=='0'" class="tablesearchbtn" type="text" ng-model="tc_class" placeholder="请输入关键字查询..."
           onkeyup="getSearchStr(this)"/>
    <span ng-show="show=='0'" class="span_width">课程名称：</span>
    <input ng-show="show=='0'" class="tablesearchbtn" type="text" ng-model="chineseName" placeholder="请输入关键字查询..."
           onkeyup="getSearchStr(this)"/>
</div>

<div class="title">
    <span ng-show="show=='0'" class="span_width">班级教师：</span>
    <input ng-show="show=='0'" class="tablesearchbtn" type="text" ng-model="teacherName1" placeholder="请输入关键字查询..."
           onkeyup="getSearchStr(this)"/>
    <span ng-show="show=='0'&&Var" class="span_width">审核类别：</span>
    <select type="text" ng-model="checkType" name="checkType" class="forminput2" id="checkType" ng-show="show=='0'&&Var"/>
    <option value="">--请选择--</option>
    <option value="新增">新增</option>
    <option value="修改">修改</option>
    <option value="删除">删除</option>
    </select>
    <%--<span ng-show="show=='0'&&Var" class="span_width">审核状态：</span>--%>
    <%--<select ng-show="show=='0'&&Var" type="text" ng-model="checkStatus" name="checkStatus" class="forminput2" id="checkStatus"/>--%>
    <%--<option value="">--请选择--</option>--%>
    <%--<option value="未通过">未通过</option>--%>
    <%--<option value="待审核">待审核</option>--%>
    <%--</select>--%>
    <table-btn ng-if="show=='0'" id="search" ng-click="loadDataFirst()">搜索</table-btn>
    <table-btn ng-if="show=='0'" class="top_1" ng-click="addfirst()"><img
            src="<%=request.getContextPath()%>/images/tableadd_07.png"/>新建
    </table-btn>
    <table-btn ng-if="show=='0'" ng-click="deletes()"><img
            src="<%=request.getContextPath()%>/images/tabledelete_07.png"/>批量删除
    </table-btn>
    <table-btn ng-if="show=='1'" ng-click="previous1()">返回</table-btn>
    <table-btn ng-if="show=='2'" ng-click="previous2()">返回</table-btn>
    <table-btn ng-if="show=='2'" ng-click="set()">设置</table-btn>
    <span ng-if="show=='2'">该课程的培养计划人数：<span style="color: #FF1F06" ng-bind="snum"></span>人</span>
    <table-btn ng-if="show=='3'&&showprevious3" ng-click="previous3()">返回编辑</table-btn>
    <table-btn ng-if="show=='3'" ng-click="OK()">确定</table-btn>
</div>
<!--表格-->
<div class="tablebox" ng-if="show=='0'">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/>
        </th>
        <th>课程名</th>
        <th>负责教师</th>
        <th>所分班级</th>
        <th>班级教师</th>
        <th>班级最小人数</th>
        <th>班级最大人数</th>
        <th>授课方式</th>
        <th>授课周时</th>
        <th>单双周</th>
        <th>先行课程</th>
        <th style="width:90px;">对应专业</th>
        <th class="top_2" style="display:none">审核类别</th>
        <th>审核状态</th>
        <th class="top_2"  ng-if="tab=='未通过'">未通过原因</th>
        <th style="width: 180px;">操作设置</th>
        </thead>
        <tbody>
        <tr ng-repeat="teachtask in teachtasks">
            <td class="thischecked" ng-click="thischecked(teachtask)">
                <input type="checkbox" id="kind" ng-model="teachtask.td0" name="tc_id" value="{{teachtask.tc_id}}"/><%--ng-check="all"--%>
            </td>
            <td ng-bind="teachtask.chineseName"></td>
            <td ng-bind="teachtask.teacherName"></td>
            <td ng-bind="teachtask.tc_class"></td>
            <td ng-bind="teachtask.teacherName1"></td>
            <%--<td ng-bind="teachtask.tc_grade" class="Arr" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"  ng-click="Detail(teachtask.tc_grade,$index)"></td>--%>
            <td ng-bind="teachtask.tc_studentnum"></td>
            <td ng-bind="teachtask.tc_numrange"></td>
            <td ng-bind="teachtask.tc_teachway"></td>
            <td ng-bind="teachtask.tc_teachweek"></td>
            <td ng-bind="teachtask.tc_teachodd"></td>
            <td ng-bind="teachtask.tc_teachmore"></td>
            <td>
                <table-btn ng-click="showmajor(teachtask)">查看</table-btn>
            </td>
            <td class="top_2" style="display:none" ng-bind="teachtask.tc_checkType"></td>
            <td ng-bind="teachtask.tc_checkStatus"></td>
            <td ng-if="tab=='未通过'" class="top_2 Ar"
                style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"
                ng-bind="teachtask.tc_refuseReason"
                ng-click="ReasonDetail(teachtask.tc_refuseReason,$index)"></td>
            <td>
                <table-btn class="top_1" ng-click="edit(teachtask)">修改</table-btn>
                &nbsp&nbsp
                <table-btn ng-click="delete(teachtask)">删除</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<div class="tablebox" ng-if="show=='1'">
    <table class="table">
        <thead>
        <th>课程</th>
        <th>平台</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-bind="Info.chineseName"></td>
            <td ng-bind="Info.terraceName"></td>
            <td ng-bind="Info.courseCategory_3"></td>
            <td ng-bind="Info.courseCategory_4"></td>
            <td ng-bind="Info.courseCategory_5"></td>
            <td>
                <table-btn ng-click="detail(Info)">详情</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<div class="tablebox" ng-if="show=='2'">
    <table class="table">
        <thead>
        <th>学院</th>
        <th>专业</th>
        <th>年级</th>
        <th>平台</th>
        <th>课程</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th>考核方式</th>
        <th>开课学期</th>
        <th>人数</th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo2">
            <td ng-bind="Info.ep_college"></td>
            <td ng-bind="Info.ep_major"></td>
            <td ng-bind="Info.ep_grade"></td>
            <td ng-bind="Info.terraceName"></td>
            <td ng-bind="Info.chineseName"></td>
            <td ng-bind="Info.courseCategory_3"></td>
            <td ng-bind="Info.courseCategory_4"></td>
            <td ng-bind="Info.courseCategory_5"></td>
            <td ng-bind="Info.ep_checkway"></td>
            <td ng-bind="Info.ep_term"></td>
            <td>
                <table-btn ng-click="stunum(Info)">详情</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<div class="tablebox" ng-if="show=='3'">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfns()" style="width: 100%;" type="checkbox" ng-checked="allmajor"/></th>
        <th>院(系)/部</th>
        <th>专业名称</th>
        <th>年级</th>
        <th>所属学科</th>
        <th>培养层次</th>
        <th>学制</th>
        <th>专业状态</th>
        <th>审核状态</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="tchecked(data)">
                <input type="checkbox" ng-checked="data.t" name="majorId" value="{{data.majorId}}"/>
            </td>
            <td ng-bind="data.majorCollege"></td>
            <td ng-bind="data.majorName"></td>
            <td ng-bind="data.mtc_grade"></td>
            <td ng-bind="data.subject"></td>
            <td ng-bind="data.level"></td>
            <td ng-bind="data.length"></td>
            <td ng-bind="data.majorStatus"></td>
            <td ng-bind="data.checkStatus"></td>
        </tr>
        </tbody>
    </table>
</div>
<!--分页-->
<div class="black"></div>
<div class="pagingbox" ng-if="show!='2'&&show!='3'">
    <paging></paging>
</div>
<!--新建表单-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <form id="Form">
        <div class="row">
            <ul class="col-sm-3 col-xs-3 col">
                <li><span class="span_width">所分班级：</span><input type="text" ng-model="checkitem.tc_class"
                                                                name="tc_class" class="forminput" id="tc_class"/></li>
                <li><span class="span_width">班级教师：</span>
                    <select ng-model="checkitem.tc_classteacherid" name="tc_classteacherid" class="forminput"
                            id="tc_classteacherid">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in checkitem.b" value="{{option.bteacherId}}"
                                ng-bind="option.bteacherName"></option>
                    </select>
                </li>
                <li>
                    <span class="span_width">班级最小人数：</span>
                    <input style="" type="text" ng-model="checkitem.tc_studentnum" name="tc_studentnum"
                           class="forminput" id="tc_studentnum"/>
                </li>
                <li>
                    <span class="span_width">班级最大人数：</span>
                    <input style="" type="text" ng-model="checkitem.tc_numrange" name="tc_numrange" class="forminput"
                           id="tc_numrange"/>
                </li>
                <li id="major"><span class="span_width">开课专业：</span>
                    <span class="tablebtn" ng-click="setmajor()">选择专业</span>
                </li>

            </ul>
            <ul class="col-sm-3 col-xs-3 col">
                <li><span class="span_width">授课周时：</span>
                    <input type="text" ng-model="checkitem.tc_thweek_start" name="tc_thweek_start" class="forminput1"
                           id="tc_thweek_start"/>至
                    <input type="text" ng-model="checkitem.tc_thweek_end" name="tc_thweek_end" class="forminput1"
                           id="tc_thweek_end"/>
                </li>
                <br>
                <li><span class="span_width">单双周：</span>
                    <select ng-model="checkitem.tc_teachodd" name="tc_teachodd" class="forminput" id="tc_teachodd">
                        <option value="">--请选择--</option>
                        <option value="无">无</option>
                        <option value="单周">单周</option>
                        <option value="双周">双周</option>
                    </select>
                </li>
                <li><span class="span_width">先行课程：</span>
                    <select ng-model="checkitem.tc_teachmore" name="tc_teachmore" class="forminput" id="tc_teachmore"
                            ng-click="teachmore()">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options1" value="{{option.chineseName}}"
                                ng-bind="option.chineseName"></option>
                    </select>
                </li>
                <li>
                    <span class="span_width">授课方式：</span><%--对应的是教室类型--%>
                    <select ng-model="checkitem.tc_teachway" name="tc_teachway" class="forminput" id="tc_teachway">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options4" value="{{option.crt_type}}"
                                ng-bind="option.crt_type"></option>
                    </select>
                </li>
            </ul>
            <table class="table tableSetMajor">
                <thead>
                <th>年级</th>
                <th>专业名称</th>
                <th>所属学院</th>
                <th>专业代码</th>
                </thead>
                <tbody>
                <tr ng-repeat="data in tMajors">
                    <td ng-bind="data.tcm_grade"></td>
                    <td ng-bind="data.majorName"></td>
                    <td ng-bind="data.majorCollege"></td>
                    <td ng-bind="data.majorCode"></td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
<div class="table-majorshow" ng-show="majorshow">
    <img style="float: right; position:absolute; top:15px;right:15px"
         src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <table class="table">
            <thead>
            <th>年级</th>
            <th>专业名称</th>
            <th>所属学院</th>
            <th>专业代码</th>
            <th>培养层次</th>
            <th>专业状态</th>
            </thead>
            <tbody>
            <tr ng-repeat="data in majors">
                <td ng-bind="data.tcm_grade"></td>
                <td ng-bind="data.majorName"></td>
                <td ng-bind="data.majorCollege"></td>
                <td ng-bind="data.majorCode"></td>
                <td ng-bind="data.level"></td>
                <td ng-bind="data.majorStatus"></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
<div class="table-majorshow" ng-show="stunumshow">
    <img style="float: right; position:absolute; top:15px;right:15px"
         src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show" ng-show="stunumshow">
        <table class="table">
            <thead>
            <th>人数</th>
            </thead>
            <tbody>
            <tr>
                <td ng-bind="snum1"></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
<script>
    var add_edit = true;
    var num = 0;
    var n = 0;
    var filter = 1;
    var cour = "";
    var oldsearchchecktype="";
    var oldsearchcheckstatus="";
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        var DelInfo = true;
        var majorInfo = true;
        var Now = (new Date()).getFullYear();
        $scope.tab="已通过";
        $scope.show = 0;
        $scope.Var=false;
        $scope.majorshow = false;
        $scope.setmajornum = false;//是否OK确定
        $scope.issetmajor = false;//是否选择专业
        $scope.stunumshow = false;
        $scope.editstatus = false;
        $scope.all = false;
        $scope.checklist = [];
        $scope.checkitem = {};
        $scope.tCourses = [];
        $scope.tCourse = {};
        $scope.tMajors = [];
        $scope.tMajor = {};
        $scope.student = {};
        $scope.years = [
            {id: 0, yearnum: Now - 4, checked: false},
            {id: 1, yearnum: Now - 3, checked: false},
            {id: 2, yearnum: Now - 2, checked: false},
            {id: 3, yearnum: Now - 1, checked: false},
            {id: 4, yearnum: Now, checked: false}
        ];
        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum = 1;
            $scope.loadData();
        }

        //加载数据
        $scope.loadData = function () {
            DelInfo = true;
            majorInfo = true;
            $scope.show = 0;
            if (filter == 1) {

                $(".table-nav li:first").addClass("sele");
                $(".table-nav li:last").removeClass("sele");
            } else {
                oldsearchchecktype=$scope.checkType;
                oldsearchcheckstatus=$scope.checkStatus;
                $(".table-nav li:last").addClass("sele");
                $(".table-nav li:first").removeClass("sele");
            }
            console.log($scope.checkType);
            console.log($scope.checkStatus);
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要

            remotecall("educateTask_load", {
                pageNum: pageNum,
                pageSize: pageSize,
                filter: filter,
                teacherName: $scope.teacherName,
                tc_class: $scope.tc_class,
                chineseName: $scope.chineseName,
                teacherName1: $scope.teacherName1,
                checkType: $scope.checkType,
                checkStatus:''
            }, function (data) {
                closeLoading();//关闭加载层
                $scope.teachtasks = data.rows;//加载的数据对象，‘courses’根据不同需求而变
                pageCount = parseInt((data.total - 1) / pageSize) + 1;//页码总数
                // 分页逻辑开始
                $scope.allPage = [];
                $scope.sliPage = [];
                for (var i = 1; i <= Math.ceil(data.total / pageSize); i++) {
                    $scope.allPage.push(i);
                }
                for (var i = 0; i < $scope.allPage.length; i += pageShow) {
                    $scope.sliPage.push($scope.allPage.slice(i, i + pageShow));
                }
                $scope.TotalPageCount = $scope.allPage.length;
                $scope.TotalDataCount = data.total;
                $scope.pages = $scope.sliPage[Math.ceil(pageNum / pageShow) - 1];
                $('.paging li').removeClass('sele');
                if (pageNum % pageShow == 0 && pageNum != 0) {
                    var dx = pageShow - 1;
                } else {
                    var dx = pageNum % pageShow - 1;
                }
                setTimeout(function () {
                    $('.paging li').eq(dx).addClass('sele')
                }, 100);
                num = 0;
                $scope.all = false;
                for (var i = 0; i < $scope.teachtasks.length; i++) {
                    $scope.teachtasks[i].td0 = false;
                }
                //$scope.unchecked();
                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
            remotecall("basic_classroom_loadwordbook_classroomtype", '', function (data) {
                $scope.options4 = data;
                closeLoading();//关闭加载层
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载教室失败");
            });
            remotecall("educateTask_loadCourse", '', function (data) {
                $scope.options1 = data;
                closeLoading();//关闭加载层
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载课程失败");
            });
            $scope.all = false;
            $scope.checklist = [];
            $scope.checkitem = {};
            for (var i = 0; i < $scope.years.length; i++) {
                $scope.years[i].checked = false;
            }
            if (filter == 1) {
                setTimeout(function () {
                    $(".top_2").hide();
                    $(".top_1").show();
                }, 1);
            } else {
                setTimeout(function () {
                    $(".top_2").show();
                    $(".top_1").hide();
                }, 1);
            }
        };
        //首次加载课程
        $scope.loadData();
        //分页
        $scope.gotoPage = function (pn, i) {
            if (pn == -1) {//上一页
                pn = pageNum - 1;
            }
            if (pn == -2) {//下一页
                pn = pageNum + 1;
            }
            if (pn == -3) {//最后一页
                pn = pageCount;
            }
            if (pn < 1 || pn > pageCount) {//页码不正确
                return;
            } else {
                pageNum = pn;//改变当前页
                //重新加载用户信息
                if ($scope.show == 0) {
                    $scope.loadData();
                } else if ($scope.show == 1) {
                    $scope.add();
                } else if ($scope.show == 3) {
                    $scope.setmajor();
                }
            }
        };
        $scope.dofilter = function (str) {
            $scope.teacherName = '';
            $scope.tc_class = '';
            $scope.chineseName = '';
            $scope.teacherName1 = '';
            $('tablesearchbtn').val('');
            pageNum = 1;
            if (str == 1) {
                $scope.tab="已通过";
                $scope.Var=false;
                $(".top_1").show();
                $(".top_2").hide();
                $scope.checkType="";
                $scope.checkStatus="";
            } else if (str == 0) {
                $scope.tab="待审核";
                setTimeout(function () {
                    $(".top_2").show();
                }, 1);
                $(".top_1").hide();
                $scope.Var=true;
                $scope.checkType=oldsearchchecktype;
                $scope.checkStatus=oldsearchcheckstatus;
            }
            else if (str == 2) {
                $scope.tab="未通过";
                setTimeout(function () {
                    $(".top_2").show();
                }, 1);
                $(".top_1").hide();
                $scope.Var=true;
                $scope.checkType=oldsearchchecktype;
                $scope.checkStatus=oldsearchcheckstatus;
            }
            filter = str;
            $scope.loadData();
        }
        $scope.allfn = function () {
            if ($scope.all == true) {
                $scope.all = false;
                for (var i = 0; i < $scope.teachtasks.length; i++) {
                    $scope.teachtasks[i].td0 = false;
                }
                $scope.checklist = [];
                $scope.checkitem = {};
                num = 0;
            } else {
                $scope.all = true;
                for (var i = 0; i < $scope.teachtasks.length; i++) {
                    $scope.teachtasks[i].td0 = true;
                    $scope.checklist.push($scope.teachtasks[i]);
                }
                num = $scope.teachtasks.length;
            }
        };
        $scope.allfns = function () {
            if ($scope.allmajor == true) {
                $scope.allmajor = false;
                for (var i = 0; i < $scope.datas.length; i++) {
                    $scope.datas[i].t = false;
                }
                $scope.tMajors = [];
                $scope.tMajor = {};
                n = 0;
            } else {
                $scope.allmajor = true;
                for (var i = 0; i < $scope.datas.length; i++) {
                    $scope.datas[i].t = true;
                    $scope.datas[i].tcm_grade= $scope.datas[i].mtc_grade;
                    $scope.tMajors.push($scope.datas[i]);
                }
                n = $scope.datas.length;
            }
        };
        $scope.thischecked = function (tr) {
            if (tr.td0 == false || tr.td0 == null) {
                num++;
                tr.td0 = true;
                $scope.checklist.push(tr);
            } else {
                num--;
                tr.td0 = false;
                $scope.all = false;
                var index = $scope.checklist.indexOf(tr);
                if (index > -1) {
                    $scope.checklist.splice(index, 1);
                }
            }
            if (num == $scope.teachtasks.length) {
                $scope.all = true;
            } else {
                $scope.all = false;
            }
        };
        $scope.tchecked = function (tr) {
            if (tr.t == false || tr.t == null) {
                n++;
                tr.t = true;
                tr.tcm_grade= tr.mtc_grade;
                $scope.tMajors.push(tr);
            } else {
                n--;
                tr.t = false;
                $scope.allmajor = false;
                var index = $scope.tMajors.indexOf(tr);
                if (index > -1) {
                    $scope.tMajors.splice(index, 1);
                }
            }
            if (n == $scope.datas.length) {
                $scope.allmajor = true;
            } else {
                $scope.allmajor = false;
            }
        };
        $scope.updateSel = function (tr) {
            if ($scope.years[tr].checked == true) {
                $scope.years[tr].checked = false;
            } else {
                $scope.years[tr].checked = true;
            }
        };
        //详情
        $scope.detail = function (tr) {
            $scope.show = 2;
            $scope.tCourses = [];
            $scope.tCourse = {};
            $scope.tCourses.splice(0, 1, tr);
            $scope.tCourse = $scope.tCourses[0];
            remotecallasync("educateTask_loadteachtask", tr, function (data) {
                closeLoading();//关闭加载层
                $scope.snum = data.r[0].snum;
                $scope.allInfo2 = data.rr;
                $scope.$apply();
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        //查看人数
        $scope.stunum = function (tr) {
            $scope.student = {};
            $scope.student = tr;
            $scope.stunumshow = true;
            $(".black,table").show();
            loading();
            remotecallasync("educateTask_loadstunum", $scope.student, function (data) {
                closeLoading();//关闭加载层
                $scope.snum1 = data[0].snum1;
                $scope.$apply();
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        }
        //查看专业
        $scope.showmajor = function (task) {
            loading();
            var tc_id = task.tc_id;
            remotecall("basic_teachtask_loadmajor", {tc_id: tc_id}, function (data) {
                closeLoading();//关闭加载层
                $scope.majors = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
            $scope.majorshow = true;
            $(".black,table").show();
        }
        //新建和修改，验证+保存
        $("#Form").validate({
            submitHandler: function (form) {
                var num = [];
                var j = 0;
                majorInfo = true;
                //验证通过,然后就保存
                if (parseInt($scope.checkitem.tc_thweek_start) >= parseInt($scope.checkitem.tc_thweek_end)) {
                    parent.pMsg("授课周时设置有误");
                    return;
                } else if ($scope.issetmajor == true && $scope.setmajornum == false) {
                    parent.pMsg("请选择一条记录");
                    return;
                } else {
                    if (add_edit) {
                        if ($scope.setmajornum == false || $scope.tMajors.length == 0) {
                            parent.pMsg("请确认选择专业");
                            return;
                        }
                        //限制班级最小人数和最大人数
                        var minPeople = $("#tc_studentnum").val();
                        var maxPeople = $("#tc_numrange").val();

                        if (minPeople < 0) {
                            layer.msg("最小人数必须大于0");
                            return;
                        }
                        if (minPeople >= maxPeople) {
                            layer.msg("最小人数必须小于最大人数");
                            return;
                        }
                        $scope.checkitem.mainteacherid = $scope.tCourse.mainteacherid;
                        $scope.checkitem.CId = $scope.tCourse.courseId;
                        loading();//加载层
                        remotecallasync("educateTask_loadCoursemore", $scope.checkitem, function (data) {
                            if (data) {
                                remotecallasync("educateTask_add", $scope.checkitem, function (data) {
                                    closeLoading();//关闭加载层
                                    if (data.rr) {
                                        for (var i = 0; i < $scope.tMajors.length; i++) {
                                            if (majorInfo) {
                                                $scope.tMajors[i].tc_id = data.tc_id;
                                                remotecall("educateTask_addmajor", $scope.tMajors[i], function (data) {
                                                    if (!data) {
                                                        parent.pMsg("开课专业添加失败");
                                                        majorInfo = false;
                                                    }
                                                }, function (data) {
                                                    parent.pMsg("开课专业添加失败");
                                                    majorInfo = false;
                                                });
                                            }
                                        }
                                        if (majorInfo) {
                                            parent.pMsg("添加成功");
                                        }
                                    } else {
                                        closeLoading();//关闭加载层
                                        parent.pMsg("添加失败");
                                    }
                                    //重新加载菜单
                                    $('.table-addform').hide();
                                    $('#AddForm input').text("");
                                    $('table,.title,.pagingbox').show();
                                    $scope.loadData();
                                    $scope.$apply();
                                }, function (data) {
                                    closeLoading();//关闭加载层
                                    parent.pMsg("数据库请求失败");
                                });
                            } else {
                                closeLoading();//关闭加载层
                                parent.pMsg("先行课程不能为本课程");
                            }
                        }, function (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("数据库请求失败");
                        });
                    } else {
//                        if($scope.tMajors.length==0){
//                            parent.pMsg("请确认选择专业");return;
//                        }
                        //限制班级最小人数和最大人数
                        var minPeople = $("#tc_studentnum").val();
                        var maxPeople = $("#tc_numrange").val();

                        if (minPeople < 0) {
                            layer.msg("最小人数必须大于0");
                            return;
                        }
                        if (minPeople >= maxPeople) {
                            layer.msg("最小人数必须小于最大人数");
                            return;
                        }
                        $scope.checkitem.mainteacherid = $scope.checkitem.tc_mainteacherid;
                        $scope.checkitem.CId = $scope.checkitem.tc_courseid;
                        remotecallasync("educateTask_loadCoursemore", $scope.checkitem, function (data) {
                            if (data) {
                                remotecallasync("educateTask_edit", $scope.checkitem, function (data) {
                                    closeLoading();//关闭加载层
                                    if (data == 1) {
                                        closeLoading();//关闭加载层
                                        parent.pMsg("系统正在审核，该专业不能进行新的操作");
                                    } else if (data.rr == 2) {
                                        closeLoading();//关闭加载层
                                        if ($scope.tMajors.length > 0) {
                                            remotecall("educateTask_editmajor", {
                                                tc_id: data.tc_id,
                                                tc_checkStatus: $scope.checkitem.tc_checkStatus,
                                                tMajors: $scope.tMajors
                                            }, function (data) {
                                                if (!data) {
                                                    parent.pMsg("开课专业修改失败");
                                                } else {
                                                    parent.pMsg("修改成功");
                                                }
                                            }, function (data) {
                                                parent.pMsg("开课专业修改失败");
                                            });
                                        } else {
                                            parent.pMsg("修改成功");
                                        }
                                    }
                                    //重新加载菜单
                                    $('.table-addform').hide();
                                    $('#AddForm input').text("");
                                    $('table,.title,.pagingbox').show();
                                    filter = 1;
                                    $scope.loadData();
                                    $scope.$apply();
                                }, function (data) {
                                    closeLoading();//关闭加载层
                                    parent.pMsg("数据库请求失败");
                                });
                            } else {
                                closeLoading();//关闭加载层
                                parent.pMsg("先行课程不能为本课程");
                            }
                        }, function (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("数据库请求失败");
                        });
                        $scope.editstatus = false;
                    }
                }
            },
            rules: {
                tc_courseid: {
                    required: true
                },
                tc_class: {
                    required: true
                },
                tc_classteacherid: {
                    required: true
                },
                tc_studentnum: {
                    required: true,
                    digits: true
                },
                tc_numrange: {
                    required: true,
                    digits: true
                },
                tc_teachway: {
                    required: true
                },
                tc_thweek_start: {
                    required: true,
                    min: 1,
                    max: 16
                },
                tc_thweek_end: {
                    required: true,
                    min: 1,
                    max: 16
                },
                tc_teachodd: {
                    required: true
                },
                grade: {required: true}
            },
            messages: {
                tc_courseid: {
                    required: "请输入课程"
                },
                tc_class: {
                    required: "请输入班级"
                },
                tc_classteacherid: {
                    required: "请输入班级教师"
                },
                tc_studentnum: {
                    required: "请输入最小班级人数",
                    digits: "只能输入数字"
                },
                tc_numrange: {
                    required: "请输入最大班级人数",
                    digits: "只能输入数字"
                },
                tc_teachway: {
                    required: "请输入授课方式"
                },
                tc_thweek_start: {
                    required: "请输入开始授课周时",
                    min: "开始授课时间不能小于1",
                    max: "结束授课时间不能大于16"
                },
                tc_thweek_end: {
                    required: "请输入结束授课周时",
                    min: "开始授课时间不能小于1",
                    max: "结束授课时间不能大于16"
                },
                tc_teachodd: {
                    required: "请输入单双周"
                }, grade: {required: "请选择年级"}
            },
            //重写showErrors
            showErrors: function (errorMap, errorList) {
                var msg = "";
                $.each(errorList, function (i, v) {
                    //msg += (v.message + "\r\n");
                    //在此处用了layer的方法,显示效果更美观
                    layer.tips(v.message, v.element, {time: 2000});
                    return false;
                });
            },
            /* 失去焦点时不验证 */
            onfocusout: false
        });
        //新建
        $scope.addfirst = function () {
            pageNum = 1;
            $scope.add();
        }
        //加载本院的开课课程（承担单位）
        $scope.add = function () {
            $scope.tMajors = [];
            $scope.tMajor = {};
            add_edit = true;
            $scope.editstatus = false;
            for (var i = 0; i < $scope.years.length; i++) {
                $scope.years[i].checked = false;
            }
            $scope.show = 1;
            remotecallasync("educateTask_loadteachcourse", {pageNum: pageNum, pageSize: pageSize}, function (data) {
                closeLoading();//关闭加载层
                if (data.result == false) {
                    showmsgpc(data.errormessage);
                    return;
                }
                $scope.allInfo = data.rows;
                pageCount = parseInt((data.total - 1) / pageSize) + 1;//页码总数
                // 分页逻辑开始
                $scope.allPage = [];
                $scope.sliPage = [];
                for (var i = 1; i <= Math.ceil(data.total / pageSize); i++) {
                    $scope.allPage.push(i);
                }
                for (var i = 0; i < $scope.allPage.length; i += pageShow) {
                    $scope.sliPage.push($scope.allPage.slice(i, i + pageShow));
                }
                $scope.TotalPageCount = $scope.allPage.length;
                $scope.TotalDataCount = data.total;
                $scope.pages = $scope.sliPage[Math.ceil(pageNum / pageShow) - 1];
                $('.paging li').removeClass('sele');
                if (pageNum % pageShow == 0 && pageNum != 0) {
                    var dx = pageShow - 1;
                } else {
                    var dx = pageNum % pageShow - 1;
                }
                setTimeout(function () {
                    $('.paging li').eq(dx).addClass('sele')
                }, 100);
                $scope.$apply();
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        $scope.previous1 = function () {
            filter = 1;
            $scope.loadData();
        }
        $scope.previous2 = function () {
//            $scope.show=1;
            pageNum = 1;
            $scope.add();
        }
        $scope.previous3 = function () {
            //$scope.editstatus=false;
//            if(add_edit){
//                $scope.detail($scope.tCourse);
//            }else{
//                filter=1;
//                $scope.loadData();
//            }
            $('.table-addform').show();
            $scope.show = 9;
        }
        $scope.setmajor = function () {
            $scope.tMajors = [];
            $scope.tMajor = {};
            $scope.issetmajor = true;
            $('.table-addform').hide();
            $scope.show = 3;
            var searchStr = "";
            loading();
            if ($scope.editstatus === true) {
                cour = $scope.checkitem.courseId;
            } else {
                cour = $scope.tCourse.cour;
            }
            remotecall("educateTask_loadM", {pageNum: 1, pageSize: 10000, cour: cour}, function (data) {
                closeLoading();
                $scope.datas = data.rows;
//                pageCount = parseInt((data.total - 1) / pageSize) + 1;//页码总数
//                 //分页逻辑开始
//                $scope.allPage = [];
//                $scope.sliPage = [];
//                for (var i = 1; i <= Math.ceil(data.total / pageSize); i++) {
//                    $scope.allPage.push(i);
//                }
//                for (var i = 0; i < $scope.allPage.length; i += pageShow) {
//                    $scope.sliPage.push($scope.allPage.slice(i, i + pageShow));
//                }
//                $scope.TotalPageCount = $scope.allPage.length;
//                $scope.TotalDataCount = data.total;
//                $scope.pages = $scope.sliPage[Math.ceil(pageNum / pageShow) - 1];
//                $('.paging li').removeClass('sele');
//                if (pageNum % pageShow == 0 && pageNum != 0) {
//                    var dx = pageShow - 1;
//                } else {
//                    var dx = pageNum % pageShow - 1;
//                }
//                setTimeout(function () {
//                    $('.paging li').eq(dx).addClass('sele')
//                }, 100);
                n = 0;
                $scope.allmajor = false;
                for (var i = 0; i < $scope.datas.length; i++) {
                    $scope.datas[i].t = false;
                }
                if ($scope.editstatus) {
                    // var major=0;
                    remotecall("basic_majorcheck_load", {tc_id: $scope.checkitem.tc_id}, function (checkdata) {
                        for (var i = 0; i < $scope.datas.length; i++) {
                            for (var j = 0; j < checkdata.total; j++) {
                                if ($scope.datas[i].majorId === checkdata.rows[j].tcm_majorid
                                        && $scope.datas[i].mtc_grade === checkdata.rows[j].tcm_grade) {
                                    $scope.datas[i].t = true;
                                    $scope.setmajornum = true;
                                    n++;
                                    $scope.datas[i].tcm_grade= $scope.datas[i].mtc_grade;
                                    $scope.tMajors.push($scope.datas[i]);
                                    break;
                                }
                            }
                        }
                        if (n == $scope.datas.length) {
                            $scope.allmajor = true;
                        } else {
                            $scope.allmajor = false;
                        }
                    }, function (data) {
                    });
                }
                if (data.total == 0) {
                    $scope.showprevious3=true;
                    parent.pMsg("暂无数据");
                }else
                {
                    $scope.showprevious3=false
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
        };
        $scope.OK = function () {
            $scope.setmajornum = true;
            if ($("input[name='majorId']:checked").length < 1) {
                parent.pMsg("请至少选择一条记录");
                return;
            }
            $('.table-addform').show();
            $scope.show = 7;
        };
        $scope.set = function () {
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table').hide();
            $('.table-addform').show();
            $("#Form input").value = "";
            remotecall("educateTask_loadTeacher", {mtc_id: $scope.tCourse.mtc_id}, function (data) {
                closeLoading();//关闭加载层
                if (data == 1) {
                    $scope.checkitem.b = [];
                } else {
                    $scope.checkitem.b = data;
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载班级教师失败");
            });
        };
        //修改
        $scope.edit = function (tr) {
            var tr_id = tr.tc_id;
            add_edit = false;
            $scope.editstatus = true;
            $scope.checklist = [];
            $scope.checkitem = {};
            $scope.tMajors = [];
            $scope.tMajor = {};
            $scope.checklist.splice(0, 1, tr);
            //获取当前选中的课程信息
            remotecall("basic_teachtask_loadmajor", {tc_id: tr_id}, function (data) {
                closeLoading();//关闭加载层
                $scope.tMajors = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
            $scope.checkitem = $scope.checklist[0];
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-addform').show();
            $('table').hide();
            $(".tableSetMajor").show();
        };
        //隐藏
        $scope.cancel = function () {
            $scope.editstatus = false;
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            }, 300);
            $('table,.title,.pagingbox').show();
            if (add_edit) {
                $scope.detail($scope.tCourse);
            } else {
                $scope.loadData();
            }
        };
        //删除功能
        $scope.delete = function (tr) {
            $scope.checklist = [];
            $scope.checkitem = {};
            $scope.checklist.splice(0, 1, tr);
            $scope.checkitem = $scope.checklist[0];
            var tc_id = $scope.checkitem.tc_id;
            $scope.checkitem.mainteacherid = $scope.checkitem.tc_mainteacherid;
            $scope.checkitem.CId = $scope.checkitem.tc_courseid;
            console.log(tc_id)
            //获取当前选中的课程信息
            remotecall("educateTask_courseId_update", {tc_id: tc_id}, function (data) {
                closeLoading();//关闭加载层
                if (data) {
                    loading();//加载层
                    parent.pConfirm("确认删除选中的课程吗？", function () {
                        remotecall("educateTask_delete", $scope.checkitem, function (data) {
                            if (data === 2) {
                                parent.pMsg("删除失败:该课程存在未审核的操作");
                                closeLoading();//关闭加载层
                                //重新加载课程
                            } else if (data) {
                                parent.pMsg("删除成功");
                                closeLoading();//关闭加载层
                                //重新加载课程
                                $scope.loadData();
                                $scope.$apply();
                            } else {
                                parent.pMsg("删除失败");
                                closeLoading();//关闭加载层
                            }
                        }, function (data) {
                            parent.pMsg("删除失败");
                            closeLoading();//关闭加载层
                        });
                    }, function () {
                        $scope.loadData();
                        $scope.$apply();
                    });
                } else {
                    closeLoading();//关闭加载层
                    parent.pMsg("加载数据失败");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        //批量删除功能
        $scope.deletes = function () {
            //获取所选择的行
            if ($("input[name='tc_id']:checked").length < 1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            $scope.checkitem = $scope.checklist;
            loading();//加载层
            parent.pConfirm("确认删除选中的所有的课程吗？", function () {
                for (var i = 0; i < $scope.checkitem.length; i++) {
                    if (DelInfo) {
                        remotecall("educateTask_delete", $scope.checkitem[i], function (data) {
                            closeLoading();//关闭加载层
                            if (data === 2) {
                                parent.pMsg("删除失败:该课程存在未审核的操作");
                                DelInfo = false;
                            } else if (!data) {
                                parent.pMsg("删除失败");
                                DelInfo = false;
                            }
                        }, function (data) {
                            parent.pMsg("删除失败");
                            DelInfo = false;
                            closeLoading();//关闭加载层
                        });
                    }
                }
                if (DelInfo) {
                    parent.pMsg("删除成功");
                }
                $scope.loadData();
                $scope.$apply();
            }, function () {
                $scope.loadData();
                $scope.$apply();
            });
        };
        //理由详情
        $scope.ReasonDetail = function (data, i) {
            if (data == null || data == "" || data.length <= 5)return;
            $(".Ar:eq(" + i + ")").addClass("RRR");
            layer.tips(data, ".RRR", {
                tips: [4, '#c5add7'],
                time: 3000
            });
            $(".Ar:eq(" + i + ")").removeClass("RRR");
        }
        $scope.Detail = function (data, i) {
            $(".Arr:eq(" + i + ")").addClass("RRRr");
            layer.tips(data, ".RRRr", {
                tips: [4, '#c5add7'],
                time: 3000
            });
            $(".Arr:eq(" + i + ")").removeClass("RRRr");
        }
        $scope.close = function () {
            $(".pagingbox").show();
            $(".black").hide();
            $scope.majorshow = false;
            $scope.stunumshow = false;
        }
    });
    //绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchkey").click();
        }
    });
    //后续课程加载
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>

