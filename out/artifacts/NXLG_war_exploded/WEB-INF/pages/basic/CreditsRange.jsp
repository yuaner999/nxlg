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
        margin-right:-50px;
    }
    .table-addform li span{
        width:160px;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：设置学分范围
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>
</div>
<!--表格-->
<div class="table-show"  style="width:100%">
    <div class="row"  style="width:100%">
        <ul>
            <li><span>每学期选修最低学分：</span><span ng-bind="mincredits" ></span></li>
        </ul>
        <ul>
            <li><span>每学期选修最高学分：</span><span ng-bind="maxcredits"></span></li>
        </ul>
    </div>
</div>
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <form id="Form">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li><span>每学期选修最低学分：</span><input type="text" ng-model="mincredits" id="mincredits" name="mincredits" class="forminput"  onkeyup="value=this.value=(this.value.match(/\d+(\.\d{0,2})?/)||[''])[0]"/><span>&nbsp;分</span></li>
                <li><span>每学期选修最高学分：</span><input type="text" ng-model="maxcredits"  id="maxcredits" name="maxcredits" class="forminput"  onkeyup="value=this.value=(this.value.match(/\d+(\.\d{0,2})?/)||[''])[0]"/><span>&nbsp;分</span></li>
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
            remotecall("basic_creditsRange_load",'',function (data) {
                if(data.length>0){
                    $scope.mincredits = data[0].mincredits;
                    $scope.maxcredits = data[0].maxcredits;
                }else{
                    parent.pMsg("当前未设置学分");
                }
                closeLoading();//关闭加载层
            },function (data) {
                parent.pMsg("加载学分失败");
                closeLoading();//关闭加载层
            });
        };
        $scope.loadData();
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
                var mincredits=$("#mincredits").val();
                var maxcredits=$("#maxcredits").val();
                if(parseFloat(mincredits)<=0 ||parseFloat(maxcredits)<=0){
                    parent.pMsg("学分必须大于0");
                    return;
                }
                if(parseFloat(mincredits)>parseFloat(maxcredits)){
                    parent.pMsg("最低学分小于最高学分");
                    return;
                }else{
                    loading();
                    remotecall("basic_creditsrange_edit",{mincredits:mincredits,maxcredits:maxcredits},function (data) {
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
            rules:{
                mincredits:{
                    required:true
                },
                maxcredits:{
                    required:true
                }
            },
            messages:{
                mincredits:{
                    required:"请输入最低学分"
                },
                maxcredits:{
                    required:"请输入最高学分"
                }},
            /* 失去焦点时不验证 */
            onfocusout: false
        });
        //返回
        $scope.close=function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            },200);
            $('.table-show,.title').show();
            $scope.loadData();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>