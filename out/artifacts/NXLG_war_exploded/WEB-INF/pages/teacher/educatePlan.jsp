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
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：培养计划
<hr>
<!--导航筛选-->
<table-nav>
    <li ng-click="dofilter(1)" class="sele">现有培养计划</li>
    <li ng-click="dofilter(0)">待审核培养计划</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="add()" ng-if="Var==false"><img src="<%=request.getContextPath()%>/images/tableadd_07.png"/>新建—培养计划</table-btn>
    <table-btn ng-click="insert()" ng-if="Var==false"><img src="<%=request.getContextPath()%>/images/icon_import.png" />上传培养计划</table-btn>
    <table-btn ng-click="getModel()" ng-if="Var==false"><img src="<%=request.getContextPath()%>/images/icon_download.jpg" />下载模板</table-btn>

    <input ng-show="show=='2'" class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
    <input ng-show="show=='1'" class="tablesearchbtn" type="text" ng-model="input.keywordCourse" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr2(this)"/>
    <table-btn ng-if="show=='1'" id="searchCourse" ng-click="loadCourse()">搜索</table-btn>
    <table-btn ng-if="show=='2'" id="search" ng-click="loadData()">搜索</table-btn>
    <table-btn ng-if="show=='1'" ng-click="previous()">返回</table-btn>
</div>
<!--培养计划列表-->
<div class="tablebox" id="allInfo">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th>年级</th>
        <th>学院</th>
        <th>专业</th>
        <th>学期</th>
        <th>课程</th>
        <th>课程类别一</th>
        <th>培养平台</th>
        <th>考核方式</th>
        <th>周时</th>
        <th>备注</th>
        <th>审核状态</th>
        <th ng-if="Var">审核类别</th>
        <th ng-if="Var">未通过原因</th>
        <th style="width: 160px;"></th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-bind="Info.ep_grade"></td>
            <td ng-bind="Info.ep_college"></td>
            <td ng-bind="Info.ep_major"></td>
            <td ng-bind="Info.ep_term"></td>
            <td ng-bind="Info.chineseName"></td>
            <td ng-bind="Info.courseCategory_1"></td>
            <td ng-bind="Info.ep_terrace"></td>
            <td ng-bind="Info.ep_checkway"></td>
            <td ng-bind="Info.ep_week"></td>
            <td ng-bind="Info.ep_note" style="word-break:break-all"></td>
            <td ng-bind="Info.ep_checkStatus"></td>
            <td  ng-if="Var" ng-bind="Info.ep_checkType"></td>
            <td  ng-if="Var" ng-bind="Info.ep_refuseReason" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"
                 ng-click="ReasonDetail(Info.ep_refuseReason,$index)" class="Ar"></td>
            <td><table-btn ng-if="!Var" ng-click="edit(Info)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="del(Info)">删除</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--课程列表--%>
<div class="tablebox" id="course">
    <table class="table">
        <thead>
        <th>课程代码</th>
        <th>中文名称</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th>理论学分</th>
        <th>实践学分</th>
        <th>总学分</th>
        <th>讲授学时</th>
        <th>实验学时</th>
        <th>上机学时</th>
        <th>其他学时</th>
        <th>总学时</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="course in courses">
            <td ng-bind="course.courseCode"></td>
            <td ng-bind="course.chineseName"></td>
            <td ng-bind="course.courseCategory_3"></td>
            <td ng-bind="course.courseCategory_4"></td>
            <td ng-bind="course.courseCategory_5"></td>
            <td ng-bind="course.theoreticalCredit"></td><td ng-bind="course.practiceCredit"></td>
            <td ng-bind="course.totalCredit"></td>
            <td ng-bind="course.teachingTime"></td><td ng-bind="course.experimentalTime"></td>
            <td ng-bind="course.machineTime"></td><td ng-bind="course.otherTime"></td>
            <td ng-bind="course.totalTime"></td>
            <td><table-btn ng-click="setCourse(course)">设置</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--培养计划设置页面--%>
<div class="table-addform container-fluid a-show">
    <form id="Form">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li><span class="span_width">年级：</span>
                    <select type="text" ng-model="checkitem.ep_grade" name="ep_grade" class="forminput" id="ep_grade"/>
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in grades" value="{{option.year}}" ng-bind="option.year"></option>
                    </select>
                </li>
                <li ng-if="teacher"><span class="span_width">学院：</span>
                    <select ng-change="changeCollege(checkitem.ep_college)" type="text" ng-model="checkitem.ep_college" name="ep_college" class="forminput" id="ep_college"/>
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in options_majorCollege" value="{{option.wordbookValue}}" ng-bind="option.wordbookValue"></option>
                    </select>
                </li>
                <li ng-if="teacher"><span class="span_width">专业：</span>
                    <select type="text" ng-model="checkitem.ep_major" name="ep_major" class="forminput" id="ep_major"/>
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in majors" value="{{option.majorName}}" ng-bind="option.majorName"></option>
                    </select>
                </li>
                <li><span class="span_width">学期：</span>
                    <select type="text" ng-model="checkitem.ep_term" name="ep_term" class="forminput" id="ep_term"/>
                    <option value="">--请选择--</option>
                    <option value="第一学期" >第一学期</option>
                    <option value="第二学期" >第二学期</option>
                    </select>
                </li>
            </ul>
            <ul class="col-sm-3 col-xs-3">
                <li>
                    <span class="span_width">课程类别一：</span>
                    <select type="text" ng-model="checkitem.courseCategory_1" name="courseCategory_1" class="forminput" id="courseCategory_1"/>
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in options_courseCategory_1" value="{{option.wordbookValue}}" ng-bind="option.wordbookValue"></option>
                    </select>
                </li>
                <li>
                    <span class="span_width">培养平台：</span>
                    <select type="text" ng-model="checkitem.ep_terrace" name="ep_terrace" class="forminput" id="ep_terrace"/>
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in options_ep_terrace" value="{{option.terraceName}}" ng-bind="option.terraceName"></option>
                    </select>
                </li>
                <li>
                    <span class="span_width">考核方式：</span>
                    <select type="text" ng-model="checkitem.ep_checkway" name="ep_checkway" class="forminput" id="ep_checkway"/>
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in options_ep_checkway" value="{{option.wordbookValue}}" ng-bind="option.wordbookValue"></option>
                    </select>
                </li>
                <%--<li><span class="span_width">开课学期：</span><input type="text" ng-model="checkitem.ep_courseterm" name="ep_courseterm" class="forminput" id="ep_courseterm"/></li>--%>
                <li><span class="span_width">周时：</span><input type="text" ng-model="checkitem.ep_week" name="ep_week" class="forminput" id="ep_week"/></li>
                <li><span class="span_width">备注：</span><input type="text" ng-model="checkitem.ep_note" name="ep_note" class="forminput" id="ep_note"/></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
<!--导入peiyangjih-->
<div id="insert-form"  style="display:none;width:400px;height:410px;padding:10px;position:absolute;border:3px #c5add7 solid; left:35%;top:15%;background-color:#ffffff;z-index: 10;">
    <div id="file_box" style="margin-bottom: 10px;margin-top: 10px;">
        <label>选择文件:</label>
        <input id="upfile" style="display: inline-block;width: 200px;" name="fileup" type="file"/>
        <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    </div>
    <div id="btn_box" style="margin-bottom: 10px;margin-top: 10px;">
        <a href="javascript:void(0)"  ng-click="validFile()">验证文件</a>&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="javascript:void(0)"  ng-click="uploadFile()">上传并导入</a>
    </div>
    <div id="result_box" style="margin-bottom: 10px;margin-top: 10px;">
        <label>操作结果:</label>
        <br>
        <div id="valid_result"  style="display: inline-block;width: 375px;height: 235px;border: 2px solid #c5add7;overflow: auto"></div>
    </div>
    <p style="color:#ff0000;">（导入培养计划时请选用给定的模板）</p>
    <%--批量导入对话框的按钮--%>
    <%--<div>--%>
        <%--<a href="javascript:void(0)" style="margin-left: 340px; color: white;background: #c5add7;" ng-click="close()">关闭</a>--%>
    <%--</div>--%>
</div>
<div class="black"></div>
</body>
</html>
<script>
    var filter=1;
    var add_edit=true;
    var now=(new Date()).getFullYear();
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.Var=false;
        $scope.show=2;
        $scope.teacher=false;
        $scope.checklist=[];
        $scope.checkitem={};
        $scope.grades=[{id:0,year:now},{id:1,year:now-1},{id:2,year:now-2},{id:3,year:now-3},{id:4,year:now-4}];
        //加载数据
        $scope.loadData = function (){
            $scope.show=2;
            $scope.checklist=[];
            $scope.checkitem={};
            $("#allInfo,.title,.pagingbox,.table-nav").show();
            $("#course,.table-addform,#insert-form").hide();
            if(!$scope.Var){
                $(".table-nav li:first").addClass("sele");
                $(".table-nav li:last").removeClass("sele");
            }else{
                $(".table-nav li:last").addClass("sele");
                $(".table-nav li:first").removeClass("sele");
            }
            loading();//加载
            remotecallasync("teacher_educatePlan_load",{filter:filter,pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                closeLoading();
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

                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            remotecall("teacher_educatePlan_loadgrade",'',function (data) {
                $scope.options_grade = data;
            },function (data) {
                parent.pMsg("暂无数据");
            });
            remotecall("teacher_educatePlan_loadcourseCategory_1",'',function (data) {
                $scope.options_courseCategory_1 = data;
            },function (data) {
                parent.pMsg("暂无数据");
            });
            remotecall("teacher_terraceCourse_loadcheckWay",'',function (data) {
                $scope.options_ep_checkway = data;
            },function (data) {
                parent.pMsg("暂无数据");
            });
            remotecall("teacher_educatePlan_loadterrace",'',function (data) {
                closeLoading();//关闭加载层
                $scope.options_ep_terrace = data;
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("暂无数据");
            });
            remotecall("isteacher",'',function (data) {
                closeLoading();//关闭加载层
                if(data=="管理员"){
                    $scope.teacher=true;
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("暂无数据");
            });
            remotecall("teacher_majorApply_load_majorCollege",'',function (data) {
                closeLoading();//关闭加载层
                $scope.options_majorCollege = data;
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载学院失败");
            });
        }
        $scope.loadData();
        //新增，所有课程
        $scope.loadCourse = function () {
            filter=1;
            $scope.show=1;
            $scope.Var=true;
            $("#course,.pagingbox,.title").show();
            $(".table-nav,#allInfo,.table-addform,#insert-form").hide();

            loading();//加载
            remotecall("teacher_educatePlan_loadCourse",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
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
        //加载所选学院的专业
        $scope.changeCollege=function (str) {
            remotecall("teacher_educatePlan_loadMajor",{ep_college:str},function (data) {
                $scope.majors = data;
            },function (data) {
                parent.pMsg("暂无数据");
            });
        }
        //新建—培养计划
        $scope.add = function () {
            add_edit=true;
            $('#course').addClass('a-show');
            $('#course').removeClass('a-hide');
            $('#allInfo,.table-nav').hide();
            $('#course,.title').show();
            pageNum=1;
            searchStr='';
            $('.tablesearchbtn').val('');
            $scope.loadCourse();
        };
        //修改
        $scope.edit= function (tr) {
            add_edit=false;
            $scope.checklist.push(tr);
            $scope.checkitem=$scope.checklist[0];
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-addform').show();
            $(".table-nav,#allInfo,#course,.pagingbox,.title").hide();
        };
        //选择一个课程进行设置
        $scope.setCourse = function  (tr) {
            $scope.checklist=[];
            $scope.checkitem={};
            $scope.checklist.push(tr);
            $scope.checkitem=$scope.checklist[0];
            remotecall("teacher_educatePlan_loadteacher",'',function (data) {
                if(data){
                    $scope.checkitem.ep_college = data[0].teachCollege;
                    console.log($scope.checkitem.ep_college);
                    $scope.checkitem.ep_major = data[0].teachMajor;
                }
            },function (data) {
                parent.pMsg("暂无数据");
            });
            $(".table-addform").show();
            $(".table-nav,#allInfo,#course,.pagingbox,.title,#insert-form").hide();
        };
        //右侧菜单栏
        $scope.dofilter=function(str){
            pageNum=1;
            if(str==0){//审核列表
                $scope.Var=true;
            }else if(str==1){
                $scope.Var=false;
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
                if($("#course").css("display")!="none"){
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
        }
        //返回上一级
        $scope.previous=function(){
            filter=1;
            $scope.Var=false;
            searchStr='';
            $scope.loadData();
        }
        //取消
        $scope.cancel=function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            },200);
            if(add_edit){
                searchStr='';
                $scope.loadCourse();
            }else{
                filter=1;
                $scope.Var=false;
                searchStr='';
                $scope.loadData();
            }
        }
        //导入
        $scope.insert=function () {
            $('#insert-form,.black').show();
        }
        $scope.close=function () {
            $('#insert-form,.black').hide();
            $("#valid_result,#file").empty();

        }
        //     验证文件
        $scope.validFile=function () {
            if(!$("#upfile").val()){
                layer.msg("请选择文件！");
                return;
            }
            loading();
            $.ajaxFileUpload({
                url: "<%=request.getContextPath()%>/EducatePlanupload/validate.form", //用于文件上传的服务器端请求地址
                secureuri: false, //一般设置为false
                fileElementId: "upfile", //文件上传空间的id属性
                dataType: 'String', //返回值类型 一般设置为String
                success: function (data, status)  //服务器成功响应处理函数
                {
                    closeLoading();//关闭加载层
                    $scope.showResult(data);
                    console.log(data.errormessage);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    closeLoading();//关闭加载层
                    layer.msg("上传文件失败，请重新上传");
                }
            });
        }
        /**
         * 上传文件
         */
        $scope.uploadFile=function () {
            if(!$("#upfile").val()){
                layer.msg("请选择文件！");
                return;
            }
            loading();
            $.ajaxFileUpload({
                url: "<%=request.getContextPath()%>/EducatePlanupload/EducatePlan.form", //用于文件上传的服务器端请求地址
                secureuri: false, //一般设置为false
                fileElementId: "upfile", //文件上传空间的id属性
                dataType: 'String', //返回值类型 一般设置为String
                success: function (data, status)  //服务器成功响应处理函数
                {
                    closeLoading();//关闭加载层
                    $scope.showResult(data);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    closeLoading();//关闭加载层
                    layer.msg("上传文件失败，请重新上传");
                }
            });
        }
        /*
         * 上传文件后显示服务器返回的信息
         * @param data
         */
        $scope.showResult=function (data){
            $("#valid_result").html("");
            //去除返回字符串的  <pre style="word-wrap: break-word; white-space: pre-wrap;"> 标签
            var str=data.substring(data.indexOf('>')+1,data.lastIndexOf('<'));
            var s= eval("("+str+")");
            var str=s.msg+"<br>";
            if(s.data){
                $.each(s.data,function(){
                    if(this.data){
                        str+="&nbsp;&nbsp;"+this.msg+"<br>";
                        $.each(this.data,function(){
                            str+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+this+"<br>";
                        })
                    }else{
                        str+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+this+"<br>";
                    }
                });
            }
            $("#valid_result").html(str);
        }
        //下载模版文件
        $scope.getModel=function () {
            try{
                var elemIF = document.createElement("iframe");
                elemIF.src = "../../files/educatePlan.xls";
                elemIF.style.display = "none";
                document.body.appendChild(elemIF);
            }catch(e){
            }
        }
        //确定
        $("#Form").validate({
            submitHandler:function(form){
                loading();
                if(add_edit){
                    remotecallasync("teacher_educatePlan_add",$scope.checkitem,function (data) {
                        closeLoading();//关闭加载层
                        if(data===0){
                            parent.pMsg("该培养计划已添加");
                        }else if(data===1){
                            parent.pMsg("该年级的课程不能属于不同的平台");
                        }else if(data){
                            parent.pMsg("添加成功");
                            $('.table-addform').hide();
                            $('#MenuForm input').val("");
                            pageNum=1;
                            filter=0;
                            $scope.Var=true;
                            $scope.loadData();
                            $scope.$apply();
                        }else {
                            parent.pMsg("添加失败");
                        }
                    },function (data) {
                        parent.pMsg("数据库请求失败");
                    });
                }else{
                    remotecallasync("teacher_educatePlan_edit", $scope.checkitem, function (data) {
                        closeLoading();//关闭加载层
                        if(data===0){
                            parent.pMsg("该培养计划已添加");
                        }else if(data===9){
                            parent.pMsg("该年级的课程不能属于不同的平台");
                        }else if(data===1){
                            parent.pMsg("系统正在审核，该专业不能进行新的操作")
                        }else if (data===2) {
                            parent.pMsg("修改成功");
                            pageNum=1;
                            filter=0;
                            $scope.Var=true;
                            $scope.loadData();
                            $scope.$apply();
                        }else {
                            parent.pMsg("修改失败");
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                }
                searchStr='';
            },
            rules:{
                ep_grade:{
                    required:true
                },
                ep_term:{
                    required:true
                },
                courseCategory_1:{
                    required:true
                },
                ep_terrace:{
                    required:true
                },
                ep_checkway:{
                    required:true
                },
                ep_week:{
                    required:true,
                    maxlength:45,
                    digits:true
                }
            },
            messages:{
                ep_grade:{
                    required:"必填项"
                },
                ep_term:{
                    required:"必填项"
                },
                courseCategory_1:{
                    required:"必填项"
                },
                ep_terrace:{
                    required:"必填项"
                },
                ep_checkway:{
                    required:"必填项"
                },
                ep_week:{
                    required:"必填项",
                    maxlength:"长度不超过45个字符",
                    digits:"输入值必须为整数"
                }
            },
            //重写showErrors
            showErrors: function (errorMap, errorList) {
                $.each(errorList, function (i, v) {
                    layer.tips(v.message, v.element, { time: 2000 });
                    return false;
                });
            },
            onfocusout: false
        });
        //删除一个
        $scope.del = function (tr) {
            $scope.checklist.push(tr);
            $scope.checkitem=$scope.checklist[0];
            parent.pConfirm("确认删除选中的内容吗？", function () {
                loading();
                remotecall("teacher_educatePlan_del", $scope.checkitem, function (data) {
                    closeLoading();//关闭加载层
                    if (data == 1) {
                        parent.pMsg("系统正在审核，该专业不能进行新的操作")
                    } else if (data == 2) {
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        $scope.loadData();
                        $scope.$apply();
                    }else { parent.pMsg("删除失败");}
                }, function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("删除请求失败");
                    console.log(data);
                });
            }, function (data) {
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
    });
    function getSearchStr2(obj) {
        pageNum = 1;
        searchStr = $(obj).val();
    }
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchCourse").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>