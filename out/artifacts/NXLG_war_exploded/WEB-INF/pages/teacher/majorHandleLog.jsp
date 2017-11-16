<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017-8-23
  Time: 13:42
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
        display: none;
        position: absolute;
        top: 20%;
        margin:0 auto;
        z-index: 100;
        width: 90%;
        left: 5%;
        padding-top: 70px;
        border: 1px solid #c5add7;
        background-color: #edeaf1;
    }
     .show .table{
        width:96%;
        margin: 0 2% 15px;
    }
    .bttn{
        margin-left: 26%;
        margin-top:30px;
        border: 1px solid #c5add7;
        height: 26px;
        background: #edeaf1;
    }
    .show div{
        width: 30%;
        padding-left: 40px;
        margin: 20px,0;
        float: left;
    }
    .black{
        position: fixed;
        top: 0;
        left: 0;
        height: 100%;
        width: 100%;
        background: #000;
        opacity: 0.5;
        filter: alpha(opacity=0);
        z-index: 10;
        display: none;
    }
    /*窗口样式*/
    .windowbox{
        display: none;
    }
    .window{
        padding-top: 25px;
        position: absolute;
        top: 20%;
        left: 20% !important;
        z-index: 100;
        max-width: 1026px;
        min-width: 750px;
        border: 1px solid #c5add7;
        background-color: #edeaf1;
    }
    .window>div{
        padding: 15px;
    }
    .window>img{
        float: right;
        position: absolute;
        top: 25px;
        right: 15px;
    }
    .window li{
        margin: 10px 0;
        color: #5c307d;
    }
    .window{
    }
    #detailTotal{
        padding: 15px;
        color: #5c307d;
        font-weight: bold;
        font-size: 16px;
    }
    .table-nav li {
        width:160px;
    }
    .showTitle{
        position: absolute;
        top: 0;
        line-height: 70px;
        left: 2%;
        color: #5c307d;
        font-weight: bold;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：专业操作记录
<hr>
<!--筛选条件按钮组-->

<div class="title">
    <input class="tablesearchbtn"  type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>
    <table-btn id="search"  ng-click="loadData()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox" >
    <table class="table">
        <thead>
        <th>操作专业</th>
        <th>操作时间</th>
        <th>操作类型</th>
        <th>专业状态</th>
        <th style="width:300px;"></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td ng-bind="data.majorName"></td>
            <td ng-bind="data.mytime"></td>
            <td ng-bind="data.type"></td>
            <td ng-bind="data.result"></td>
            <td>
                <table-btn ng-click="detail(data)">查看详情</table-btn>&nbsp;
            </td>
        </tr>
        </tbody>
    </table>
</div>

<%--查看详情--%>
<div class="table-show" id="detail">
    <div class="showTitle">
        <span>操作类型：</span><span ng-bind="dataitem.type"></span>
    </div>
    <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <table class="table">
            <thead ng-if="dataitem.after">
                <th></th>
                <th ng-repeat="akey in dataitem.after">{{akey.key}}</th>
            </thead>
            <thead ng-if="dataitem.type == '删除'">
                <th></th>
                <th ng-repeat="bkey in dataitem.before">{{bkey.key}}</th>
            </thead>
            <tbody >
                <tr >
                    <td>操作之前</td>
                    <td ng-repeat="bvalue in dataitem.before">{{bvalue.value}}</td>
                </tr>
                <tr >
                    <td>操作之后</td>
                    <td ng-repeat="avalue in dataitem.after">{{avalue.value}}</td>
                </tr>
            </tbody>

        </table>
        <%--<ul >--%>
            <%--<li><span ng-bind="a"></span></li>--%>
        <%--</ul>--%>
        <%--<span>操作之后</span>--%>
    </div>
</div>

<div class="pagingbox">
    <paging></paging>
</div>
<div class="black"></div>
</body>
</html>
<script>
    var oldPageNum=1;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载数据
        $scope.loadData = function () {
            $scope.show=1;
            loading();//加载
            remotecall("teacher_majorHandleLog_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                closeLoading();
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
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("专业操作记录加载失败" );
                console.log(data);
            });
        };
        $scope.loadData();
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
                //重新加载用户信息
                if($scope.show==1){
                    $scope.loadData();
                }else if($scope.show==4){
                    $scope.getOther($scope.getOtheritem);
                }else{
                    $scope.educatePlan($scope.item);
                }
            }
        };

        //查看详情
        $scope.detail=function(data){
            data.after = strToJson(data.after);
            data.before = strToJson(data.before);
            //操作之前数据为空时全部填上空
            if((data.before == '' || data.before == 'null') && data.after){
                var stra = "";
                for(var i=0;i<data.after.length;i++){
                    stra = stra +"{value:'无'},"
                }
                stra = "["+stra.substring(0,stra.length)+"]";
                data.before = eval("("+stra+")");
            }

            if((data.after == '' || data.after == 'null') && data.before){
                var strb = "";
                for(var i=0;i<data.before.length;i++){
                    strb = strb +"{value:'无'},"
                }
                strb = "["+strb.substring(0,strb.length)+"]";
                data.after = eval("("+strb+")");
            }
//            console.log(data.before);
            $scope.tharr = keyarr;
            $scope.afterarr = valuearr;
            $scope.datalist=[];
            $scope.dataitem={};
            $scope.datalist.push(data);
            $scope.dataitem = $scope.datalist[0];
            $("#detail,.black").show();
        }
        //关闭
        $scope.close=function () {
            $('.table-show,.black').hide();
            $scope.datalist=[];
            $scope.dataitem={};
        }
        var keyarr = [];
        var valuearr = [];
        //string to Json
        function strToJson(str){
            if(str){
                return eval("("+str.replace(/{/g,"{key:'").replace(/：/g,"',value:'").replace(/}/g,"'}").replace(/null/g,"空")+")");
            }else{
//                var str = "[{value:'新增操作之前无数据'}]";
//                return eval("("+str+")");
                return "";
            }
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
