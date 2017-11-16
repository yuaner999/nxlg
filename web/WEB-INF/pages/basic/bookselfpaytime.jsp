<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/20
  Time: 16:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
</head>
<style>
    <%--查看详情--%>
    .table-show{
        position:relative;
        top: 0;
        left: 0 !important;
    }
    .table-show .row{
        padding: 10px 0;
    }
    .table-show .bttn{
        margin-left: 25%;
        border: 1px solid #c5add7;
        height: 26px;
        background: #edeaf1;
    }
    .table-show ul{
        width: 30%;
        float: left;
    }
    .table-show li{
        margin: 10px -10px;
        display: inline-flex;
    }
    .table-show li span{
        width: 200px;
        display: inline-block;
    }
    .table-show li>span:first-child{
        color:#5c307d;
        font-family: "微软雅黑";
        margin-right:-90px;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教材缴费时间
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>
</div>
<!--表格-->
<div class="table-show" style="width: 100%">
    <div class="row" style="width: 100%">
        <ul>
            <li style="display: -webkit-box;"><span style='font-weight: bold;'>教材自助缴费时间 ：</span></li>
            <li  style="margin:27px 52px"><span>开始时间：</span><span ng-bind='paystart'></span></li>
            <li  style="margin-left: 52px"><span>结束时间：</span><span ng-bind='payend'></span></li>
        </ul>
    </div>
</div>
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class='table-addform container-fluid a-show'>
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教材缴费时间 > 设置
    <hr>
    <form id="Form">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li><span style="display: -webkit-box;font-weight: bold;">设置教材自助缴费时间：</span></li>
                <li style="margin: 16px 91px"><span>开始时间：</span><input ng-model="paystart" id="paystart" class="forminput" readonly/></li>
                <li style="margin-left: 91px"><span>结束时间：</span><input  ng-model="payend" id="payend" class="forminput" readonly/></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="close()">返回</span>
        </div>
    </form>
</div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载数据
        $scope.loadData = function () {
            loading();//加载
            remotecall("basic_bookpaytime_load",'',function (data) {
                if(data!=null&&data!=""){
                    $scope.paystart = data[0].paystart;
                    $scope.payend = data[0].payend;
                }
                else{
                    parent.pMsg("当前未设置缴费时间");
                }
                closeLoading();//关闭加载层
            },function (data) {
                parent.pMsg("加载时间失败");
                closeLoading();//关闭加载层
            });
        };
        $scope.loadData();
        //修改
        $scope.edit = function () {
            $("#paystart").val($scope.paystart);
            $("#payend").val($scope.payend);
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-show,.title').hide();
            $('.table-addform').show();
        }
        //表单验证
        $("#Form").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                var paystart=$("#paystart").val();
                var payend=$("#payend").val();
                if(ConvertDateFromString(paystart)>=ConvertDateFromString(payend)){
                    parent.pMsg("开始时间应小于结束时间");
                    closeLoading();//关闭加载层
                    return;
                }
                else{
                    remotecall("basic_bookpaytime_edit",{paystart:paystart,payend:payend},function (data) {
                        if(data){
                            closeLoading();//关闭加载层
                            parent.pMsg("修改成功");
                            setTimeout(function () {
                                $scope.close();
                            },2000);
                            $scope.loadData();
                            $scope.$apply();
                        }else {
                            closeLoading();//关闭加载层
                            parent.pMsg("修改失败");
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }
            },
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
        //日历
        $(".forminput").jeDate({
            format:"YYYY-MM-DD hh:mm:ss",
            isTime:true,
            minDate:"1990-00-00 00:00:00",
            startMin:"1990-00-00 00:00:00",     //清除日期后返回到预设的最小日期
            insTrigger:true,
            isClear:true,                         //是否显示清空
            isToday:true,                         //是否显示今天或本月
            clearRestore:true,                    //清空输入框，返回预设日期，输入框非空的情况下有效
        })
        //返回
        $scope.close=function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            },200);
            $scope.loadData();
            $('.table-show,.title').show();

        }
    });
    //时间：将字符型转为时间型，值为毫秒
    function ConvertDateFromString(dateString) {
        if (dateString) {
            var arr1 = dateString.split(" ");
            var sdate = arr1[0].split('-');
            var mdate = arr1[1].split(':');
            var date = (new Date(sdate[0],sdate[1],sdate[2],mdate[0],mdate[1],mdate[2])).getTime();
            return date;
        }
    }
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>