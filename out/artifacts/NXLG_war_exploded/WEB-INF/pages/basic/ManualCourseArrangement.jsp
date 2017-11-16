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
        }
        .table-courseshow{
            display: none;
            position: absolute;
            top: 20%;
            left: 20% !important;
            z-index: 100;
            max-width: 1026px;
            min-width: 750px;
            padding-top: 70px;
            border: 1px solid #c5add7;
            background-color: #edeaf1;
            padding-bottom: 70px;
        }
        .black{
              position: fixed;
              top: 0;
              left: 0;
              height: 100%;
              width: 100%;
              background: #000;
              opacity: 0.5;
              filter: alpha(opacity=0.2);
              z-index: 9;
              display: none;
          }
        .show ul li {
            margin-bottom: 10px;
        }
        .bttn{
            margin-left: 26%;
            margin-top:30px;
            border: 1px solid #c5add7;
            height: 26px;
            background: #edeaf1;
        }
        .tablesearchbtn1, .tablesearchbtn2{
            border: 1px solid #c5add7;
            height: 26px;
            color: #5c307d;
            margin-left: 20px;
            margin-right: 12px;
            width: 270px;
            vertical-align: middle;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：手动调整排课
<hr>
<div class="title">
    <table-btn  ng-show="show==0" ng-click="somestop()"><img src="<%=request.getContextPath()%>/images/tablereject.png" />批量停课</table-btn>
    <table-btn  ng-show="show==0" ng-click="showlog1()"><img src="<%=request.getContextPath()%>/images/details.png" style="cursor: pointer"/>查看总日志</table-btn>
    <table-btn ng-show="show=='3'" ng-click="previous3()">返回</table-btn>
    <input ng-show="show==0" class="tablesearchbtn1" type="text" ng-model="input.keyword" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
    <%--<span ng-show="show==0">第<input  class="tablesearchbtn1" style="width: 50px" type="text" ng-model="week1" id="week1" name="week1"/>周</span>--%>
    <span ng-show="show==0">周次：
         <select type="text" ng-model="week1"  name="week1" class="forminput"/>
            <option value="">--请选择--</option>
            <option value="1">第1周</option>
            <option value="2">第2周</option>
            <option value="3">第3周</option>
            <option value="4">第4周</option>
            <option value="5">第5周</option>
            <option value="6">第6周</option>
            <option value="7">第7周</option>
            <option value="8">第8周</option>
            <option value="9">第9周</option>
            <option value="10">第10周</option>
            <option value="11">第11周</option>
            <option value="11">第12周</option>
            <option value="13">第13周</option>
            <option value="14">第14周</option>
            <option value="15">第15周</option>
            <option value="16">第16周</option>
            <option value="17">第17周</option>
            <option value="18">第18周</option>
            <option value="19">第19周</option>
            <option value="20">第20周</option>
            <option value="21">第21周</option>
            <option value="22">第22周</option>
            <option value="23">第23周</option>
            <option value="24">第24周</option>
            <option value="25">第25周</option>
        </select>
    </span>
    <%--<span  ng-show="show==0" >星期<input class="tablesearchbtn1" style="width: 50px" type="text" ng-model="week2"  id="week2" name="week2"/></span>--%>
     <span  ng-show="show==0" >星期:
        <select type="text" ng-model="week2" name="week2"  class="forminput"/>
            <option value="">--请选择--</option>
            <option value="1">星期一</option>
            <option value="2">星期二</option>
            <option value="3">星期三</option>
            <option value="4">星期四</option>
            <option value="5">星期五</option>
            <option value="6">星期六</option>
            <option value="7">星期日</option>
         </select>
    </span>
    <%--<span  ng-show="show==0" >第<input class="tablesearchbtn1" style="width: 50px" type="text" ng-model="week3"  id="week3" name="week3"/>节</span>--%>
    <span  ng-show="show==0" >节次：
       <select type="text" ng-model="week3" name="week3"  class="forminput"/>
            <option value="">--请选择--</option>
            <option value="1">第一大节</option>
            <option value="2">第二大节</option>
            <option value="3">第三大节</option>
            <option value="4">第四大节</option>
            <option value="5">第五大节</option>
        </select>
    </span>
    <input ng-show="show==3" class="tablesearchbtn2" type="text" ng-model="input.keyword" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
        <span ng-show="show==3">周次：
         <select type="text" ng-model="week11" name="week11" class="forminput"/>
            <option value="">--请选择--</option>
            <option value="1">第1周</option>
            <option value="2">第2周</option>
            <option value="3">第3周</option>
            <option value="4">第4周</option>
            <option value="5">第5周</option>
            <option value="6">第6周</option>
            <option value="7">第7周</option>
            <option value="8">第8周</option>
            <option value="9">第9周</option>
            <option value="10">第10周</option>
            <option value="11">第11周</option>
            <option value="11">第12周</option>
            <option value="13">第13周</option>
            <option value="14">第14周</option>
            <option value="15">第15周</option>
            <option value="16">第16周</option>
            <option value="17">第17周</option>
            <option value="18">第18周</option>
            <option value="19">第19周</option>
            <option value="20">第20周</option>
            <option value="21">第21周</option>
            <option value="22">第22周</option>
            <option value="23">第23周</option>
            <option value="24">第24周</option>
            <option value="25">第25周</option>
        </span>
    </span>
    <%--<span  ng-show="show==3" >星期<input class="tablesearchbtn2" style="width: 50px" type="text" ng-model="week21"  id="week21" name="week21"/></span>--%>
    <span  ng-show="show==3" >星期
        <select type="text" ng-model="week21" name="week21"  class="forminput"/>
            <option value="">--请选择--</option>
            <option value="1">星期一</option>
            <option value="2">星期二</option>
            <option value="3">星期三</option>
            <option value="4">星期四</option>
            <option value="5">星期五</option>
            <option value="6">星期六</option>
            <option value="7">星期日</option>
        </select>
    </span>
    <span  ng-show="show==3" >节次：
        <select type="text" ng-model="week31" name="week31"  class="forminput"/>
            <option value="">--请选择--</option>
            <option value="1">第一大节</option>
            <option value="2">第二大节</option>
            <option value="3">第三大节</option>
            <option value="4">第四大节</option>
            <option value="5">第五大节</option>
       </select>
    </span>
    <table-btn  ng-show="show==3" id="search2" ng-click="showlog1()">搜索</table-btn>
    <table-btn  ng-show="show==0" id="search1" ng-click="loadeducateTask()">搜索</table-btn>
    <table-btn ng-show="show=='1'||show=='4'"ng-click="previous2()">返回</table-btn>
    <table-btn ng-show="show=='1'"ng-click="adjust_new()" >添加调整课程</table-btn>
    <table-btn ng-show="show=='4'"ng-click="adjust_stop()" >添加停课课程</table-btn>
</div>
<!--第一页-->
<div class="tablebox" ng-show="show=='0'">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>课程名</th>
        <th>所分班级</th>
        <th>班级教师</th>
        <th>任课单位</th>
        <th>授课周时</th>
        <th>上课时间</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="teachtask in teachtasks">
            <td class="thischecked" ng-click="thischecked(teachtask)">
                <input  type="checkbox" id="kind" ng-model="teachtask.td0" name="tc_id" value="{{teachtask.tc_id}}"/>
            </td>
            <td ng-bind="teachtask.chineseName"></td>
            <td ng-bind="teachtask.tc_class"></td>
            <td ng-bind="teachtask.teacherName"></td>
            <td ng-bind="teachtask.assumeUnit"></td>
            <td ng-bind="'第'+teachtask.tc_thweek_start+'至'+teachtask.tc_thweek_end+'周|'+teachtask.tc_teachodd" ></td>
            <td >
                <b ng-repeat="weektime in teachtask.times">
                    <span ng-bind="'星期'+weektime.al_timeweek"></span>
                    <b ng-repeat="jieshu in weektime.jie">
                        <span ng-bind="'第'+jieshu.al_timepitch+'节|地点'+jieshu.classroomName"></span>
                    </b>
                    <br/>
                </b>
            </td>
            <td><table-btn ng-click="firstadjust(teachtask)">调整</table-btn>&nbsp&nbsp<table-btn ng-click="firststop(teachtask)">停课</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="tablebox" ng-show="show=='3'">
    <table class="table">
        <thead>
        <th>类别</th>
        <th>课程名</th>
        <th>所分班级</th>
        <th>调整|停课周</th>
        <th>原上课时间</th>
        <th>原授课教师</th>
        <th>调整到周</th>
        <th>调整|停课时间</th>
        <th>调整教师</th>
        <th>调整教室</th>
        <th>调整日期</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="log in logs">
            <td ng-bind="log.type"></td>
            <td ng-bind="log.chineseName"></td>
            <td ng-bind="log.class"></td>
            <td ng-bind="log.odd_teachweek"></td>
            <td ng-if="log.type=='停课'">停课</td>
            <td  ng-if="log.type=='调课'" ng-bind="'星期'+log.odd_week+' 第'+log.odd_pitch+'节'"></td>
            <td ng-bind="log.odd_teachName"></td>
            <td ng-if="log.type=='停课'">停课</td>
            <td ng-if="log.type=='调课'" ng-bind="log.now_teachweek"></td>
            <td ng-bind="'星期'+log.now_timeweek+' 第'+log.now_timepitch+'节'"></td>
            <td ng-if="log.type=='调课'" ng-bind="log.teacherName"></td>
            <td ng-if="log.type=='调课'" ng-bind="log.classroomName"></td>
            <td ng-if="log.type=='停课'">停课</td>
            <td ng-if="log.type=='停课'">停课</td>
            <td ng-bind="log.settime"></td>
            <td ng-if="log.type=='调课'" >
                <table-btn ng-click="edit(log)">修改</table-btn>&nbsp&nbsp
                <table-btn ng-click="dellog(log)">删除</table-btn>
            </td>
            <td ng-if="log.type=='停课'" >
                <table-btn ng-click="editthis(log)">修改</table-btn>&nbsp&nbsp
                <table-btn ng-click="dellog(log)">删除</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<!--分页-->
<div class="pagingbox">
    <paging></paging>
</div>
<div class="black"></div>
<%--点击排课第一个页面--%>
<div class="tablebox" ng-show="show=='1'">
    <table class="table">
        <thead>
        <th>调整周</th>
        <th>原上课时间</th>
        <th>调整到周</th>
        <th>调整时间</th>
        <th>调整教师</th>
        <th>调整教室</th>
        <th>调整日期</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="adjust in adjustlist">
            <td ng-bind="adjust.odd_teachweek"></td>
            <td ng-bind="'星期'+adjust.odd_week+' 第'+adjust.odd_pitch+'节'"></td>
            <td ng-bind="adjust.now_teachweek"></td>
            <td ng-bind="'星期'+adjust.now_timeweek+' 第'+adjust.now_timepitch+'节'"></td>
            <%--<th ng-bind="adjust.now_timepitch"></th>--%>
            <td ng-bind="adjust.teacherName"></td>
            <td ng-bind="adjust.classroomName"></td>
            <td ng-bind="adjust.settime"></td>
            <td>
                <table-btn ng-click="edit(adjust)">修改</table-btn>&nbsp&nbsp
                <table-btn ng-click="del(adjust)">删除</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<%--停课--%>
<div class="tablebox" ng-show="show=='4'">
    <table class="table">
        <thead>
        <th>停课周</th>
        <th>停课星期</th>
        <th>停课节次</th>
        <th>调整日期</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="adjust in adjustlist">
            <td ng-bind="adjust.odd_teachweek"></td>
            <td ng-bind="'星期'+adjust.now_timeweek"></td>
            <td ng-bind="'第'+adjust.now_timepitch+'节'"></td>
            <td ng-bind="adjust.settime"></td>
            <td>
                <table-btn ng-click="editthis(adjust)">修改</table-btn>&nbsp&nbsp
                <table-btn ng-click="del(adjust)">删除</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<%--添加调课--%>
<div class="table-addform container-fluid a-show" id="add" style="height: 100%" >
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：手动调整排课 > 添加/修改
    <hr>
    <form id="Form" >
        <div class="row" style="margin-left: 60px">
            <ul class="col-sm-3 col-xs-3">
             <li><span class="span_width">调整的周：</span>
                 第 <input type="text" ng-model="newadjustcourse.odd_teachweek" id="odd_teachweek" name="odd_teachweek" class="forminput" style="width: 50px;margin-right: 10px;margin-left: 10px"/>周
             </li>
             <li>
                    <span class="span_width" >调整的星期：</span>
                    <select type="text" ng-model="newadjustcourse.odd_week" name="odd_week" class="forminput" id="odd_week"/>
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
                    <span class="span_width" style="width: 100px">调整的节次：</span>
                    <select type="text" ng-model="newadjustcourse.odd_pitch" name="odd_pitch" class="forminput" id="odd_pitch"/>
                    <option value="">--请选择--</option>
                    <option value="1">第一节</option>
                    <option value="2">第二节</option>
                    <option value="3">第三节</option>
                    <option value="4">第四节</option>
                    <option value="5">第五节</option>
                    </select>
             </li>
             <li><span class="span_width">调整到周：</span>
                 第<input type="text" ng-model="newadjustcourse.now_teachweek" class="forminput" style="width: 50px;margin-right: 10px;margin-left: 10px"/>周
             </li>
                <li>
                    <span class="span_width">上课日期：</span>
                    <select type="text" ng-model="newadjustcourse.now_timeweek" name="now_timeweek" class="forminput" id="now_timeweek"/>
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
                    <select type="text" ng-model="newadjustcourse.now_timepitch" name="al_timepitch" class="forminput" id="now_timepitch"/>
                    <option value="">--请选择--</option>
                    <option value="1">第一节</option>
                    <option value="2">第二节</option>
                    <option value="3">第三节</option>
                    <option value="4">第四节</option>
                    <option value="5">第五节</option>
                    </select>
                </li>
             <li>
             <span class="span_width">调整教室：</span>
                 <select type="text" ng-model="newadjustcourse.now_room" name="now_room" class="forminput" id="now_room"/>
                 <option  value="">--请选择--</option>
                 <option ng-repeat="usingClassRoom in usingClassRooms" value="{{usingClassRoom.classroomId}}">{{usingClassRoom.classroomName}}</option>
                 </select>
             </li>
                <li>
                    <span class="span_width">调整教师：</span>
                      <select  ng-model="newadjustcourse.now_teachName" name="now_teachName" class="forminput" id="now_teachName">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options3" value="{{option.teacherId}}" ng-bind="option.teacherName"></option>
                      </select>
                     </select>
                </li>
             </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
<div class="table-addform container-fluid a-show" id="stop" style="height: 100%" >
    <form id="Form2" >
        <div class="row" style="margin-left: 60px">
            <ul class="col-sm-3 col-xs-3">
                <li><span class="span_width">停课周：</span>
                    第 <input type="text" ng-model="newadjustcourse.odd_teachweek" name="odd_teachweek" class="forminput" style="width: 50px;margin-right: 10px;margin-left: 10px"/>周
                </li>
                <li>
                    <span class="span_width">停课星期：</span>
                    <select type="text" ng-model="newadjustcourse.now_timeweek" name="now_timeweek" class="forminput"/>
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
                    <span class="span_width">停课节次：</span>
                    <select type="text" ng-model="newadjustcourse.now_timepitch" name="al_timepitch" class="forminput"/>
                    <option value="">--请选择--</option>
                    <option value="1">第一节</option>
                    <option value="2">第二节</option>
                    <option value="3">第三节</option>
                    <option value="4">第四节</option>
                    <option value="5">第五节</option>
                    </select>
                </li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm" ng-click="stopthis()">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancelthis()">取消</span>
        </div>
    </form>
</div>
<div class="table-courseshow">
    <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <ul style="margin-left: 200px">
            <li><span class="span_width">停课周：</span>
                第 <input type="text" ng-model="odd_teachweek" name="odd_teachweek" class="forminput" style="width: 50px;margin-right: 10px;margin-left: 10px"/>周
            </li>
            <li>
                <span class="span_width">停课星期：</span>
                <select type="text" ng-model="now_timeweek" name="now_timeweek" class="forminput"/>
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
                <span class="span_width">停课节次：</span>
                <select type="text" ng-model="now_timepitch" name="al_timepitch" class="forminput"/>
                <option value="">--请选择--</option>
                <option value="1">第一节</option>
                <option value="2">第二节</option>
                <option value="3">第三节</option>
                <option value="4">第四节</option>
                <option value="5">第五节</option>
                </select>
            </li>
        </ul>
    </div>
    <table-btn class="bttn" ng-click="confirmstop()">确认</table-btn><table-btn class="bttn" ng-click="close()">取消</table-btn>
</div>
<%--查看日志--%>
</body>
</html>
<script>
    var load_log=false;
    var num=0;
    var add_edit=false;
    var add=false;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载初始数据
        $scope.show = 0;
        $scope.isadjust_new = true;
        $scope.checklist=[];
        $scope.checkitem={};
        $scope.all = false;
        $scope.jieci=[
            {id:1,jienum:"第一大节",checked:false},
            {id:2,jienum:"第二大节",checked:false},
            {id:3,jienum:"第三大节",checked:false},
            {id:4,jienum:"第四大节",checked:false},
            {id:5,jienum:"第五大节",checked:false}
        ];
        $scope.updateSel = function  (tr) {
            if($scope.jieci[tr].checked==true){
                $scope.jieci[tr].checked=false;
            }else{
                $scope.jieci[tr].checked=true;
            }
        };
        $scope.loadeducateTask=function () {
            $scope.show=0;
            load_log=false;
            loading();//加载层
            $(".pagingbox").show();
            if($scope.week1 === undefined){
                $scope.week1 = "";
            };
            if($scope.week2 === undefined){
                $scope.week2 = "";
            };
            if($scope.week3 === undefined){
                $scope.week3 = "";
            };
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("educateTaskcopy_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr,week1:$scope.week1,week2:$scope.week2,week3:$scope.week3},function (data) {
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
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
        };
        $scope.loadeducateTask();
        $scope.loadTeacher=function(){
            remotecall("basic_courseteacher_load",'',function (data) {
                $scope.options3 = data;
                closeLoading();//关闭加载层
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载班级教师失败");
                console.log(data);
            });
        }
        //加载使用中的教室
        $scope.loadUsingClassRoom = function () {
            loading();//加载
            remotecall("basic_classroom_load",{pageNum:pageNum,pageSize:pageSize,searchStr:''},function (data) {
                $scope.usingClassRooms=[];
                $scope.usingClassRooms = data.rows;
                closeLoading();//关闭加载层
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无可使用教室");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载教室失败" );
                console.log(data);
            });
        };
        $scope.firstadjust=function (teachtask) {
            $scope.all = false;
            for(i=0;i<$scope.teachtasks.length;i++){
                $scope.teachtasks[i].td0=false;
            }
            $scope.checklist=[];
            $scope.checkitem={};
            $scope.addadjust(teachtask);
        };
        $scope.firststop=function (teachtask) {
            $scope.all = false;
            for(i=0;i<$scope.teachtasks.length;i++){
                $scope.teachtasks[i].td0=false;
            }
            $scope.checklist=[];
            $scope.checkitem={};
            $scope.stop(teachtask);
        };
        //加载调课
        $scope.addadjust=function (teachtask) {
            loading();
            $scope.checklist.push(teachtask);
            $scope.checkitem=$scope.checklist[0];
            $(".pagingbox").hide();
            $scope.show = 1;
            remotecall("basic_adjustlist_load",{tc_id:$scope.checkitem.tc_id},function (data) {
                closeLoading();//关闭加载层
                $scope.adjustlist = data;
            },function (data) {
                closeLoading();//关闭加载层
            });
        }
        //加载停课
        $scope.stop=function (teachtask) {
            loading();
            $scope.checklist.push(teachtask);
            $scope.checkitem=$scope.checklist[0];
            $(".pagingbox").hide();
            $scope.show = 4;
            remotecall("basic_adjustliststop_load",{tc_id:$scope.checkitem.tc_id},function (data) {
                closeLoading();//关闭加载
                $scope.adjustlist = data;
            },function (data) {
                closeLoading();//关闭加载层
            });
        }
        $scope.loadUsingClassRoom();
        $scope.loadTeacher();
        //新建添加
        $scope.adjust_new=function () {
            $scope.isadjust_new = true;
            add_edit=true;
            $scope.newadjustcourse={};
            $scope.newadjustcourse.now_teachName=$scope.checkitem.tc_classteacherid;
            $("#add").show();
        }
        $scope.adjust_stop=function () {
            $("#stop").show();
            add=true;
            $scope.newadjustcourse={};
        }
        $scope.editthis=function (adjust) {
            $scope.newadjustcourse=adjust;
            $("#stop").show();
            add=false;
        }
        $scope.edit=function (adjust) {
            $scope.isadjust_new = false;
            add_edit=false;
            $scope.newadjustcourse={};
            $scope.newadjustcourse=adjust;
            $("#add").show();
        }
        $scope.del=function (adjust) {
            parent.pConfirm("确认删除吗？", function () {
            loading();
            remotecall("teacher_adjustcourse_del",adjust,function (data) {
                if(data){closeLoading();
                    if($scope.show=='4'){
                        $scope.stop();
                        $scope.$apply();
                    } else{
                        $scope.addadjust();
                        $scope.$apply();
                    }
                    parent.pMsg("删除成功");}
                else{closeLoading();parent.pMsg("删除失败");}
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("设置失败");
            });});
        }
        $scope.dellog=function (log) {
            parent.pConfirm("确认删除吗？", function () {
                loading();
                remotecall("teacher_adjustcourse_del",log,function (data) {
                    if(data){closeLoading();
                        $scope.showlog();
                        parent.pMsg("删除成功");
                        $scope.$apply();
                    }
                    else{closeLoading();parent.pMsg("删除失败");}
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("设置失败");
                });});

        }
        //点击取消按钮
        $scope.cancel=function () {
            $("#add").hide();
            if($scope.show=='3'){
                $scope.showlog();
            } else{
                $scope.addadjust();
            }
            $scope.newadjustcourse={};
        };
        $scope.close=function () {
            $(".table-courseshow,.black").hide();
        }
        $scope.confirmstop=function () {
            $scope.checkitem = $scope.checklist;
            if($scope.odd_teachweek==null||$scope.odd_teachweek==''){
                parent.pMsg("请填写周");
                return;
            }
            if($scope.now_timeweek==null||$scope.now_timeweek==''){
                parent.pMsg("请填写星期");
                return;
            }
            if($scope.now_timepitch==null||$scope.now_timepitch==''){
                parent.pMsg("请填写节次");
                return;
            }
            for(var i=0;i< $scope.checkitem.length;i++){
                $scope.checkitem[i].odd_teachweek=$scope.odd_teachweek;
                $scope.checkitem[i].now_timeweek=$scope.now_timeweek;
                $scope.checkitem[i].now_timepitch=$scope.now_timepitch;
                $scope.checkitem[i].courseId=$scope.checkitem[i].tc_courseid
                $scope.checkitem[i].class=$scope.checkitem[i].tc_class;
                $scope.checkitem[i].odd_teachName=$scope.checkitem[i].teacherName;
            }
            parent.pConfirm("确认设置选中课程停课吗？",function () {
                loading();//加载层
                remotecall("teacher_adjustcoursestopsome_add",{checkitem:$scope.checkitem},function (data) {
                    closeLoading();
                    $(".table-courseshow,.black").hide();
                    if(data){parent.pMsg("设置成功")}
                    else{parent.pMsg("设置失败");}
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("设置失败");
                });});
        }
        $scope.cancelthis=function () {
            $("#stop").hide();
            if($scope.show==3){
                $scope.showlog();
            }else{
                $scope.stop();
            }
            $scope.newadjustcourse={};
        };
        $scope.previous2=function () {
            $scope.checklist=[];
            $scope.checkitem={};
            $scope.loadeducateTask();
        }
        $scope.previous3=function () {
            $scope.checklist=[];
            $scope.checkitem={};
            pageNum=1;
            $scope.loadeducateTask();
        }
        $scope.showlog=function(){
            loading();
            load_log=true;
//            week1=$("#week11").val();
//            week2=$("#week21").val();
//            week3=$("#week31").val();
            if($scope.week11 === undefined){
                $scope.week11 = "";
            };
            if($scope.week21 === undefined){
                $scope.week21 = "";
            };
            if($scope.week31 === undefined){
                $scope.week31 = "";
            };
            $(".pagingbox").show();
            $scope.show = 3;
            remotecall("basic_manualadjustcourse_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr,week1:$scope.week11,week2:$scope.week21,week3:$scope.week31},function (data) {
                closeLoading();//关闭加载层
                $scope.logs = data.rows;//加载的数据对象，‘courses’根据不同需求而变
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
                parent.pMsg("加载数据失败");
                console.log(data);
            });
        }
        //表单验证
        $("#Form").validate({
            submitHandler:function(form){
                var thisadjust={};
                thisadjust.tc_id=$scope.checkitem.tc_id;
                thisadjust.courseId=$scope.checkitem.tc_courseid;
                thisadjust.class=$scope.checkitem.tc_class;
                thisadjust.now_timepitch=$scope.newadjustcourse.now_timepitch;
                thisadjust.odd_teachName=$scope.checkitem.teacherName;
                thisadjust.now_timeweek=$scope.newadjustcourse.now_timeweek;
                thisadjust.odd_teachweek=$scope.newadjustcourse.odd_teachweek;
                thisadjust.now_teachweek=$scope.newadjustcourse.now_teachweek;
                thisadjust.now_teachName=$scope.newadjustcourse.now_teachName;
                thisadjust.now_room=$scope.newadjustcourse.now_room;
                thisadjust.odd_week=$scope.newadjustcourse.odd_week;
                thisadjust.odd_pitch= $scope.newadjustcourse.odd_pitch;
                if($scope.show!='3'){
                    if(thisadjust.odd_teachweek<$scope.checkitem.tc_thweek_start||thisadjust.odd_teachweek>$scope.checkitem.tc_thweek_end){
                        parent.pMsg("调整周 不在上课区间范围内");
                        return;
                    }
                    if($scope.checkitem.tc_teachodd=='单周'&& (thisadjust.odd_teachweek%2==0 )){
                        parent.pMsg("请选择单周调整");
                        return;
                    }
                    if($scope.checkitem.tc_teachodd=='双周'&& (thisadjust.odd_teachweek%2==1 )){
                        parent.pMsg("请选择双周调整");
                        return;
                    }
                    var flag=true;
                    for(var j=0;j<$scope.checkitem.times.length;j++){
                        if(thisadjust.odd_week==$scope.checkitem.times[j].al_timeweek){
                            for(var z=0;z<$scope.checkitem.times[j].jie.length;z++)
                                if(thisadjust.odd_pitch==$scope.checkitem.times[j].jie[z].al_timepitch){
                                    flag=false;
                                    break;
                                }if(flag==false){
                                break;
                            }
                        }
                        if(j==$scope.checkitem.times.length-1){
                            parent.pMsg("原来没有该节次的课");
                            return;
                        }
                    }
                }
                //验证通过,然后就保存
                if(add_edit){
                    loading();
                    remotecall("teacher_adjustcourse_add",thisadjust,function (data) {
                            if(data.result){closeLoading();parent.pMsg("设置成功");  $scope.addadjust();$("#add").hide();}
                            else{closeLoading();parent.pMsg(data.message);}
                    },function (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("设置失败");
                            $("#add").hide();
                            console.log(data);
                    });
                }else{
                    thisadjust.mac_id=$scope.newadjustcourse.mac_id;
                    if($scope.show==3){
                        thisadjust.tc_id=$scope.newadjustcourse.tc_id;
                    }
                    loading();
                    remotecall("teacher_adjustcourse_edit",thisadjust,function (data) {
                        if(data.result){closeLoading();parent.pMsg("设置成功"); $("#add").hide();
                            if($scope.show==3){
                                $scope.showlog();
                            }else{$scope.addadjust();}
                        }
                        else{closeLoading();parent.pMsg(data.message);}
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("设置失败");
                        $("#add").hide();
                        console.log(data);
                    });
                }
            },
            rules:{
                odd_teachweek:{
                    required:true
                }
            },
            messages:{
                odd_teachweek:{
                    required:"请输入想要调整的周"
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
        $("#Form2").validate({
            submitHandler:function(form){
                var thisadjust={};
                thisadjust.now_timepitch=$scope.newadjustcourse.now_timepitch;
                thisadjust.now_timeweek=$scope.newadjustcourse.now_timeweek;
                thisadjust.odd_teachweek=$scope.newadjustcourse.odd_teachweek;
                if($scope.show != 3){
                    thisadjust.tc_id=$scope.checkitem.tc_id;
                    thisadjust.courseId=$scope.checkitem.tc_courseid;
                    thisadjust.class=$scope.checkitem.tc_class;
                    thisadjust.odd_teachName=$scope.checkitem.teacherName;
                    if(thisadjust.odd_teachweek<$scope.checkitem.tc_thweek_start||thisadjust.odd_teachweek>$scope.checkitem.tc_thweek_end){
                        parent.pMsg("停课周 不在上课区间范围内");
                        return;
                    }
                    if($scope.checkitem.tc_teachodd=='单周'&& (thisadjust.odd_teachweek%2==0)){
                        parent.pMsg("请输入单周");
                        return;
                    }
                    if($scope.checkitem.tc_teachodd=='双周'&& (thisadjust.odd_teachweek%2==1)){
                        parent.pMsg("请输入双周");
                        return;
                    }
                    var flag=true;
                    for(var j=0;j<$scope.checkitem.times.length;j++){
                        if(thisadjust.now_timeweek==$scope.checkitem.times[j].al_timeweek){
                            for(var z=0;z<$scope.checkitem.times[j].jie.length;z++)
                                if(thisadjust.now_timepitch==$scope.checkitem.times[j].jie[z].al_timepitch){
                                    flag=false;
                                    break;
                                }if(flag==false){
                                break;
                            }
                        }
                        if(j==$scope.checkitem.times.length-1){
                            parent.pMsg("原来没有该节次的课");
                            return;
                        }
                    }
                }
                if(add){
                    loading();
                    remotecall("teacher_adjustcoursestop_add",thisadjust,function (data) {
                        if(data){closeLoading();parent.pMsg("设置成功"); $("#stop").hide(); $scope.stop();}
                        else{closeLoading();parent.pMsg("设置失败");}
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("设置失败");
                        $("#stop").hide();
                        console.log(data);
                    });
                }else{
                    thisadjust.mac_id=$scope.newadjustcourse.mac_id;
                    loading();
                    remotecall("teacher_adjustcoursestop_edit",thisadjust,function (data) {
                        if(data){closeLoading();parent.pMsg("设置成功"); $("#stop").hide();
                            if($scope.show==3){$scope.showlog();}else{$scope.stop();}}
                        else{closeLoading();parent.pMsg("设置失败");
                            }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("设置失败");
                        $("#stop").hide();
                        console.log(data);
                    });
                }
            },
            rules:{
                odd_teachweek:{
                    required:true
                }
            },
            messages:{
                odd_teachweek:{
                    required:"请输入想要调整的周"
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
        $scope.somestop=function () {
            if($("input[name='tc_id']:checked").length<1){
                parent.pMsg("请选择一条记录");
                return;
            }
            $(".table-courseshow,.black").show();
        }
        //checked 复选框判断
        $scope.allfn = function  () {
            if($scope.all == false){
                for(i=0;i<$scope.teachtasks.length;i++){
                    $scope.teachtasks[i].td0=false;
                }
                $scope.checklist=[];
                num=0;
            }else{
                $scope.checklist=[];
                for(i=0;i<$scope.teachtasks.length;i++){
                    $scope.teachtasks[i].td0=true;
                    $scope.checklist.push($scope.teachtasks[i]);
                }
                num=$scope.teachtasks.length;
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
            if(num==$scope.teachtasks.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        $scope.showlog1=function () {
            pageNum=1;
            $scope.showlog();
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
                if(load_log){
                    pageNum = pn;//改变当前页
                    //重新加载用户信息
                    $scope.showlog();
                }
                else{
                    pageNum = pn;//改变当前页
                    //重新加载用户信息
                    $scope.loadeducateTask();
                }
            }
        };
    });

    //绑定回车事件
    $('.tablesearchbtn1').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#search1").click();
        }
    });
    $('.tablesearchbtn2').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#search2").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
