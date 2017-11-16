<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/18
  Time: 17:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/zTreeStyle/zTreeStyle.css"/>
    <script src="<%=request.getContextPath()%>/js/jquery.ztree.all.js" type="text/javascript" charset="utf-8"></script>
    <style>
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
        .show ul{
            width: 80%;
            padding-left: 40px;
            margin-left: 35px;
            float: left;
        }
        .show li{
            width: 100%;
            margin: 10px 60px;
            display: block;
        }
        .show li span{
            min-width: 105px;
            display: inline-block;
            margin-right: 20px;
        }
        .show li>span:first-child{
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
            filter: alpha(opacity=0.2);
            z-index: 9;
            display: none;
        }
        textarea{
            border: 1px solid #c5add7;
            padding: 0 5px;
            max-width: 80%;
            min-width: 50%;
            max-height: 300px;
            overflow-y: scroll;
        }
        .row span{
            font-size: 18px;
            color: #5c307d;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：调剂申请
<hr>
<div class="title">
    <table-btn class="top" ng-click="transferapply()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />课程调剂申请</table-btn>
<span>调剂申请时间在选课结束之后，调剂系统开放之前，如需调剂，请及时填写调剂申请</span>
</div>
<!--表格-->
<div style="width:100%">
    <div class="tablebox" style="width:100%;">
        <table class="table" style="table-layout:fixed">
            <thead>
            <th>申请学期</th>
            <th style="width: 100px">主专业</th>
            <th style="width: 100px">辅修专业</th>
            <th>原因</th>
            <th>申请日期</th>
            <th style="width: 100px">审核状态</th>
            <th>拒绝原因</th>
            <th></th>
            </thead>
            <tbody>
            <tr ng-repeat="data in datas">
                <td ng-bind="data.term"></td>
                <td ng-bind="data.studentMajor"></td>
                <td ng-bind="data.otherMajor"></td>
                <td ng-bind="data.reason" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"></td>
                <td ng-bind="data.setdate"></td>
                <td ng-bind="data.status"></td>
                <td ng-bind="data.reject" ng-if="data.status!='已通过'" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"></td>
                <td ng-if="data.status=='已通过'"></td>
                <td>
                    <table-btn ng-click="update(data)" ng-if="semester==data.term && data.status!='已通过'">修改</table-btn>
                    <table-btn ng-click="del(data)" ng-if="semester==data.term && data.status!='已通过'">删除</table-btn>
                    <table-btn ng-click="detail(data)">查看详情</table-btn>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
<%--查看课程详情--%>
<div class="table-courseshow">
    <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <ul>
            <li><span>申请学期:</span><span ng-bind="z.term"></span></li>
            <li><span>调剂原因：</span><span style="word-wrap: break-word;display: block; margin-left: 123px; margin-top: -20px; min-height: 20px;" ng-bind="z.reason"></span></li>
            <li><span>审核状态：</span><span ng-bind="z.status"></span></li>
            <li ng-if="z.status!='已通过'"><span>拒绝原因：</span><span style="word-wrap: break-word;display: block; margin-left: 123px; margin-top: -20px; min-height: 20px;" ng-bind="z.reject"></span></li>
        </ul>
    </div>
</div>
<div class="black"></div>
<div class="table-addform container-fluid a-show">
    <form id="MenuForm">
        <div class="row">
            <ul>
                <li>
                    <span>申请原因</span>
                    <input hidden ng-model="x.transferid" name="transferid" id="transferid" />
                </li>
            </ul>
            <ul>
                <li>
                    <textarea rows="10" cols="100" ng-model="x.reason" name="reason" id="reason"></textarea>
                </li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm" >确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope,$filter) {
        $scope.cantiaojiapply=false;
        //加载信息
        $scope.search = function () {
            loading();//加载
            remotecall("stu_transferapply_load",{pageNum:pageNum,pageSize:pageSize},function (data) {
                    closeLoading();//关闭加载层\
                    $scope.datas=data.rows;
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
                    if(data.total==0){
                        closeLoading();//关闭加载层
                        parent.pMsg("暂时没有调剂申请信息");
                    }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            loading();
            remotecall("basic_coursechoosetime_load",'',function (data) {
                closeLoading();//关闭加载层
                if(data!=null&&data!=""){
                    $scope.thischooseend = data[0].thischooseend;
                    $scope.thatchooseend = data[0].thatchooseend;
                    $scope.otherchooseend = data[0].otherchooseend;
                    $scope.tiaojistart=data[0].tiaojistart;
                }
                else{
                    parent.pMsg("当前未设置选课时间");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载时间失败");
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
                pageNum = pn;//改变当前页
                //重新加载数据
                $scope.search();
            }
        };
        $scope.search();
        $scope.checkedit=function () {
            loading();
            remotecall("basic_semester_load",'',function (data) {
                closeLoading();
                if(data.length>0){
                    $scope.semester=data[0].semester;
                }else{
                    parent.pMsg("找不到当前学期");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("加载错误");
            });
        }
        $scope.checkedit();
        //隐藏
        $scope.cancel=function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            },300);
            $('table,.title,.pagingbox').show();
        };
        $scope.close=function () {
            $(".table-courseshow").hide();
            $(".black").hide();
        };
        $scope.del=function (data) {
            parent.pConfirm("确认通过选中的所有内容吗？",function () {
            loading();
            remotecall("stu_transferapply_del",data,function (data) {
                closeLoading();
                if(data.result){
                    parent.pMsg("删除成功");
                    $scope.search();
                    $scope.$apply();
                }else{
                    parent.pMsg("删除失败");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("加载错误");
            });},function () {
            });
        };
        $scope.update=function (data) {
            $scope.inittime();
            if($scope.cantiaojiapply){
            add_edit=false;
            $("#table-courseshow").hide();
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
            $scope.x=data;}
            else{
                parent.pMsg("当前时间不能申请调剂");
            }
        };
        $scope.detail=function (data) {
            $scope.z=data;
            $(".table-courseshow").show();
            $(".black").show();
        }
        $scope.inittime=function () {
            var date = new Date();
            var seperator1 = "-";
            var seperator2 = ":";
            var month = date.getMonth() + 1;
            var strDate = date.getDate();
            if (month >= 1 && month <= 9) {
                month = "0" + month;
            }
            if (strDate >= 0 && strDate <= 9) {
                strDate = "0" + strDate;
            }
            var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
                    + " " + date.getHours() + seperator2 + date.getMinutes()
                    + seperator2 + date.getSeconds();
            var time=ConvertDateFromString(currentdate);
           if(ConvertDateFromString($scope.thatchooseend)<time&&ConvertDateFromString($scope.thischooseend)<time&&ConvertDateFromString($scope.otherchooseend)<time&&time<ConvertDateFromString($scope.tiaojistart)){
                $scope.cantiaojiapply=true;
            }
        }
        $scope.transferapply = function () {
            $scope.inittime();
            if($scope.cantiaojiapply){
                add_edit=true;
                $("#table-courseshow").hide();
                $('.table-addform').addClass('a-show');
                $('.table-addform').removeClass('a-hide');
                $('table,.title,.pagingbox').hide();
                $('.table-addform').show();
                $("#MenuForm textarea").val("");
            }else {
                parent.pMsg("当前时间不能申请调剂");
            }

        };
        $("#MenuForm").validate({
            submitHandler:function(form){
                loading();
                var parames = $("#MenuForm").serializeObject();//参数
                //验证通过,然后就保存
                if(add_edit){
                    remotecall("stu_transferapply_add",parames,function (data) {
                        if(data.result){
                            closeLoading();
                            parent.pMsg("添加成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $('#MenuForm input').text("");
                            $scope.search();
                            $scope.$apply();
                        }else{
                            closeLoading();
                            parent.pMsg(data.errormessage);
                        }
                    },function (data) {
                        closeLoading();
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }else{
                    remotecallasync("stu_transferapply_edit",parames,function (data) {
                        if(data.result) {
                            closeLoading();
                            parent.pMsg("修改成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $scope.search();
                            $scope.$apply();
                        }else {
                            closeLoading();
                            parent.pMsg(data.errormessage);
                        }
                    },function (data) {
                        closeLoading();
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }
            },
            rules:{
                reason:{
                    required:true
                }
            },
            messages:{
                reason:{
                    required:"请输入调剂原因"
                }
            },
            //重写showErrors
            showErrors: function (errorMap, errorList) {
                var msg = "";
                $.each(errorList, function (i, v) {
                    layer.tips(v.message, v.element, { time: 2000 });
                    return false;
                });
            },
            /* 失去焦点时不验证 */
            onfocusout: false
        });
    });
    function ConvertDateFromString(dateString) {
        if (dateString) {
            var date = new Date(dateString).getTime();
            return date;
        }
    }
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>


