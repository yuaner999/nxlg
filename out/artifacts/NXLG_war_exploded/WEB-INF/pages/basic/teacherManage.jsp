<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-18
  Time: 8:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/font/jedate/jquery.jedate.min.js" type="text/javascript" charset="utf-8"></script><!--引入日历插件-->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/js/font/jedate/skin/jedate.css" /><!--日历CSS文件-->
    <style>
        .span_width{
            width: 90px;
        }
        .row{
            padding-left: 252px !important;
        }
        .forminput{
            margin-right:80px !important;
            width: 145px!important;
        }
        .text-center{
            padding-bottom: 30px;
        }
        .photo{
            position: absolute;
            left: 50px;
            top: 100px;
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
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教师管理
<hr>
<%--<table-nav>--%>
<%--<li class="sele">专业管理</li>--%>
<%--<li>课程管理</li>--%>
<%--<li>培养计划</li>--%>
<%--</table-nav>--%>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" />新建</table-btn>
    <table-btn ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <%--<table-btn ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>--%>
    <input class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadTeacher()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>工号</th>
        <th>教师姓名</th>
        <th>性别</th>
        <th>民族</th>
        <th>政治面貌</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="teacher in teachers">
            <td class="thischecked" ng-click="thischecked(teacher)">
                <input  type="checkbox" ng-model="teacher.td0" name="teacherIdSelect" value="{{teacher.teacherId}}"/><%--ng-checked="all"--%>
            </td>
            <td ng-bind="teacher.teacherNumber"></td>
            <td ng-bind="teacher.teacherName"></td>
            <td ng-bind="teacher.teacherGender"></td>
            <td ng-bind="teacher.nation"></td>
            <td ng-bind="teacher.politics"></td>
            <td><table-btn ng-click="edit(teacher)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="delete(teacher)">删除</table-btn></td>
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
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教师管理 > 新增/修改
    <hr>
    <form id="Form">
        <div class="row">
            <br class="col-sm-3 col-xs-3">
                <li style="display: none;"><span>ID：</span><input type="text" name="teacherId" class="forminput" /></li>
                <li><span class="span_width">工号：</span><input type="text" ng-model="checkitem.teacherNumber" name="teacherNumber" class="forminput" id="teacherNumber"/></li>
                <li><span class="span_width">教师姓名：</span><input type="text" ng-model="checkitem.teacherName" name="teacherName" class="forminput" id="teacherName"/></li>
                <div class="photo">
                    <ul class="col-sm-3 col-xs-3">
                        <img src="<%=request.getContextPath()%>/images/icon_error.png" id="PreView" style="margin-top:10px; width: 120px;height: 166px;"  name="teacherIcon" id="teacherIcon" ng-click="uploadIcon('#PreView')">
                    </ul>
                    <input type="text" class="btn" style="border: 0px; cursor:pointer;width:85px" value="选择照片" readonly="readonly" ng-click="uploadIcon('#PreView')"/>
                </div>
                <li>
                    <span class="span_width">性别：</span>
                    <select type="text" ng-model="checkitem.teacherGender" name="teacherGender" class="forminput" id="teacherGender"/>
                        <option value="">--请选择--</option>
                        <option value="男">男</option>
                        <option value="女">女</option>
                    </select>
                </li>
                <li><span class="span_width">民族：</span><input type="text" ng-model="checkitem.nation" name="nation" class="forminput" id="nation"/></li>
                <li>
                    <span class="span_width">政治面貌：</span>
                    <select type="text" ng-model="checkitem.politics" name="politics" class="forminput" id="politics"/>
                        <option value="">--请选择--</option>
                        <option value="中共党员">中共党员</option>
                        <option value="共青团员">共青团员</option>
                        <option value="群众">群众</option>
                        <option value="其他">其他</option>
                    </select>
                </li>
                <li><span class="span_width">加入时间：</span><input type="text" ng-model="checkitem.politicsDate" name="politicsDate" class="forminput" id="politicsDate"/></li>
                <li><span class="span_width">身份证号码：</span><input type="text" ng-model="checkitem.IDCard" name="IDCard" class="forminput" id="IDCard"/></li>
                <li><span class="span_width">出生日期：</span><input type="text" ng-model="checkitem.birthday" name="birthday" class="forminput" id="birthday"/></li>
                <li><span class="span_width">来校日期：</span><input type="text" ng-model="checkitem.schoolDate" name="schoolDate" class="forminput" id="schoolDate"/></li>
                <li><span class="span_width">所属部门：</span><input type="text" ng-model="checkitem.department" name="department" class="forminput" id="department"/></li>
                <li><span class="span_width">行政职务：</span><input type="text" ng-model="checkitem.administrative" name="administrative" class="forminput" id="administrative"/></li>
                <li><span class="span_width">任教单位：</span><input type="text" ng-model="checkitem.teachUnit" name="teachUnit" class="forminput" id="teachUnit"/></li>
                <li><span class="span_width">专业技术职务：</span><input type="text" ng-model="checkitem.duty" name="duty" class="forminput" id="duty"/></li>
                <li><span class="span_width">专业技术职务任职资格时间：</span><input type="text" ng-model="checkitem.dutyDate" name="dutyDate" class="forminput" id="dutyDate"/></li>
                <li>
                    <span class="span_width">专业技术职务等级：</span>
                    <select type="text" ng-model="checkitem.dutyLevel" name="dutyLevel" class="forminput" id="dutyLevel">
                        <option value="" selected="selected">--请选择--</option>
                        <option value="高级">高级</option>
                        <option value="中级">中级</option>
                        <option value="低级">低级</option>
                    </select>
                </li>
                <li><span class="span_width">学历：</span><input type="text" ng-model="checkitem.education" name="education" class="forminput" id="education"/></li>
                <li><span class="span_width">学历学习时间：</span><input type="text" ng-model="checkitem.educationDate" name="educationDate" class="forminput" id="educationDate"/></li>
                <li><span class="span_width">学历专业：</span><input type="text" ng-model="checkitem.educationMajor" name="educationMajor" class="forminput" id="educationMajor"/></li>
                <li><span class="span_width">学历获取机构：</span><input type="text" ng-model="checkitem.educationSchool" name="educationSchool" class="forminput" id="educationSchool"/></li>
                <li><span class="span_width">学缘结构：</span><input type="text" ng-model="checkitem.educationStructure" name="educationStructure" class="forminput" id="educationStructure"/></li>
                <li><span class="span_width">学位：</span><input type="text" ng-model="checkitem.degree" name="degree" class="forminput" id="degree"/></li>
                <li><span class="span_width">学位学习时间：</span><input type="text" ng-model="checkitem.degreeDate" name="degreeDate" class="forminput" id="degreeDate"/></li>
                <li><span class="span_width">学位专业：</span><input type="text" ng-model="checkitem.degreeMajor" name="degreeMajor" class="forminput" id="degreeMajor"/></li>
                <li><span class="span_width">学位获取机构：</span><input type="text" ng-model="checkitem.degreeSchool" name="degreeSchool" class="forminput" id="degreeSchool"/></li>
                <li><span class="span_width">高等教育资格证：</span><input type="text" ng-model="checkitem.certificate" name="certificate" class="forminput" id="certificate"/></li>
                <li><span class="span_width">高等教育资格证获得时间：</span><input type="text" ng-model="checkitem.certificateDate" name="certificateDate" class="forminput" id="certificateDate"/></li>
                <li><span class="span_width">从教时间：</span><input type="text" ng-model="checkitem.teachDate" name="teachDate" class="forminput" id="teachDate"/></li>
                <li>
                    <span class="span_width">任教学院：</span>
                    <select type="text" ng-model="checkitem.teachCollege" name="teachCollege" class="forminput" id="teachCollege" ng-change="getMajor(checkitem)">
                        <option value="" selected="selected">--请选择--</option>
                        <option value="{{college.wordbookValue}}" ng-repeat="college in colleges" ng-bind="college.wordbookValue"></option>
                    </select>
                </li>
                <li>
                    <span class="span_width">任教专业：</span>
                    <select type="text" ng-model="checkitem.teachMajor" name="teachMajor" class="forminput" id="teachMajor">
                        <option value="" selected="selected">--请选择--</option>
                        <option value="{{major.majorName}}" ng-repeat="major in majors" ng-bind="major.majorName"></option>
                    </select>
                </li>
                <li><span class="span_width">任教学段：</span><input type="text" ng-model="checkitem.teachSection" name="teachSection" class="forminput" id="teachSection"/></li>
                <li><span class="span_width">任课状况：</span><input type="text" ng-model="checkitem.teachStatus" name="teachStatus" class="forminput" id="teachStatus"/></li>
                <li><span class="span_width">从事领域：</span><input type="text" ng-model="checkitem.teachArea" name="teachArea" class="forminput" id="teachArea"/></li>
                <li>
                    <span class="span_width">是否事业编制：</span>
                    <select type="text" ng-model="checkitem.isCompile" name="isCompile" class="forminput" id="isCompile"/>
                        <option value="">--请选择--</option>
                        <option value="是">是</option>
                        <option value="否">否</option>
                    </select>
                </li>
                <li><span class="span_width">签订合同情况：</span><input type="text" ng-model="checkitem.contract" name="contract" class="forminput" id="contract"/></li>
                <li><span class="span_width">五险一金：</span><input type="text" ng-model="checkitem.fiveOne" name="fiveOne" class="forminput" id="fiveOne"/></li>
                <li>
                    <span class="span_width">是否双师：</span>
                    <select type="text" ng-model="checkitem.doubleTeacher" name="doubleTeacher" class="forminput" id="doubleTeacher"/>
                        <option value="">--请选择--</option>
                        <option value="是">是</option>
                        <option value="否">否</option>
                    </select>
                </li>
                <li>
                    <span class="span_width">职业资格证书等级：</span>
                    <select type="text" ng-model="checkitem.certificateLevel" name="certificateLevel" class="forminput" id="certificateLevel">
                        <option value="" selected="selected">--请选择--</option>
                        <option value="高级">高级</option>
                        <option value="中级">中级</option>
                        <option value="低级">低级</option>
                    </select>
                </li>
                <li>
                    <span class="span_width">是否有行业背景：</span>
                    <select type="text" ng-model="checkitem.bBackground" name="bBackground" class="forminput" id="bBackground"/>
                        <option value="">--请选择--</option>
                        <option value="是">是</option>
                        <option value="否">否</option>
                    </select>
                </li>
                <li>
                    <span class="span_width">是否有工程背景：</span>
                    <select type="text" ng-model="checkitem.pBackground" name="pBackground" class="forminput" id="pBackground"/>
                        <option value="">--请选择--</option>
                        <option value="是">是</option>
                        <option value="否">否</option>
                    </select>
                </li>
                <li><span class="span_width">户籍所在地：</span><input type="text" ng-model="checkitem.native" name="native" class="forminput" id="native"/></li>
                <li><span class="span_width">家庭住址：</span><input type="text" ng-model="checkitem.address" name="address" class="forminput" id="address"/></li>
                <li><span class="span_width">联系电话：</span><input type="text" ng-model="checkitem.phone" name="phone" class="forminput" id="phone"/></li>
                <li><span class="span_width">邮箱：</span><input type="text" ng-model="checkitem.email" name="email" class="forminput" id="email"/></li>
                <li>
                    <span class="span_width">是否在岗：</span>
                    <select type="text" ng-model="checkitem.onGuard" name="onGuard" class="forminput" id="onGuard"/>
                        <option value="">--请选择--</option>
                        <option value="是">是</option>
                        <option value="否">否</option>
                    </select>
                </li>
                <li>
                    <span class="span_width">状态：</span>
                    <select type="text" ng-model="checkitem.status" name="status" class="forminput" id="status"/>
                        <option value="">--请选择--</option>
                        <option value="在职">在职</option>
                        <option value="离职">离职</option>
                    </select>
                </li>
                <li>
                    <span class="span_width">是否外聘：</span>
                    <select type="text" ng-model="checkitem.employ" name="employ" class="forminput" id="employ"/>
                        <option value="">--请选择--</option>
                        <option value="是">是</option>
                        <option value="否">否</option>
                    </select>
                </li>
                <li class="employ_Y"><span class="span_width">外聘工作单位：</span><input type="text" ng-model="checkitem.employUnit" name="employUnit" class="forminput" id="employUnit"/></li>
                <li class="employ_Y"><span class="span_width">外聘日期：</span><input type="text" ng-model="checkitem.employDate" name="employDate" class="forminput" id="employDate"/></li>
                <li class="employ_Y"><span class="span_width">外聘来源：</span><input type="text" ng-model="checkitem.employSource" name="employSource" class="forminput" id="employSource"/></li>
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
    var load_all=true;
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        var img_id;//获取图片Id
        var img_ischange;
        //加载数据
        $scope.loadTeacher = function () {
            loading();//加载层
            remotecall("teacherManage_loadmajorbycollege",{},function (data) {
                $scope.majors=data.rows;
            },function (data) {});
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("teacherManage_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                closeLoading();//关闭加载层
                $scope.teachers = data.rows;//加载的数据对象，‘teachers’根据不同需求而变
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
                for(i=0;i<$scope.teachers.length;i++){
                    $scope.teachers[i].td0=false;
                }
                //数据为0时提示
                if(data.total==0){
                    closeLoading();//关闭加载层
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            //加载任教学院下拉选
            remotecall("teacherManage_loadcollege",{},function (data) {
                $scope.colleges=data.rows;
            },function (data) {});
            $scope.checklist=[];
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
                if(load_all){
                    pageNum = pn;//改变当前页
                    //重新加载用户信息
                    $scope.loadTeacher();
                }
                else{
                    pageNum = pn;//改变当前页
                    //重新加载用户信息
                    $scope.loadTeacher();
                }
            }
        };
        //删除功能
        $scope.delete=function (tr) {
            $('#all').attr("checked",false);

            var deleteIds=new Array(tr.teacherId);
            parent.pConfirm("确认删除该条数据吗？",function () {
                loading();
                remotecall("teacherManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        parent.pMsg("删除成功");
                        closeLoading();//关闭加载层
                        //重新加载数据
                        $scope.loadTeacher();
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
            if($("input[name='teacherIdSelect']:checked").length<1){
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='teacherIdSelect']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有数据吗？",function () {
                loading();
                remotecall("teacherManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        parent.pMsg("删除成功");
                        closeLoading();//关闭加载层
                        //重新加载数据
                        $scope.loadTeacher();
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
        //新建
        $scope.add = function () {
            add_edit=true;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table').hide();
            $('.table-addform,.Y').show();
            $("#Form input").value="";
            $("#PreView").attr("src",'<%=request.getContextPath()%>/images/icon_error.png');//新建时加载默认图片
        };
        //修改
        $scope.edit= function (tr) {
//            loading();



            add_edit=false;

            $scope.checkitem=tr;
//            下面注释掉了 tr就是需要的信息 不用再查一遍了
//            var teacherId=tr.teacherId;
//            下面的获取teacherId方法必须要checkbox选中 不好，注释掉了
//            var teacherId = $("input[name='teacherIdSelect']:checked").map(function(index,elem) {
//                return $(elem).val();
//            }).get();//需要的Id
//            remotecallasync("teacher_loadimg", {teacherId:teacherId}, function (data) {
//                closeLoading();//关闭加载层
//                $scope.checkitem=data[0];
//                $scope.$apply();
            if (tr.teacherIcon!=""&&tr.teacherIcon!=null) {
                img_ischange=(tr.teacherIcon);
                $("#PreView").attr("src",serverimg(tr.teacherIcon));
                if(tr.employ=="否"){
                    $(".employ_Y").hide();
                } else{
                    $(".employ_Y").show();
                }
            } else{
                $("#PreView").attr("src",'<%=request.getContextPath()%>/images/icon_error.png');//加载默认图片
            }
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-addform').show();
            $('table').hide();
//            让任教专业显示
            if(tr.teachCollege!=null){
                remotecall("teacherManage_loadmajorbycollege",{teachCollege:tr.teachCollege},function (data) {
                    $scope.majors=data;
                },function (data) {});
            }else{
                $scope.checkitem.teachMajor="";
            }
        };
        //根据学院选择专业
        $scope.getMajor=function (item){
            remotecall("teacherManage_loadmajorbycollege",{teachCollege:item.teachCollege},function (data) {
                $scope.majors=data;
            },function (data) {});
        }
        //隐藏
        $scope.cancel=function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            },300);
            $('table,.title,.pagingbox').show();
            //清空选中
            $scope.checklist=[];
            $scope.checkitem={};
            $scope.all = false;
            //修改（修改的学号已存在）取消之后，列表显示修改时的数据，故取消时要刷新
            $scope.loadTeacher();
            for(i=0;i<$scope.teachers.length;i++){
                $scope.teachers[i].td0=false;
            }
        };
        //上传图片
        $scope.uploadIcon = function (selector) {
            imguploadandpreview(selector, '1', function (data) {
                img_id=data.fid;//获取图片存储id
            });
        }
        //首次加载数据
        $scope.loadTeacher();
        //checked 复选框判断
        $scope.all = false;
        $scope.checklist=[];
        $scope.checkitem={};
        $scope.allfn = function  () {
            if($scope.all == false){
                for(i=0;i<$scope.teachers.length;i++){
                    $scope.teachers[i].td0=false
                }
                num=0;
            }else{
                for(i=0;i<$scope.teachers.length;i++){
                    $scope.teachers[i].td0=true
                }
                num=$scope.teachers.length;
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
            if(num==$scope.teachers.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        //表单验证
        $("#Form").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                if(add_edit){//如果是添加
                    var parames = $("#Form").serializeObject();//参数
                    remotecallasync("teacherNumber_unique",parames,function(data){
                        if(data.length=='0'){
                            parames["teacherIcon"]=img_id;
                            remotecallasync("teacherManage_add",parames,function(data) {
                                if(data){
                                    parent.pMsg("添加成功");
                                    closeLoading();//关闭加载层
                                    //重新加载
                                    $('.table-addform').hide();
                                    $('table').show();
                                    $('#Form input').text("");
                                    $scope.loadTeacher();
                                    $scope.$apply();
                                    $scope.checklist=[];
                                    $scope.checkitem={};
                                    img_id="";
                                }else {
                                    parent.pMsg("添加失败");
                                    closeLoading();//关闭加载层
                                }
                            },function (data) {
                                parent.pMsg("数据库请求失败");
                                closeLoading();//关闭加载层
                                console.log(data);
                            });
                        } else{
                            parent.pMsg("教师工号和用户账号重复，请重新输入");
                            closeLoading();//关闭加载层
                        }
                    },function (data){
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                }else{//修改
                    var edit_name = $("input[name='teacherIdSelect']:checked").map(function(index,elem) {
                        return $(elem).val();
                    }).get();//根据Id判断 修改用户名时只允许修改本用户Id和数据库中不存在的用户名
                    var parames = $("#Form").serializeObject();//参数
                    parames["teacherId"]=edit_name[0];
                    if(img_id==""){
                        parames["teacherIcon"]=img_ischange;
                    }else{
                        parames["teacherIcon"]=img_id;
                    }
                    remotecallasync("teacherNumber_unique",parames,function(data){
                        if(data.length=='0'||data[0].teacherId == edit_name){
                            remotecallasync("teacherManage_edit",parames,function (data) {
                                if(data){
                                    closeLoading();//关闭加载层
                                    parent.pMsg("修改成功");
                                    //重新加载信息
                                    $('.table-addform').hide();
                                    $('table').show();
                                    $scope.loadTeacher();
                                    $scope.$apply();
                                    $scope.checklist=[];
                                    $scope.checkitem={};
                                    img_id="";
                                }else {
                                    parent.pMsg("修改失败");
                                    closeLoading();//关闭加载层
                                }
                            },function (data) {
                                parent.pMsg("数据库请求失败");
                                closeLoading();//关闭加载层
                                console.log(data);
                            });
                        } else{
                            parent.pMsg("教师工号和用户账号重复，请重新输入");
                            closeLoading();//关闭加载层
                        }
                    },function(data){
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                }
            },
           rules:{
                teacherNumber:{
                    number:true,
                    required:true,
                    maxlength:45
                },
                teacherName:{
                    required:true,
                    maxlength:45
                },
                teacherGender:{
                    required:true,
                    maxlength:5
                },
                nation:{
                    required:true,
                    maxlength:45
                },
                politics:{
                    required:true,
                    maxlength:45
                },
                politicsDate:{
                    required:true,
                },
                IDCard:{
                    idCard:true,
                    required:true,
                },
                birthday:{
                    required:true,
                },
                schoolDate:{
                    required:true,
                },
                department:{
                    required:true,
                    maxlength:45
                },
                administrative:{
                    required:true,
                    maxlength:45
                },
                teachUnit:{
                    required:true,
                    maxlength:45
                },
                duty:{
                    required:true,
                    maxlength:45
                },
                dutyDate:{
                    required:true,
                },
                dutyLevel:{
                    required:true,
                    maxlength:45
                },
                education:{
                    required:true,
                    maxlength:45
                },
                educationDate:{
                    required:true,
                    maxlength:45
                },
                educationMajor:{
                    required:true,
                    maxlength:45
                },
                educationSchool:{
                    required:true,
                    maxlength:45
                },
                educationStructure:{
                    required:true,
                    maxlength:45
                },
                degree:{
                    required:true,
                    maxlength:45
                },
                degreeDate:{
                    required:true,
                },
                degreeMajor:{
                    required:true,
                    maxlength:45
                },
                degreeSchool:{
                    required:true,
                    maxlength:45
                },
                certificate:{
                    required:true,
                    maxlength:45
                },
                certificateDate:{
                    required:true,
                },
                teachDate:{
                    required:true,
                },
                teachMajor:{
                    required:true,
                    maxlength:45
                },
                teachSection:{
                    required:true,
                    maxlength:45
                },
                teachStatus:{
                    required:true,
                    maxlength:45
                },
                teachArea:{
                    required:true,
                    maxlength:45
                },
                isCompile:{
                    required:true,
                    maxlength:45
                },
                contract:{
                    required:true,
                    maxlength:45
                },
                fiveOne:{
                    required:true,
                    maxlength:45
                },
                doubleTeacher:{
                    required:true,
                    maxlength:45
                },
                certificateLevel:{
                    required:true,
                    maxlength:45
                },
                bBackground:{
                    required:true,
                    maxlength:45
                },
                pBackground:{
                    required:true,
                    maxlength:45
                },
                employ:{
                    required:true,
                    maxlength:45
                },
//                employUnit:{
//                    required:true,
//                    maxlength:45
//                },
//                employDate:{
//                    required:true,
//                },
//                employSource:{
//                    required:true,
//                    maxlength:45
//                },
                native:{
                    required:true,
                    maxlength:45
                },
                address:{
                    required:true,
                    maxlength:45
                },
                phone:{
                    required:true,
                    tel:true,
                },
                email:{
                    required:true,
                    email:true,
                },
                onGuard:{
                    required:true,
                    maxlength:45
                },
                status:{
                    required:true,
                    maxlength:45
                }
            },
            messages:{
                teacherNumber:{
                    required:"请输入工号",
                    number:"请输入数字",
                    maxlength:"长度不超过45个字符"
                },
                teacherName:{
                    required:"请输入教师姓名",
                    maxlength:"长度不超过45个字符"
                },
                teacherGender:{
                    required:"请选择性别",
                    maxlength:"长度不超过45个字符"
                },
                nation:{
                    required:"请输入民族",
                    maxlength:"长度不超过45个字符"
                },
                politics:{
                    required:"请选择政治面貌",
                    maxlength:"长度不超过45个字符"
                },
                politicsDate:{
                    required:"请选择加入时间",
                    maxlength:"长度不超过45个字符"
                },
                IDCard:{
                    required:"请输入身份证号码",
                    idCard:"请输入正确格式的身份证号码",
                    maxlength:"长度不超过45个字符"
                },
                birthday:{
                    required:"请选择出生日期",
                    maxlength:"长度不超过45个字符"
                },
                schoolDate:{
                    required:"请选择来校日期",
                    maxlength:"长度不超过45个字符"
                },
                department:{
                    required:"请输入所属部门",
                    maxlength:"长度不超过45个字符"
                },
                administrative:{
                    required:"请输入行政职务",
                    maxlength:"长度不超过45个字符"
                },
                teachUnit:{
                    required:"请输入任教单位",
                    maxlength:"长度不超过45个字符"
                },
                duty:{
                    required:"请输入专业技术职务",
                    maxlength:"长度不超过45个字符"
                },
                dutyDate:{
                    required:"请选择专业技术职务任职资格时间",
                    maxlength:"长度不超过45个字符"
                },
                dutyLevel:{
                    required:"请选择专业技术职务等级",
                    maxlength:"长度不超过45个字符"
                },
                education:{
                    required:"请输入学历",
                    maxlength:"长度不超过45个字符"
                },
                educationDate:{
                    required:"请输入学历学习时间",
                    maxlength:"长度不超过45个字符"
                },
                educationMajor:{
                    required:"请输入学历专业",
                    maxlength:"长度不超过45个字符"
                },
                educationSchool:{
                    required:"请输入学历获取机构",
                    maxlength:"长度不超过45个字符"
                },
                educationStructure:{
                    required:"请输入学缘结构",
                    maxlength:"长度不超过45个字符"
                },
                degree:{
                    required:"请输入学位",
                    maxlength:"长度不超过45个字符"
                },
                degreeDate:{
                    required:"请输入学位学习时间",
                    maxlength:"长度不超过45个字符"
                },
                degreeMajor:{
                    required:"请输入学位所学专业",
                    maxlength:"长度不超过45个字符"
                },
                degreeSchool:{
                    required:"请输入学位获取机构",
                    maxlength:"长度不超过45个字符"
                },
                certificate:{
                    required:"请输入高等教育资格证",
                    maxlength:"长度不超过45个字符"
                },
                certificateDate:{
                    required:"请选择高等教育资格证获得时间",
                    maxlength:"长度不超过45个字符"
                },
                teachDate:{
                    required:"请选择从教时间",
                    maxlength:"长度不超过45个字符"
                },
                teachMajor:{
                    required:"请输入任教专业",
                    maxlength:"长度不超过45个字符"
                },
                teachSection:{
                    required:"请输入任教学段",
                    maxlength:"长度不超过45个字符"
                },
                teachStatus:{
                    required:"请输入任课状况",
                    maxlength:"长度不超过45个字符"
                },
                teachArea:{
                    required:"请输入从事领域",
                    maxlength:"长度不超过45个字符"
                },
                isCompile:{
                    required:"请选择是否事业编制",
                    maxlength:"长度不超过45个字符"
                },
                contract:{
                    required:"请输入签订合同情况",
                    maxlength:"长度不超过45个字符"
                },
                fiveOne:{
                    required:"请输入五险一金",
                    maxlength:"长度不超过45个字符"
                },
                doubleTeacher:{
                    required:"请选择是否双师",
                    maxlength:"长度不超过45个字符"
                },
                certificateLevel:{
                    required:"请选择职业资格证书等级",
                    maxlength:"长度不超过45个字符"
                },
                bBackground:{
                    required:"请选择是否有行业背景",
                    maxlength:"长度不超过45个字符"
                },
                pBackground:{
                    required:"请选择是否有工程背景",
                    maxlength:"长度不超过45个字符"
                },
                employ:{
                    required:"请选择是否外聘",
                    maxlength:"长度不超过45个字符"
                },
//                employUnit:{
//                    required:"请输入外聘工作单位",
//                    maxlength:"长度不超过45个字符"
//                },
//                employDate:{
//                    required:"请选择外聘日期",
//                    maxlength:"长度不超过45个字符"
//                },
//                employSource:{
//                    required:"请输入外聘来源",
//                    maxlength:"长度不超过45个字符"
//                },
                native:{
                    required:"请输入户籍所在地",
                    maxlength:"长度不超过45个字符"
                },
                address:{
                    required:"请输入家庭地址",
                    maxlength:"长度不超过45个字符"
                },
                phone:{
                    required:"请输入手机号码",
                    tel:"请输入正确格式的手机号码",
                    maxlength:"长度不超过45个字符"
                },
                email:{
                    required:"请输入邮箱",
                    email:"请输入正确格式的邮箱",
                    maxlength:"长度不超过45个字符"
                },
                onGuard:{
                    required:"请选择是否在岗",
                    maxlength:"长度不超过45个字符"
                },
                status:{
                    required:"请选择状态",
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
    });
    //显示/隐藏
    $("#employ").bind("change",function(){
        if($("#employ option:selected").val()=="否"){
            $(".employ_Y").hide();
        } else{
            $(".employ_Y").show();
        }
    });
    //角色搜索框绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchkey").click();
        }
    });
    //日历
    $("#politicsDate,#birthday,#schoolDate,#dutyDate,#certificateDate,#teachDate,#employDate,#educationDate,#degreeDate").jeDate({
        format:"YYYY-MM-DD",
        isTime:false,
        minDate:"1950-00-00 00:00:00",
        isOk:false
    })
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>

