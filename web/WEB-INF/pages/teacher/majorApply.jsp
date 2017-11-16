<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-17
  Time: 15:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <style>
        .table-majorshow{
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
        .showTitle{
            position: absolute;
            top: 0;
            line-height: 70px;
            left: 2%;
            color: #5c307d;
            font-weight: bold;
        }
        .myTextarea{
            width: 100%;
            height: 100%;
        }
        .title .tablesearchbtn {
            margin-left: 0px;
            margin-right: 12px;
            width: 158px;
            vertical-align: middle;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：专业申请
<hr>
<table-nav>
    <li ng-click="dofilter(1)" class="sele">现有专业列表</li>
    <li ng-click="dofilter(0)">待审核列表</li>
    <li ng-click="dofilter(2)">未通过列表</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <span class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;院：</span>
    <select type="text" ng-model="college" name="college" class="forminput" id="college">
        <option value="">--请选择--</option>
        <option ng-repeat="option in majorCollege" value="{{option.wordbookValue}}"
                ng-bind="option.wordbookValue"></option>
    </select>

    <span class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;科：</span>
    <select type="text" ng-model="subjectOne" name="subjectOne" class="forminput" id="subjectOne">
        <option value="">--请选择--</option>
        <option ng-repeat="option in subjects" value="{{option.wordbookValue}}"
                ng-bind="option.wordbookValue"></option>
    </select>

    <span class="span_width">专业状态：</span>
    <select type="text" ng-model="majorStatus" name="majorStatus" class="forminput" id="majorStatus"/>
        <option value="">--请选择--</option>
        <option value="启用">启用</option>
        <option value="停用">停用</option>
    </select>

    <%--<span  ng-show="show=='0'" class="span_width">审核状态：</span>--%>
    <%--<select  ng-show="show=='0'" type="text" ng-model="checkStatus" name="checkStatus" class="forminput" id="checkStatus"/>--%>
        <%--<option value="">--请选择--</option>--%>
        <%--<option value="未通过">未通过</option>--%>
        <%--<option value="待审核">待审核</option>--%>
    <%--</select>--%>
    <span ng-show="show=='0'||show=='2'" class="span_width">审核类别：</span>
    <select ng-show="show=='0'||show=='2'" type="text" ng-model="checkType" name="checkType" class="forminput" id="checkType"/>
    <option value="">--请选择--</option>
    <option value="新增">新增</option>
    <option value="修改">修改</option>
    <option value="删除">删除</option>
    <option value="停用">停用</option>
    <option value="启用">启用</option>
    </select>
</div>
<div class="title">

    <span class="span_width">专业名称：</span>
    <input class="tablesearchbtn" type="text" ng-model="majorName" name="majorName" placeholder="请输入专业名称"/>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
    <table-btn class="top btnExcel" ng-click="btnExcel()">导出到Excel</table-btn>
    <table-btn class="top" id="tableadd" ng-click="add()" style="display:none"><img
            src="<%=request.getContextPath()%>/images/tableadd_07.png"/>新建
    </table-btn>
    <%--<table-btn class="top btnExcel" ng-click="end()">停用</table-btn>--%>
    <%--<table-btn class="top btnExcel" ng-click="start()">启用</table-btn>--%>
    <table-btn class="top" ng-click="delete()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png"/>批量删除
    </table-btn>
    <form id="search_fm" method="post" hidden>
    </form>
</div>
<!--表格-->
<div class="tablebox" style="width: 100%;">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all" /></th>
        <th>院(系)/部</th>
        <th>专业名称</th>
        <th>所属学科</th>
        <th>培养层次</th>
        <th>学制</th>
        <th>专业状态</th>
        <th>审核状态</th>
        <th>培养对象</th>
        <th>简介</th>
        <th ng-if="Var">审核类别</th>
        <th ng-if="Var&&show=='2'">未通过原因</th>
        <th style="width:160px;">操作设置</th>
        <th style="width:160px;" ng-if="!Var">操作设置</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input type="checkbox" ng-model="data.td0" name="majorId" value="{{data.majorId}}"/>
            </td>
            <td ng-bind="data.majorCollege"></td>
            <td ng-bind="data.majorName"></td>
            <td ng-bind="data.subject"></td>
            <td ng-bind="data.level"></td>
            <td ng-bind="data.length"></td>
            <td ng-bind="data.majorStatus"></td>
            <td ng-bind="data.checkStatus"></td>
            <td ng-bind="data.trainingobjects"></td>
            <td>
                <table-btn ng-click="detail(data.introduction)">查看详情</table-btn>&nbsp;
            </td>
            <td ng-if="Var" ng-bind="data.checkType"></td>
            <td ng-if="Var&&show=='2'" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%" ng-bind="data.refuseReason"
                ng-click="ReasonDetail(data.refuseReason,$index)" class="Ar"></td>
            <td><table-btn  ng-if="!Var" ng-click="edit(data)">修改</table-btn><b style="margin-right: 10px"></b><table-btn ng-click="del(data)">删除</table-btn></td>

            <td ng-if="!Var"><table-btn ng-click="end(data)">停用</table-btn><b style="margin-right: 10px"></b><table-btn  ng-click="start(data)">启用</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
<!--新建表单-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：专业申请 > 新增/修改
    <hr>
    <form id="AddForm">
        <div class="row">
            <ul class="col-sm-4 col-xs-3">
                <li><input type="text"  ng-model="dataitem.majorId" class="forminput" style="display:none"/></li>
                <li>
                    <span style="margin-left: -5px">院(系)/部：</span>
                    <select  ng-model="dataitem.majorCollege" name="majorCollege" class="forminput" id="majorCollege">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options_majorCollege" value="{{option.wordbookValue}}" ng-bind="option.wordbookValue"></option>
                    </select>
                </li>
                <li><span>国标专业个数：</span><input type="text"  ng-model="dataitem.internationalNum" name="internationalNum" class="forminput" id="internationalNum"/></li>
                <li><span>国标专业代码：</span><input type="text"  ng-model="dataitem.internationalCode" name="internationalCode" class="forminput" id="internationalCode"/></li>
                <li><span>专业代码：</span><input type="text"  ng-model="dataitem.majorCode" name="majorCode" class="forminput" id="majorCode"/></li>
                <li><span>专业名称：</span><input type="text" ng-model="dataitem.majorName" name="majorName" class="forminput" id="majorName"/></li>

            </ul>
            <ul class="col-sm-4 col-xs-3">
                <li>
                    <span>所属学科：</span>
                    <select  ng-model="dataitem.subject" name="subject" class="forminput" id="subject">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options_subject" value="{{option.wordbookValue}}" ng-bind="option.wordbookValue"></option>
                    </select>
                </li>
                <li>
                    <span>培养层次：</span>
                    <select  ng-model="dataitem.level" name="level" class="forminput" id="level">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options_level" value="{{option.wordbookValue}}" ng-bind="option.wordbookValue"></option>
                    </select>
                </li>
                <li><span>学制：</span><input type="text"  ng-model="dataitem.length" name="length" class="forminput" id="length"/></li>
                <li><span>设置年份：</span><input type="text"  ng-model="dataitem.settingYear" name="settingYear" class="forminput" id="settingYear"/></li>
                <li><span>培养对象：</span><input type="text"  ng-model="dataitem.trainingobjects" name="trainingobjects" class="forminput" id="trainingobjects"/></li>
            </ul>
            <ul class="col-sm-4 col-xs-3">
                <li><span>专业简介：</span><textarea ng-model="dataitem.introduction" name="introduction"  id="introduction" cols="50" rows="10" style="border: 1px solid #c5add7;"></textarea></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
<%--查看详情--%>
<div class="table-majorshow" ng-show="majorshow">
    <div class="showTitle">
        <span>操作类型：</span><span>查看详情</span>
    </div>
    <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <span id="myTextarea" class="myTextarea"><%--myTextarea--%></span>
    </div>
</div>
</body>
</html>
<script>
    var add_edit=true;//true为新建，false为修改
    var filter=1;
    var majorid=null;
    var oldsearchchecktype="";
    var oldsearchcheckstatus="";
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        var loadCollege = false;
        var loadSubject = false;
        var num=0;
        var tip=true;
        $scope.Var=false;

        //加载学院下拉框（查询条件）
        remotecall("teacher_majorApply_load_majorCollege", '', function (data) {
            closeLoading();//关闭加载层
            $scope.majorCollege = data;
            loadCollege = true;
        }, function (data) {
            closeLoading();//关闭加载层
            parent.pMsg("加载学院失败");
        });
        //加载学科下拉框（查询条件）
        remotecall("teacher_majorApply_load_subject", '', function (data) {
            closeLoading();//关闭加载层
            $scope.subjects = data;
            loadSubject =  true;
        }, function (data) {
            closeLoading();//关闭加载层
            parent.pMsg("加载学科失败");
        });

        //初始化数据
        $scope.init = function () {
            if (loadSubject && loadCollege) {
                $scope.loadData();
            }
        }

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadData();
        }

        //加载数据
        $scope.loadData = function () {
            if($scope.show==1){
            }else if($scope.show==0){
                oldsearchchecktype=$scope.checkType;
                oldsearchcheckstatus=$scope.checkStatus;
            }
            console.log($scope.checkType);
            console.log($scope.checkStatus);
            loading();//加载
            $(".none").hide();
            remotecall("teacher_majorApply_load", {
                pageNum: pageNum,
                pageSize: pageSize,
                filter: filter,
                majorCollege: $scope.college,
                majorName: $scope.majorName,
                subject: $scope.subjectOne,
                checkType: $scope.checkType,
                majorStatus: $scope.majorStatus,
                checkStatus:''
            }, function (data) {
                closeLoading();//关闭加载层
                $scope.datas = data.rows;
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
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                num=0;
                $scope.all = false;
                tip=true;
                //数据为0时提示
                if(data.total==0){
                    tip=false;
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败" );
                console.log(data);
            });
            remotecall("teacher_majorApply_load_majorCollege",'',function (data) {
                closeLoading();//关闭加载层
                $scope.options_majorCollege = data;
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载学院失败");
                console.log(data);
            });
            remotecall("teacher_majorApply_load_subject",'',function (data) {
                closeLoading();//关闭加载层
                $scope.options_subject = data;
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载学科失败");
                console.log(data);
            });
            remotecall("teacher_majorApply_load_level",'',function (data) {
                closeLoading();//关闭加载层
                $scope.options_level = data;
                closeLoading();//关闭加载层
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载培养层次失败");
                console.log(data);
            });
            $scope.datalist=[];
            $scope.dataitem={};
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
                $scope.loadData();
            }
        };
        //右侧菜单栏
        $scope.dofilter=function(str){
            pageNum=1;
            if(str==0){
                $scope.Var=true;
                $scope.show=0;
                $scope.checkType=oldsearchchecktype;
                $scope.checkStatus=oldsearchcheckstatus;
                $("#tableadd").show();
                $(".btnExcel").hide();
            }else if(str==1){
                $scope.Var=false;
                $scope.show=1;
                $scope.checkType = '';
                $scope.checkStatus = '';
                $("#tableadd").hide();
                $(".btnExcel").show();
            }else if(str==2){
                $scope.Var=true;
                $scope.show=2;
                $scope.checkType=oldsearchchecktype;
                $scope.checkStatus=oldsearchcheckstatus;
                $("#tableadd").show();
                $(".btnExcel").hide();
            }
                filter = str;
                $scope.loadData();
        }
        //checked 复选框判断
        $scope.all = false;
        $scope.datalist=[];
        $scope.dataitem={};
        //首次加载
        //先定义，后使用，否则出错误！！！
        $scope.init();
        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                $scope.all =true;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=true
                    $scope.datalist.push($scope.datas[i]);
                }
                num=$scope.datas.length;
            }else{
                $scope.all =false;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                $scope.datalist=[];
                $scope.dataitem={};
                num=0;
            }
        };
        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.datalist.push(tr);
            }else{
                num--;
                tr.td0 = false;
                $scope.all=false;
                var index = $scope.datalist.indexOf(tr);
                if (index > -1) {
                    $scope.datalist.splice(index, 1);
                }
            }
            if(num==$scope.datas.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        //查看详情功能
        $scope.detail=function (task) {
            loading();
            if(task == "" || task == null || task == undefined){
                task = "暂无详情"
            }
            $scope.majorshow=true;
            $("#myTextarea").html(task);
            $(".black,table").show();
            closeLoading();//关闭加载层
        };
        //关闭加载层
        $scope.close=function () {
            $(".pagingbox").show();
            $(".black").hide();
            $scope.majorshow=false;
        };
        //批量删除功能
        $scope.delete = function (){
            //判断是够选择数据
            if($scope.datalist.length == 0){
                parent.pMsg("请最少选择一条数据");
                return;
            }

            //获取所选择的行
            loading();
            remotecall("teacher_majorApply_delete", {passIds:$scope.datalist}, function (data) {
                closeLoading();//关闭加载层
                if (data == 1) {
                    parent.pMsg("系统正在审核，该专业不能进行新的操作")
                } else {
                    parent.pConfirm("确认删除选中的所有内容吗？", function () {
                        if (data == 2) {
                            parent.pMsg("删除成功");
                            //重新加载菜单
                            $scope.loadData();
                            $scope.$apply();
                        } else {
                            parent.pMsg("删除失败");
                        }
                    }, function (data) {
                    });
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("删除请求失败");
                console.log(data);
            });
        }
        //删除一个
        $scope.del = function (tr) {
            $scope.datalist=[];
            $scope.dataitem = {};
            $scope.datalist.push(tr);
            $scope.dataitem = $scope.datalist[0];
            loading();
            remotecall("teacher_majorApply_del", $scope.dataitem, function (data) {
                closeLoading();//关闭加载层
                if (data == 1) {
                    parent.pMsg("系统正在审核，该专业不能进行新的操作")
                } else {
                    parent.pConfirm("确认删除选中的内容吗？", function () {
                        if (data == 2) {
                            parent.pMsg("删除成功");
                            //重新加载菜单
                            $scope.loadData();
                            $scope.$apply();
                        } else {
                            parent.pMsg("删除失败");
                        }
                    }, function (data) {
                    });
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("删除请求失败");
                console.log(data);
            });
        };
        //新建
        $scope.add = function () {
            add_edit=true;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
            $("#AddForm input").value="";
        };
        //隐藏
        $scope.cancel=function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            },200);
            $('table,.title,.pagingbox').show();
            //清空选中
            $scope.datalist=[];
            $scope.dataitem={};
            num=0;
            $scope.loadData();
            $scope.all = false;
            for(i=0;i<$scope.datas.length;i++){
                $scope.datas[i].td0=false
            }
        };
        //修改
        $scope.edit= function (tr) {
            add_edit=false;
            $scope.datalist.push(tr);
            $scope.dataitem=$scope.datalist[0];
            var json="[{院(系)/部："+$scope.dataitem.majorCollege+"},{国标专业个数："+$scope.dataitem.internationalNum+"},{国标专业代码："
                    +$scope.dataitem.internationalCode+"},{专业代码："+$scope.dataitem.majorCode+"},{专业名称："+$scope.dataitem.majorName+"},{所属学科："+$scope.dataitem.subject+"},{培养层次："
                    +$scope.dataitem.level+"},{学制："+$scope.dataitem.length+"},{设置年份："+$scope.dataitem.settingYear+"},{专业状态："+$scope.dataitem.majorStatus+"},{培养对象："
                    +$scope.dataitem.trainingobjects+"},{专业简介："+$scope.dataitem.introduction+"}]";
            $scope.dataitem.json1=json;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
        };
        //新建和修改，验证+保存
        $("#AddForm").validate({
            submitHandler:function(form){
                loading();
                var parames = $("#AddForm").serializeObject();//参数
                //验证通过,然后就保存
                if(add_edit){
                    remotecallasync("teacher_majorApply_add",parames,function (data) {
                        closeLoading();//关闭加载层
                        if(data==0){
                            parent.pMsg("该学院和专业已添加"); return;
                        }else if(data){
                            parent.pMsg("添加成功");
                        }else {
                            parent.pMsg("添加失败");
                        }
                        //重新加载菜单
                        $('.table-addform').hide();
                        $('table,.title,.pagingbox').show();
                        $('#AddForm input').text("");
                        $scope.loadData();
                        $scope.$apply();
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                }else {
                    remotecallasync("teacher_majorApply_edit", $scope.dataitem, function (data) {
                        closeLoading();//关闭加载层
                        if(data==0){
                            parent.pMsg("该学院和专业已添加");
                            return;
                        }else if(data==1){
                            parent.pMsg("系统正在审核，该专业不能进行新的操作")
                        }else if (data==2) {
                            parent.pMsg("修改成功");
                        } else {
                            parent.pMsg("修改失败");
                        }
                        //重新加载菜单
                        $('.table-addform').hide();
                        $('table,.title,.pagingbox').show();
                        $scope.loadData();
                        $scope.$apply();
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                }

            },
            rules:{
                majorCollege:{
                    required:true,
                    maxlength:45
                },
                majorName:{
                    required:true,
                    maxlength:45
                },
                internationalNum:{
                    required:true,
                    maxlength:45
                },
                internationalCode:{
                    required:true,
                    maxlength:45
                },
                majorCode:{
                    required:true,
                    maxlength:45
                },
                level:{
                    required:true,
                    maxlength:45
                },
                length:{
                    required:true,
                    digits:true
                },
                subject:{
                    required:true,
                    maxlength:45
                },
                settingYear:{
                    required:true,
                    maxlength:45,
                    digits:true
                },
                trainingobjects:{
                    required:true,
                    maxlength:50,
                },
                introduction:{
                    required:true,
                    maxlength:400,
                }
            },
            messages:{
                majorCollege:{
                    required:"请输入学院",
                    maxlength:"长度不超过45个字符"
                },
                majorName:{
                    required:"请输入专业",
                    maxlength:"长度不超过45个字符"
                },
                internationalNum:{
                    required:"请输入国标专业个数",
                    maxlength:"长度不超过45个字符"
                },
                internationalCode:{
                    required:"请输入国标专业代码",
                    maxlength:"长度不超过45个字符"
                },
                majorCode:{
                    required:"请输入专业代码",
                    maxlength:"长度不超过45个字符"
                },
                level:{
                    required:"请输入培养层次",
                    maxlength:"长度不超过45个字符"
                },
                length:{
                    required:"请输入学制",
                    digits:"请输入整数"
                },
                subject:{
                    required:"请输入所属学科",
                    maxlength:45
                },
                settingYear:{
                    required:"请输入设置年份",
                    maxlength:45,
                    digits:"请输入整数"
                },
                trainingobjects:{
                    required:"请输入培养对象",
                    maxlength:"长度不超过50个字符",
                },
                introduction:{
                    required:"请输入专业简介",
                    maxlength:"最大长度400个字符",
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
        //停用
        $scope.end = function (data) {
            $scope.dataitem = data;
            $scope.dataitem.Mstatus ="停用";
            loading();
            remotecall("teacher_majorApply_isCheck", $scope.dataitem, function (data) {
                closeLoading();
                if (data==1) {
                    parent.pMsg("操作失败：该专业正在审核");
                }else if (data==2) {
                    parent.pMsg("操作失败：该专业已经是停用状态");
                }else {
                    var json="[{院(系)/部："+$scope.dataitem.majorCollege+"},{国标专业个数："+$scope.dataitem.internationalNum+"},{国标专业代码："
                            +$scope.dataitem.internationalCode+"},{专业代码："+$scope.dataitem.majorCode+"},{专业名称："+$scope.dataitem.majorName+"},{所属学科："+$scope.dataitem.subject+"},{培养层次："
                            +$scope.dataitem.level+"},{学制："+$scope.dataitem.length+"},{设置年份："+$scope.dataitem.settingYear+"},{专业状态："+'启用'+"}]";
                    $scope.dataitem.json1=json;
                    parent.pConfirm("确认停用选中的所有专业吗？", function () {
                        remotecall("teacher_majorApply_end", $scope.dataitem, function (data) {
                            if (data) {
                                parent.pMsg("停用成功");
                                //重新加载菜单
                                $scope.loadData();
                                $scope.$apply();
                            } else {
                                parent.pMsg("停用失败");
                            }
                        }, function (data) {
                            parent.pMsg("停用请求失败");
                        });
                    }, function () {
                    });
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("停用请求失败");
            });
        }
        //启用
        $scope.start = function (data) {
            $scope.dataitem = data;
            $scope.dataitem.Mstatus ="启用";
            remotecall("teacher_majorApply_isCheck", $scope.dataitem, function (data) {
                closeLoading();
                if (data==1) {
                    parent.pMsg("操作失败：该专业正在审核");
                }else if (data==2) {
                    parent.pMsg("操作失败：该专业已经是启用状态");
                }else{
                    var json="[{院(系)/部："+$scope.dataitem.majorCollege+"},{国标专业个数："+$scope.dataitem.internationalNum+"},{国标专业代码："
                            +$scope.dataitem.internationalCode+"},{专业代码："+$scope.dataitem.majorCode+"},{专业名称："+$scope.dataitem.majorName+"},{所属学科："+$scope.dataitem.subject+"},{培养层次："
                            +$scope.dataitem.level+"},{学制："+$scope.dataitem.length+"},{设置年份："+$scope.dataitem.settingYear+"},{专业状态："+'停用'+"}]";
                    $scope.dataitem.json1=json;
                    parent.pConfirm("确认启用选中的所有专业吗？", function () {
                        remotecall("teacher_majorApply_start", $scope.dataitem, function (data) {
                            if (data) {
                                parent.pMsg("启用成功");
                                //重新加载菜单
                                $scope.loadData();
                                $scope.$apply();
                            } else {
                                parent.pMsg("启用失败");
                            }
                        }, function (data) {
                            parent.pMsg("启用请求失败");
                        });
                    }, function () {
                    });
                }
            }, function () {
                closeLoading();
                parent.pMsg("启用请求失败");
            });
        }
        //导出到Excel
        $scope.btnExcel=function () {
            if(tip==true){
//                var url="../../export/conditions.form?searchStr="+searchStr;
                var url = "../../export/conditions.form?majorCollege=" + $scope.college
                        + "&majorName=" + $scope.majorName
                        + "&subject=" + $scope.subjectOne
                        + "&majorStatus=" + $scope.majorStatus;

                $("#search_fm").attr("action",url);
                $("#search_fm").submit();
            }else{parent.pMsg("没有专业信息可以导出");}
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

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>