<%--
  Created by IntelliJ IDEA.
  User: zcy
  Date: 2017/5/26
  Time: 15:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <style>
        .table_detail{height: 410px;width:506px;position: absolute;border: 3px solid #c5add7;}
        .span_detail{font-weight: bold;line-height: 3em;width:75px;margin:30px}
        #table_detail{
            z-index: 9999;
        }
        #modal {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            z-index: 999;
            display:none
        }
        #modal .mask {
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            background-color: #000;
            opacity:0.5;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：课程教材列表
<hr>
<div class="title">
    <table-btn class="top" ng-click="sets(1)"><img src="<%=request.getContextPath()%>/images/tablepass.png" />批量设置使用备用教材</table-btn>
    <table-btn class="top" ng-click="sets(2)"><img src="<%=request.getContextPath()%>/images/tablepass.png" />批量设置使用首选教材</table-btn>
    <input class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入课程代码进行搜索" onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="search()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
        <th>课程代码</th>
        <th>课程名称</th>
        <th>首选教材</th>
        <th>备用教材</th>
        <th>是否使用备用教材</th>
        <th style="width:280px;"></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="courseId" value="{{data.courseId}}"/>
            </td>
            <td ng-bind="data.courseCode"></td>
            <td ng-bind="data.chineseName"></td>
            <td ng-bind="data.name"></td>
            <td ng-bind="data.name1"></td>
            <td ng-bind="data.issparecourse"></td>
            <td><table-btn ng-click="spareMaterial(data)">使用备用教材</table-btn>&nbsp&nbsp<table-btn ng-click="firstMaterial(data)">使用首选教材</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--遮罩层--%>
<div id="modal">
    <div class="mask"></div>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
</body>
</html>
<script>
//    var filter=2;
var num=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载、查询信息
        $scope.load = function () {
            loading();//加载
            remotecall("teachingmaterialsCourse_load",{pageNum: pageNum, pageSize: pageSize,searchStr: searchStr},function (data) {
                if(data.total>0){
                    for(var i=0;i<data.rows.length;i++){
                        if(data.rows[i].issparecourse=='0'){
                            data.rows[i].issparecourse='否';
                        }else if(data.rows[i].issparecourse=='1'){
                            data.rows[i].issparecourse='是';
                        }
                    }
                }
                $scope.datas = data.rows;
                closeLoading();//关闭加载层
                $('#all').attr("checked",false);
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
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
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
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
                //重新加载
                $scope.load();
            }
        };
        //checked 复选框判断
        $scope.all = false;
        $scope.Var=true;
        $scope.IsRead=true;
        $scope.list=[];
        $scope.item={};
        //首次加载
        //先定义，后使用，否则出错误！！！
        $scope.load();
        //搜索
        $scope.search = function () {
            pageNum = 1;
            $scope.load();
        }
        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                $scope.all = true;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=true;
                    $scope.list.push($scope.datas[i]);
                }
                num=$scope.datas.length;
            }else{
                $scope.all = false;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                $scope.list=[];
                num=0;
            }
        };
        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.list.push(tr);
            }else{
                num--;
                tr.td0 = false;
                $scope.all=false;
                var index = $scope.list.indexOf(tr);
                if (index > -1) {
                    $scope.list.splice(index, 1);
                }
            }
            if(num==$scope.datas.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };

        //使用备用教材
        $scope.spareMaterial=function (tr) {
            loading();
            var courseId=tr.courseId;
            remotecall("teachingmaterialsCourse_spareMaterial",{courseId:courseId,id:1},function (data) {
                if(data){
                    parent.pMsg("设置成功");
                    //重新加载管理员信息
                    closeLoading();//关闭加载层
                    $scope.load();
                }else {
                    closeLoading();
                    parent.pMsg("设置失败");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("设置失败");
                console.log(data);
            });
        }
        //使用首选教材
        $scope.firstMaterial=function (tr) {
            loading();
            var courseId=tr.courseId;
            remotecall("teachingmaterialsCourse_spareMaterial",{courseId:courseId,id:2},function (data) {
                if(data){
                    parent.pMsg("设置成功");
                    //重新加载管理员信息
                    closeLoading();//关闭加载层
                    $scope.load();
                }else {
                    closeLoading();
                    parent.pMsg("设置失败");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("设置失败");
                console.log(data);
            });
        }
        //批量设置使用备用/首选教材
        $scope.sets= function (tr) {
            if($("input[name='courseId']:checked").length<1){//获取所选择的行
                parent.pMsg("请选择一条记录");
                closeLoading();//关闭加载层
                return;
            }
            var courseIds= $("input[name='courseId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要的Id
            var id=tr;
            console.log(id);
            parent.pConfirm("确认设置选中的所有课程更换教材吗？",function(){
                loading();
                remotecall("teachingmaterialsCourse_sets",{courseIds:courseIds,id:id},function (data) {
                    if(data){
                        //重新加载管理员信息
                        $scope.load();
                        $scope.$apply();
                        closeLoading();//关闭加载层
                        parent.pMsg("设置成功");
                    }else {
                        closeLoading();
                        parent.pMsg("设置失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("设置失败");
                    console.log(data);
                });
            },function () {});
        };
    });

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
