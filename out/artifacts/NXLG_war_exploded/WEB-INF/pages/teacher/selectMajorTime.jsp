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
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：设置选修时间
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>
</div>
<!--表格-->
<div class="table-show" style="width: 100%">
    <div class="row" style="width: 100%">
        <ul>
            <li><span>选修开始时间：</span><span ng-bind="startTime"></span></li>
            <li><span>选修结束时间：</span><span ng-bind="endTime"></span></li>
        </ul>
        <ul>
            <li><span>辅修开始时间：</span><span ng-bind="startT"></span></li>
            <li><span>辅修结束时间：</span><span ng-bind="endT"></span></li>
        </ul>
    </div>
</div>
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <form id="Form">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li><span>选修开始时间：</span><input type="text" ng-model="startTime" id="startTime" class="forminput"/></li>
                <li><span>选修结束时间：</span><input type="text" ng-model="endTime" id="endTime" class="forminput"/></li>
                <li><span>辅修开始时间：</span><input type="text" ng-model="startT" id="startT" class="forminput"/></li>
                <li><span>辅修结束时间：</span><input type="text" ng-model="endT" id="endT" class="forminput"/></li>
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
            remotecall("teacher_selectMajorTime_start1",'',function (data) {
                $scope.startTime = data[0].wordbookValue;
            },function (data) {
                parent.pMsg("加载选修开始时间失败");
            });
            remotecall("teacher_selectMajorTime_end1",'',function (data) {
                $scope.endTime = data[0].wordbookValue;
            },function (data) {
                parent.pMsg("加载选修结束时间失败");
            });
            remotecall("teacher_selectMajorTime_start2",'',function (data) {
                $scope.startT = data[0].wordbookValue;
            },function (data) {
                parent.pMsg("加载辅修开始时间失败");
            });
            remotecall("teacher_selectMajorTime_end2",'',function (data) {
                $scope.endT = data[0].wordbookValue;
                closeLoading();//关闭加载层
            },function (data) {
                parent.pMsg("加载辅修结束时间失败");
                closeLoading();//关闭加载层
            });
        };
        //首次加载
        //先定义，后使用，否则出错误！！！
        $scope.loadData();
        //修改
        $scope.edit = function () {
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-show,.title').hide();
            $('.table-addform').show();
        }
        //表单验证
        $("#Form").validate({
            submitHandler:function(form){
                //验证通过,然后就保存
                var startTime=$("#startTime").val();
                var endTime=$("#endTime").val();
                var startT=$("#startT").val();
                var endT=$("#endT").val();
                if(ConvertDateFromString(startTime)>ConvertDateFromString(endTime)){
                    parent.pMsg("选修时间设置有误");
                    return;
                }else if(ConvertDateFromString(startT)>ConvertDateFromString(endT)){
                    parent.pMsg("辅修时间设置有误");
                    return;
                }else{
                    loading;
                    remotecall("teacher_selectMajorTime_edit",{startTime:startTime,endTime:endTime,startT:startT,endT:endT},function (data) {
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
                    //msg += (v.message + "\r\n");
                    //在此处用了layer的方法,显示效果更美观
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