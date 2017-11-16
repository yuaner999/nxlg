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
        .row{
            padding-left: 252px !important;
            margin-right: 0px !important;
        }
        .forminput{
            margin-right:80px !important;
        }
        .text-center{
            position: absolute;
            left:33%;
        }
        .table-addform{
            display: none;
            padding: 15px 0 0 25px;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教室使用率设置
<hr>
<div class="table-load">
    <div class="title">
        <%--<table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" /> 新建</table-btn>--%>
        <%--<table-btn class="top" ng-click="dels()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>--%>
        <input class="tablesearchbtn" type="text"  placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>
        <table-btn id="search" ng-click="loadData()">搜索</table-btn>
    </div>
    <div class="tablebox">
        <table class="table">
            <thead>
            <th class="checked" hidden><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all" /></th>
            <th>教室类型</th>
            <th>使用率</th>
            <th></th>
            </thead>
            <tbody>
            <tr ng-repeat="crt in crts">
                <td class="thischecked" ng-click="thischecked(crt)" hidden>
                    <input type="checkbox" ng-model="crt.td0" name="classroomId" value="{{crt.crt_id}}"/>
                </td>
                <td ng-bind="crt.crt_type"></td>
                <td><span ng-bind="crt.crt_usage"></span>%</td>
                <td><table-btn ng-click="edit(crt)">修改</table-btn><b style="margin-right: 10px"></b><%--<table-btn ng-click="del(crt)">删除</table-btn>--%></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>

<%--新建--%>
<div class="table-addform" style="">
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教室使用率设置 > 修改
    <hr>
    <form id="Form">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li><span class="span_width">教室类型：</span><input style="width: 200px; border:1px solid #000000;" readonly="readonly" type="text" ng-model="edititem.crt_type" name="crt_type" class="forminput" id="crt_type"/></li>
                <li><span class="span_width">预设使用率：</span><input style="width: 200px;" type="number" step="0.01" min="0" max="100" ng-model="edititem.crt_usage" name="crt_usage" class="forminput" id="crt_usage" placeholder="请输入100以内的数字"/></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
</body>
<script>
    var app = angular.module('app',[]);
    app.controller('ctrl',function  ($scope) {
        var add_edit;
        var num=0;
        $scope.loadData = function () {
            loading();//加载
            remotecall("crt_usage_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                closeLoading();//关闭加载层
                $scope.crts = data.rows;
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

                for(i=0;i<$scope.crts.length;i++){
                    $scope.crts[i].td0=false;
                }
                $scope.all=false;
                num=0;
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败" );
                console.log(data);
            });
            $scope.crtslist=[];
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


        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                for(i=0;i<$scope.crts.length;i++){
                    $scope.crts[i].td0=false
                }
                num=0;
            }else{
                for(i=0;i<$scope.crts.length;i++){
                    $scope.crts[i].td0=true
                }
                num=$scope.crts.length;
            }
        };

        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
            }else{
                num--;
                tr.td0 = false;
                $scope.all=false;
            }
            if(num==$scope.crts.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };

        //添加
        $scope.add=function () {
            add_edit=true;
            $(".table-load").removeClass("a-show");
            $(".table-load").addClass("a-hide");
            $(".table-load").hide();
            $(".table-addform").removeClass("a-hide");
            $(".table-addform").addClass("a-show");
            $(".table-addform").show();
            $scope.edititem=[];
        }

        //修改
        $scope.edit=function (tr) {
            add_edit=false;
            $scope.edititem=[];
            tr.crt_usage=parseFloat(tr.crt_usage);
            $scope.edititem=tr;
            $(".table-load").removeClass("a-show");
            $(".table-load").addClass("a-hide");
            $(".table-load").hide();
            $(".table-addform").removeClass("a-hide");
            $(".table-addform").addClass("a-show");
            $(".table-addform").show();
            $("#crt_usage").val($scope.edititem.crt_usage);
        }

        //取消
        $scope.cancel=function () {
            $(".table-addform").removeClass("a-show");
            $(".table-addform").addClass("a-hide");
            $(".table-addform").hide();
            $(".table-load").removeClass("a-hide");
            $(".table-load").addClass("a-show");
            $(".table-load").show();
            $scope.loadData();
        }

        $("#Form").validate({
            submitHandler:function(form){
                //验证通过,然后就保存
                if(add_edit){//如果是添加
                    loading();
                    var parames = $("#Form").serializeObject();//参数
                    var exit=false;
                    var paramsmull=true;
                    if (parames.crt_type.valueOf()==""||parames.crt_usage.valueOf()==""){
                        paramsmull=false;
                    }
                    for(var i=0;i<$scope.crts.length;i++){
                        if(parames.crt_type==$scope.crts[i].crt_type){
                            exit=true;
                        }
                    }

                    if(paramsmull){
                        if(!exit){
                            remotecall("crt_usage_add",parames,function (data) {
                                closeLoading();
                                if(data){
                                    parent.pMsg("添加成功");
                                }else{
                                    parent.pMsg("添加失败");
                                }
                                $(".table-addform").removeClass("a-show");
                                $(".table-addform").addClass("a-hide");
                                $(".table-addform").hide();
                                $(".table-load").removeClass("a-hide");
                                $(".table-load").addClass("a-show");
                                $(".table-load").show();
                                $scope.loadData();
                                $scope.$apply();
                            },function (data) {
                                closeLoading();
                                parent.pMsg("连接数据库失败");
                                console.log(data);
                            });
                        }else {
                            closeLoading();
                            parent.pMsg("该类型已存在");
                        }
                    }else {
                        closeLoading();
                        parent.pMsg("教室类型或使用率不能为空！");
                    }

                }else{//修改
                    var parames = $("#Form").serializeObject();//参数
                    loading();
                    var parames = $("#Form").serializeObject();//参数
                    var exit=false;
                    var paramsmull=true;
                    if (parames.crt_type.valueOf()==""||parames.crt_usage.valueOf()==""){
                        paramsmull=false;
                    }
                    for(var i=0;i<$scope.crts.length;i++){
                        if($scope.edititem.crt_type==$scope.crts[i].crt_type&&$scope.edititem.crt_id!=$scope.crts[i].crt_id){
                            exit=true;
                        }
                    }
                    if(paramsmull){
                        if(!exit){
                            remotecall("crt_usage_edit",$scope.edititem,function (data) {
                                closeLoading();
                                if(data){
                                    parent.pMsg("修改成功");
                                }else{
                                    parent.pMsg("修改失败");
                                }
                                $(".table-addform").removeClass("a-show");
                                $(".table-addform").addClass("a-hide");
                                $(".table-addform").hide();
                                $(".table-load").removeClass("a-hide");
                                $(".table-load").addClass("a-show");
                                $(".table-load").show();
                                $scope.loadData();
                                $scope.$apply();
                            },function (data) {
                                closeLoading();
                                parent.pMsg("连接数据库失败");
                                console.log(data);
                            });
                        }else {
                            closeLoading();
                            parent.pMsg("该类型已存在");
                        }
                    }else {
                        closeLoading();
                        parent.pMsg("教师类型名称或使用率不能为空！");
                    }
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


        //首次加载
        $scope.loadData();
    });
</script>
</html>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>

