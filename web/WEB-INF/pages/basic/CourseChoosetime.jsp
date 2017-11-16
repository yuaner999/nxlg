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
        width: 300px;
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
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：设置选课时间
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>
</div>
<!--表格-->
<div class="table-show" style="width: 100%">
    <div class="row" style="width: 100%">
        <ul>
            <li><span> 本专业课程 </span></li><br/>
            <li><span>选课开始时间：</span><span ng-bind="thischoosestart"></span></li>
            <li><span>选课结束时间：</span><span ng-bind="thischooseend"></span></li>
        </ul>
        <ul>
            <li><span> 辅修选课时间  </span></li><br/>
            <li><span>选课开始时间：</span><span ng-bind="thatchoosestart"></span></li>
            <li><span>选课结束时间：</span><span ng-bind="thatchooseend"></span></li>
        </ul>
        <ul>
            <li><span> 其他专业课程  </span></li><br/>
            <li><span>选课开始时间：</span><span ng-bind="otherchoosestart"></span></li>
            <li><span>选课结束时间：</span><span ng-bind="otherchooseend"></span></li>
        </ul>
        <hr>
        <ul>
            <li><span> 调剂时间  </span></li><br/>
            <li><span>开始时间：</span><span ng-bind="tiaojistart"></span></li>
            <li><span>结束时间：</span><span ng-bind="tiaojiend"></span></li>
        </ul>
        <ul>
            <li><span> 调剂确认时间  </span></li><br/>
            <li><span>开始时间：</span><span ng-bind="tiaojicomfirmstart"></span></li>
            <li><span>结束时间：</span><span ng-bind="tiaojicomfirmend"></span></li>
        </ul>
        <hr>
        <ul>
            <li><span> 退课时间  </span></li><br/>
            <li><span>开始时间：</span><span ng-bind="tuikestart"></span></li>
            <li><span>结束时间：</span><span ng-bind="tuikeend"></span></li>
        </ul>
    </div>
</div>
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <form id="Form">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li><span>本专业课程时间设置</span></li><br/>
                <li><span>选课开始时间：</span><input ng-model="thischoosestart" id="thischoosestart" class="forminput" readonly/></li>
                <li><span>选课结束时间：</span><input type="text" ng-model="thischooseend" id="thischooseend" class="forminput" readonly/></li>
                <li><span>辅修选课时间设置</span></li><br/>
                <li><span>选课开始时间：</span><input type="text" ng-model="thatchoosestart" id="thatchoosestart" class="forminput" readonly/></li>
                <li><span>选课结束时间：</span><input type="text" ng-model="thatchooseend" id="thatchooseend" class="forminput" readonly/></li>

            </ul>
            <ul class="col-sm-3 col-xs-3">
                <li><span>课程调剂时间设置</span></li><br/>
                <li><span>开始时间：</span><input type="text" ng-model="tiaojistart" id="tiaojistart" class="forminput" readonly/></li>
                <li><span>结束时间：</span><input type="text" ng-model="tiaojiend" id="tiaojiend" class="forminput" readonly/></li>
                <li><span>调剂确认时间设置</span></li><br/>
                <li><span>开始时间：</span><input type="text" ng-model="tiaojicomfirmstart" id="tiaojicomfirmstart" class="forminput" readonly/></li>
                <li><span>结束时间：</span><input type="text" ng-model="tiaojicomfirmend" id="tiaojicomfirmend" class="forminput" readonly/></li>
            </ul>
            <ul  class="col-sm-3 col-xs-3">
                <li><span>其他专业课程时间设置</span></li><br/>
                <li><span>选课开始时间：</span><input type="text" ng-model="otherchoosestart" id="otherchoosestart" class="forminput" readonly/></li>
                <li><span>选课结束时间：</span><input type="text" ng-model="otherchooseend" id="otherchooseend" class="forminput"readonly/></li><br/>
                <li><span>退课时间设置</span></li><br/>
                <li><span>退课开始时间：</span><input type="text" ng-model="tuikestart" id="tuikestart" class="forminput" readonly/></li>
                <li><span>退课结束时间：</span><input type="text" ng-model="tuikeend" id="tuikeend" class="forminput"readonly/></li>
            </ul>
            <ul  class="col-sm-3 col-xs-3">
                <li>
                    <div style="padding: 15px; color: #5c307d;border: 1px solid #c5add7;">
                        <span>注意事项</span>
                        <p>请先设置本专业课程,辅修选课时间,其他专业课程 选课时间,其次设置调剂选课时间、调剂确认时间，最后设置退课时间</p>
                        <p>本专业课程、辅修选课结束时间小于或等于比其他专业课程结束时间，自动调剂时间为选课时间结束后一天的2:00-5:00,调剂选课开始时间应在自动调剂结束之后,调剂确认开始时间在调剂选课结束时间之后,退课开始时间应在调剂确认时间之后</p>
                    </div>
                </li>
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
            remotecall("basic_coursechoosetime_load",'',function (data) {
                if(data!=null&&data!=""){
                    $scope.thischoosestart = data[0].thischoosestart;
                    $scope.thischooseend = data[0].thischooseend;
                    $scope.otherchoosestart = data[0].otherchoosestart;
                    $scope.otherchooseend = data[0].otherchooseend;
                    $scope.tiaojistart = data[0].tiaojistart;
                    $scope.tiaojiend = data[0].tiaojiend;
                    $scope.tiaojicomfirmstart = data[0].tiaojicomfirmstart;
                    $scope.tiaojicomfirmend = data[0].tiaojicomfirmend;
                    $scope.thatchoosestart = data[0].thatchoosestart;
                    $scope.thatchooseend = data[0].thatchooseend;
                    $scope.tuikestart = data[0].tuikestart;
                    $scope.tuikeend = data[0].tuikeend;
                }
                else{
                    parent.pMsg("当前未设置选课时间");
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
            $("#thischoosestart").val($scope.thischoosestart);
            $("#thischooseend").val($scope.thischooseend);
            $("#otherchoosestart").val($scope.otherchoosestart);
            $("#otherchooseend").val($scope.otherchooseend);
            $("#tiaojistart").val($scope.tiaojistart);
            $("#tiaojiend").val($scope.tiaojiend);
            $("#thatchoosestart").val($scope.thatchoosestart);
            $("#thatchooseend").val($scope.thatchooseend);
            $("#tiaojicomfirmstart").val($scope.tiaojicomfirmstart);
            $("#tiaojicomfirmend").val($scope.tiaojicomfirmend);
            $("#tuikestart").val($scope.tuikestart);
            $("#tuikeend").val($scope.tuikeend);
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-show,.title').hide();
            $('.table-addform').show();
        }
        //表单验证
        $("#Form").validate({
            submitHandler:function(form){
                //验证通过,然后就保存
                var thischoosestart=$("#thischoosestart").val();
                var thischooseend=$("#thischooseend").val();
                var otherchoosestart=$("#otherchoosestart").val();
                var otherchooseend=$("#otherchooseend").val();
                var tiaojistart=$("#tiaojistart").val();
                var tiaojiend=$("#tiaojiend").val();
                var thatchoosestart=$("#thatchoosestart").val();
                var thatchooseend=$("#thatchooseend").val();
                var tiaojicomfirmend=$("#tiaojicomfirmend").val();
                var tiaojicomfirmstart=$("#tiaojicomfirmstart").val();
                var tuikestart=$("#tuikestart").val();
                var tuikeend=$("#tuikeend").val();
                var date = new Date(otherchooseend);
                var month = date.getMonth() + 1;
                var strDate = date.getDate()+1;
                if (month >= 1 && month <= 9) {
                    month = "0" + month;
                }
                if (strDate >= 0 && strDate <= 9) {
                    strDate = "0" + strDate;
                }
                var currentdate = date.getFullYear() + "-" + month + "-" + strDate
                        + " " + "05:00:00";
                var time=ConvertDateFromString(currentdate);
                if(ConvertDateFromString(thischoosestart)>ConvertDateFromString(thischooseend)){
                    parent.pMsg("本专业课程选课时间设置有误");
                    return;
                }else if(ConvertDateFromString(otherchoosestart)>ConvertDateFromString(otherchooseend)){
                    parent.pMsg("其他专业课程选课时间设置有误");
                    return;
                }else if(ConvertDateFromString(tiaojistart)>ConvertDateFromString(tiaojiend)){
                    parent.pMsg("调剂时间设置有误");
                    return;
                }else if(ConvertDateFromString(tiaojicomfirmstart)>ConvertDateFromString(tiaojicomfirmend)){
                    parent.pMsg("调剂确认时间设置有误");
                    return;
                }
                else if(ConvertDateFromString(thatchoosestart)>ConvertDateFromString(thatchooseend)){
                    parent.pMsg("辅修选课时间设置有误");
                    return;
                }else if(ConvertDateFromString(tuikestart)>ConvertDateFromString(tuikeend)){
                    parent.pMsg("退课时间设置有误");
                    return;
                }
                //判断三段时间是否重叠
                else if(ConvertDateFromString(thischoosestart)<=ConvertDateFromString(tiaojiend)
                        &&ConvertDateFromString(thischooseend)>=ConvertDateFromString(tiaojistart)){
                    parent.pMsg("本专业课程选课时间与调剂时间重叠");
                    return;
                }else if(ConvertDateFromString(otherchoosestart)<=ConvertDateFromString(tiaojiend)
                        &&ConvertDateFromString(otherchooseend)>=ConvertDateFromString(tiaojistart)){
                    parent.pMsg("其他专业课程选课时间与调剂时间重叠");
                    return;
                }
                else if(ConvertDateFromString(thatchoosestart)<=ConvertDateFromString(tiaojiend)
                        &&ConvertDateFromString(thatchooseend)>=ConvertDateFromString(tiaojistart)){
                    parent.pMsg("辅修选课时间与调剂时间重叠");
                    return;
                }
                else if(ConvertDateFromString(otherchoosestart)<=ConvertDateFromString(tiaojicomfirmend)
                        &&ConvertDateFromString(otherchooseend)>=ConvertDateFromString(tiaojicomfirmstart)){
                    parent.pMsg("调剂确认时间与其他专业课程选课时间重叠");
                    return;
                }else if(ConvertDateFromString(thatchoosestart)<=ConvertDateFromString(tiaojicomfirmend)
                        &&ConvertDateFromString(thatchooseend)>=ConvertDateFromString(tiaojicomfirmstart)){
                    parent.pMsg("辅修选课时间与调剂确认时间重叠");
                    return;
                }else if(ConvertDateFromString(thischoosestart)<=ConvertDateFromString(tiaojicomfirmend)
                        &&ConvertDateFromString(thischooseend)>=ConvertDateFromString(tiaojicomfirmstart)){
                    parent.pMsg("调剂确认时间与本专业课程选课时间重叠");
                    return;
                }else if(ConvertDateFromString(tiaojistart)<=ConvertDateFromString(tiaojicomfirmend)
                        &&ConvertDateFromString(tiaojiend)>=ConvertDateFromString(tiaojicomfirmstart)){
                    parent.pMsg("调剂确认时间与调剂选课时间重叠");
                    return;
                }else if(ConvertDateFromString(tuikestart)<=ConvertDateFromString(tiaojicomfirmend)
                        &&ConvertDateFromString(tuikeend)>=ConvertDateFromString(tiaojicomfirmstart)){
                    parent.pMsg("调剂确认时间与退课时间重叠");
                    return;
                }else if(ConvertDateFromString(tuikestart)<=ConvertDateFromString(tiaojiend)
                        &&ConvertDateFromString(tuikeend)>=ConvertDateFromString(tiaojistart)){
                    parent.pMsg("调剂选课时间与退课时间重叠");
                    return;
                }
                //退课时间在调剂确认之后，调剂确认时间在调剂选课之后，
                // 调剂选课开始时间在课程结束之后
                else if(ConvertDateFromString(tuikestart)<=ConvertDateFromString(tiaojicomfirmend)){
                    parent.pMsg("时间设置错误,退课时间应在调剂确认之后");
                    return;
                }else if(ConvertDateFromString(tiaojicomfirmstart)<=ConvertDateFromString(tiaojiend)){
                    parent.pMsg("时间设置错误,调剂确认时间在调剂选课之后");
                    return;
                }else if(ConvertDateFromString(thischooseend)>ConvertDateFromString(otherchooseend)){
                    parent.pMsg("时间设置错误,本专业选课结束时间应小于或等于其他专业选课结束时间");
                    return;
                }else if(ConvertDateFromString(thatchooseend)>ConvertDateFromString(otherchooseend)){
                    parent.pMsg("时间设置错误,辅修选课结束时间应小于或等于其他专业选课结束时间");
                    return;
                }
                else if(ConvertDateFromString(tiaojistart)<=ConvertDateFromString(time)){
                    parent.pMsg("时间设置错误,调剂选课时间在自动调剂时间（其他专业选课结束的后一天2:00-5:00）之后");
                    return;
                }
                else{
                    loading();
                    remotecall("basic_coursechoosetime_edit",{tuikestart:tuikestart,tuikeend:tuikeend,tiaojicomfirmend:tiaojicomfirmend,tiaojicomfirmstart:tiaojicomfirmstart,thischoosestart:thischoosestart,thischooseend:thischooseend,otherchoosestart:otherchoosestart,otherchooseend:otherchooseend,tiaojistart:tiaojistart,tiaojiend:tiaojiend,thatchoosestart:thatchoosestart,thatchooseend:thatchooseend},function (data) {
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
            /*var arr1 = dateString.split(" ");
            var sdate = arr1[0].split('-');
            var mdate = arr1[1].split(':');*/
            var date = new Date(dateString).getTime();
            return date;
        }
    }
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>