<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/27
  Time: 16:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/zTreeStyle/zTreeStyle.css"/>
    <script src="<%=request.getContextPath()%>/js/jquery.ztree.all.js" type="text/javascript" charset="utf-8"></script>
    <style>
        #MenuForm span{ width:200px;}
        .table>tbody>tr>td{max-width: 200px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis}
        .table_detail{height: 410px;width:506px;position: absolute;border: 3px solid #c5add7;}
        .span_detail{font-weight: bold;line-height: 3em;width:75px}
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
            opacity: .3;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教师空余时间
<hr>
<!--导航筛选 此页不需要-->
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="edits()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />批量设置</table-btn>
    <input class="tablesearchbtn" type="text" placeholder="请输入关键字进行搜索..." onkeyup="getSearchStr(this)" />
    <table-btn  id="search" ng-click="search()">搜索</table-btn>
</div>
<%--教师最多排课时间--%>
<div style="position: absolute;
    margin-left: 513px;
    font-size: initial;
    line-height: 2em;
    top: 7px;">
    <div style="display: inline-block;color:red;font-size: smaller;margin-left: 190px;margin-top: 57px;">
        <span>注：周一1代表星期一第一大节，依次类推，点击右侧设置可以查看详细的排课节次和不排课节次</span>
    </div>
</div>
<!--表格-->
<div style="width:100%">
    <div class="tablebox" style="width:100%;">
        <table class="table">
            <thead>
            <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
            <th>工号</th>
            <th>教师姓名</th>
            <th>任教单位</th>
            <th>空余节次/每天</th>
            <th>最多授课节次/每天</th>
            <th>排课节次</th>
            <th>不排课节次</th>
            <th></th>
            </thead>
            <tbody>
            <tr ng-repeat="data in datas">
                <td class="thischecked" ng-click="thischecked(data)">
                    <input id="tchecked" type="checkbox" ng-model="data.td0" name="teacherId" value="{{data.teacherId}}"/>
                </td>
                <td ng-bind="data.teacherNumber"></td>
                <td ng-bind="data.teacherName"></td>
                <td ng-bind="data.teachUnit"></td>
                <td ng-bind="data.spareTime"></td>
                <td ng-bind="data.mostClasses"></td>
                <td ng-bind="data.scheduleTime"></td>
                <td ng-bind="data.nonscheduleTime"></td>
                <td><table-btn ng-click="edit(data)">设置</table-btn></td>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
<%--遮罩层--%>
<div id="modal">
    <div class="mask"></div>
</div>
<%--设置页面--%>
<div id="table_set"  title="设置" style="z-index: 9999;display:none;width:633px;height:500px;padding: 7px 19px;position:absolute;border:2px #c5add7 solid; left:26%;top:16%;background-color:#ffffff">
    <div id="table_box1" style="margin-top: 22px;">
        <label style="color: rgb(197, 173, 215);">设置</label>
        <img style="float: right; position:absolute; top:0px;right:0px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="cancel()">
    </div>
    <div id="table_box" style="margin-bottom: 10px;">
        <div id="valid_result"  style="display: inline-block;width: 596px;height: 0px;border: 2px solid #c5add7;overflow: auto"></div>
    </div>
    <div class="tablebox" style="width:auto;">
        <div style="position: absolute;margin: 10px 2px;overflow:auto;height: 407px;">
            <span style="font-weight: bold;">排课节次:</span>
            <ul id="tree" class="ztree" style=""></ul>
        </div>
        <div class="tablebox" style="margin-left: 200px;margin-top: 10px;position: absolute;overflow:auto;height: 407px;">
            <span style="font-weight: bold;">不排课节次:</span>
            <ul id="tree1" class="ztree" style=""></ul>
        </div>
    </div>
    <div class="set_time" style="position: absolute;margin-left: 395px;top: 96px;">
        <form id="MenuForm">
            <div class="row">
                <ul class="col-sm-3 col-xs-3">
                    <li style="display: none"><span>教师Id：</span><input type="text"  ng-model="item.teacherId" name="teacherId" class="forminput" id="teacherId"/></li>
                    <li style="margin: 18px 0px;"><span style="display: block;margin-bottom: 6px">教师空余时间/节次每天:</span><input type="text"  ng-model="item.spareTime" name="spareTime" class="forminput" id="spareTime" placeholder="教师空余课时/每天"/></li>
                    <li style="margin: 28px 0px;"><span style="display: block;margin-bottom: 6px">教师最多授课节次/每天:</span><input type="text" ng-model="item.mostClasses" name="mostClasses" class="forminput" id="mostClasses" placeholder="教师最多授课课时/每天"/></li>
                </ul>
            </div>
            <div class="text-center">
                <table-btn class="confirm" id="confirm" style="width: 68px;position: fixed;margin-left: -93px;">确定</table-btn>
                <span class="tablebtn confirm" ng-click="cancel()" style="width: 68px;position: fixed;margin-left: 2px;">取消</span>
            </div>
        </form>
    </div>
</div>
</body>
</html>
<script>
    var num=0;
    var zNodes=new Array();
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载信息
        $scope.search = function () {
            loading();//加载
            remotecall("teacherManage_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                $scope.datas = data.rows;
                closeLoading();//关闭加载层
                if(data.rows.length!=0){
                    $scope.spareTime=data.rows[0].spareTime;
                    $scope.mostClasses=data.rows[0].mostClasses;
                }
                if($scope.spareTime==""){
                    $scope.spareTime=0;
                }
                if($scope.mostClasses==""){
                    $scope.mostClasses=0;
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
                $scope.all = false;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            $scope.list=[];
            $scope.item={};
        };
        zNodes= [//定义树节点
            {"id":1, "pId":0, "name":"星期一","open":true,"nocheck":true}, {"id":2, "pId":0, "name":"星期二","open":true,"nocheck":true}, {"id":3, "pId":0, "name":"星期三","open":true,"nocheck":true}, {"id":4, "pId":0, "name":"星期四","open":true,"nocheck":true},
            {"id":5, "pId":0, "name":"星期五","open":true,"nocheck":true}, {"id":6, "pId":0, "name":"星期六","open":true,"nocheck":true}, {"id":7, "pId":0, "name":"星期日","open":true,"nocheck":true},
            {"id":11, "pId":1, "name":"第一大节","rs":"周一1"}, {"id":12, "pId":1, "name":"第二大节","rs":"周一2"}, {"id":13, "pId":1, "name":"第三大节","rs":"周一3"}, {"id":14, "pId":1, "name":"第四大节","rs":"周一4"}, {"id":15, "pId":1, "name":"第五大节","rs":"周一5"},
            {"id":21, "pId":2, "name":"第一大节","rs":"周二1"}, {"id":22, "pId":2, "name":"第二大节","rs":"周二2"}, {"id":23, "pId":2, "name":"第三大节","rs":"周二3"}, {"id":24, "pId":2, "name":"第四大节","rs":"周二4"}, {"id":25, "pId":2, "name":"第五大节","rs":"周二5"},
            {"id":31, "pId":3, "name":"第一大节","rs":"周三1"}, {"id":32, "pId":3, "name":"第二大节","rs":"周三2"}, {"id":33, "pId":3, "name":"第三大节","rs":"周三3"}, {"id":34, "pId":3, "name":"第四大节","rs":"周三4"}, {"id":35, "pId":3, "name":"第五大节","rs":"周三5"},
            {"id":41, "pId":4, "name":"第一大节","rs":"周四1"}, {"id":42, "pId":4, "name":"第二大节","rs":"周四2"}, {"id":43, "pId":4, "name":"第三大节","rs":"周四3"}, {"id":44, "pId":4, "name":"第四大节","rs":"周四4"}, {"id":45, "pId":4, "name":"第五大节","rs":"周四5"},
            {"id":51, "pId":5, "name":"第一大节","rs":"周五1"}, {"id":52, "pId":5, "name":"第二大节","rs":"周五2"}, {"id":53, "pId":5, "name":"第三大节","rs":"周五3"}, {"id":54, "pId":5, "name":"第四大节","rs":"周五4"}, {"id":55, "pId":5, "name":"第五大节","rs":"周五5"},
            {"id":61, "pId":6, "name":"第一大节","rs":"周六1"}, {"id":62, "pId":6, "name":"第二大节","rs":"周六2"}, {"id":63, "pId":6, "name":"第三大节","rs":"周六3"}, {"id":64, "pId":6, "name":"第四大节","rs":"周六4"}, {"id":65, "pId":6, "name":"第五大节","rs":"周六5"},
            {"id":71, "pId":7, "name":"第一大节","rs":"周日1"}, {"id":72, "pId":7, "name":"第二大节","rs":"周日2"}, {"id":73, "pId":7, "name":"第三大节","rs":"周日3"}, {"id":74, "pId":7, "name":"第四大节","rs":"周日4"}, {"id":75, "pId":7, "name":"第五大节","rs":"周日5"},
        ];
//        zNodes= [//定义树节点
//            {"id":1, "pId":0, "name":"星期一","open":true,"nocheck":false}, {"id":2, "pId":0, "name":"星期二","open":true,"nocheck":false}, {"id":3, "pId":0, "name":"星期三","open":true,"nocheck":false}, {"id":4, "pId":0, "name":"星期四","open":true,"nocheck":false}, {"id":5, "pId":0, "name":"星期五","open":true,"nocheck":false}, {"id":6, "pId":0, "name":"星期六","open":true,"nocheck":false}, {"id":7, "pId":0, "name":"星期日","open":true,"nocheck":false},
//            {"id":11, "pId":1, "name":"第一节","rs":"周一1"}, {"id":12, "pId":1, "name":"第二节","rs":"周一2"}, {"id":13, "pId":1, "name":"第三节","rs":"周一3"}, {"id":14, "pId":1, "name":"第四节","rs":"周一4"}, {"id":15, "pId":1, "name":"第五节","rs":"周一5"}, {"id":16, "pId":1, "name":"第六节","rs":"周一6"}, {"id":17, "pId":1, "name":"第七节","rs":"周一7"}, {"id":18, "pId":1, "name":"第八节","rs":"周一8"}, {"id":19, "pId":1, "name":"第九节","rs":"周一9"}, {"id":20, "pId":1, "name":"第十节","rs":"周一10"},
//            {"id":21, "pId":2, "name":"第一节","rs":"周二1"}, {"id":22, "pId":2, "name":"第二节","rs":"周二2"}, {"id":23, "pId":2, "name":"第三节","rs":"周二3"}, {"id":24, "pId":2, "name":"第四节","rs":"周二4"}, {"id":25, "pId":2, "name":"第五节","rs":"周二5"}, {"id":26, "pId":2, "name":"第六节","rs":"周二6"}, {"id":27, "pId":2, "name":"第七节","rs":"周二7"}, {"id":28, "pId":2, "name":"第八节","rs":"周二8"}, {"id":29, "pId":2, "name":"第九节","rs":"周二9"}, {"id":30, "pId":2, "name":"第十节","rs":"周二10"},
//            {"id":31, "pId":3, "name":"第一节","rs":"周三1"}, {"id":32, "pId":3, "name":"第二节","rs":"周三2"}, {"id":33, "pId":3, "name":"第三节","rs":"周三3"}, {"id":34, "pId":3, "name":"第四节","rs":"周三4"}, {"id":35, "pId":3, "name":"第五节","rs":"周三5"}, {"id":36, "pId":3, "name":"第六节","rs":"周三6"}, {"id":37, "pId":3, "name":"第七节","rs":"周三7"}, {"id":38, "pId":3, "name":"第八节","rs":"周三8"}, {"id":39, "pId":3, "name":"第九节","rs":"周三9"}, {"id":40, "pId":3, "name":"第十节","rs":"周三10"},
//            {"id":41, "pId":4, "name":"第一节","rs":"周四1"}, {"id":42, "pId":4, "name":"第二节","rs":"周四2"}, {"id":43, "pId":4, "name":"第三节","rs":"周四3"}, {"id":44, "pId":4, "name":"第四节","rs":"周四4"}, {"id":45, "pId":4, "name":"第五节","rs":"周四5"}, {"id":46, "pId":4, "name":"第六节","rs":"周四6"}, {"id":47, "pId":4, "name":"第七节","rs":"周四7"}, {"id":48, "pId":4, "name":"第八节","rs":"周四8"}, {"id":49, "pId":4, "name":"第九节","rs":"周四9"}, {"id":50, "pId":4, "name":"第十节","rs":"周四10"},
//            {"id":51, "pId":5, "name":"第一节","rs":"周五1"}, {"id":52, "pId":5, "name":"第二节","rs":"周五2"}, {"id":53, "pId":5, "name":"第三节","rs":"周五3"}, {"id":54, "pId":5, "name":"第四节","rs":"周五4"}, {"id":55, "pId":5, "name":"第五节","rs":"周五5"}, {"id":56, "pId":5, "name":"第六节","rs":"周五6"}, {"id":57, "pId":5, "name":"第七节","rs":"周五7"}, {"id":58, "pId":5, "name":"第八节","rs":"周五8"}, {"id":59, "pId":5, "name":"第九节","rs":"周五9"}, {"id":60, "pId":5, "name":"第十节","rs":"周五10"},
//            {"id":61, "pId":6, "name":"第一节","rs":"周六1"}, {"id":62, "pId":6, "name":"第二节","rs":"周六2"}, {"id":63, "pId":6, "name":"第三节","rs":"周六3"}, {"id":64, "pId":6, "name":"第四节","rs":"周六4"}, {"id":65, "pId":6, "name":"第五节","rs":"周六5"}, {"id":66, "pId":6, "name":"第六节","rs":"周六6"}, {"id":67, "pId":6, "name":"第七节","rs":"周六7"}, {"id":68, "pId":6, "name":"第八节","rs":"周六8"}, {"id":69, "pId":6, "name":"第九节","rs":"周六9"}, {"id":70, "pId":6, "name":"第十节","rs":"周六10"},
//            {"id":71, "pId":7, "name":"第一节","rs":"周日1"}, {"id":72, "pId":7, "name":"第二节","rs":"周日2"}, {"id":73, "pId":7, "name":"第三节","rs":"周日3"}, {"id":74, "pId":7, "name":"第四节","rs":"周日4"}, {"id":75, "pId":7, "name":"第五节","rs":"周日5"}, {"id":76, "pId":7, "name":"第六节","rs":"周日6"}, {"id":77, "pId":7, "name":"第七节","rs":"周日7"}, {"id":78, "pId":7, "name":"第八节","rs":"周日8"}, {"id":79, "pId":7, "name":"第九节","rs":"周日9"}, {"id":80, "pId":7, "name":"第十节","rs":"周日10"},
//        ];
        var setting={
            showLine:false,
            data:{
                simpleData:{
                    enable:true
                }
            },
            check: {
                enable: true //显示复选框
            },
        };//
        $(document).ready(function () {//初始化树
            var t = $("#tree");
            var t1 = $("#tree1");
            t = $.fn.zTree.init(t, setting, zNodes);
            t1 = $.fn.zTree.init(t1, setting, zNodes);
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var zTree1 = $.fn.zTree.getZTreeObj("tree1");
        });
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
        //checked 复选框判断
        $scope.all = false;
        $scope.list=[];
        $scope.item={};
        //首次加载菜单
        //先定义，后使用，否则出错误！！！
        $scope.search();

        //批量设置
        $scope.edits= function () {
            if($("input[name='teacherId']:checked").length<1){
                parent.pMsg("请选择一条记录");
                return;
            }
            $scope.item.spareTime = "";
            $scope.item.mostClasses ="";
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var zTree1 = $.fn.zTree.getZTreeObj("tree1");
            zTree.checkAllNodes(false);//清空所有选中状态
            zTree1.checkAllNodes(false);
            $("#modal").show();
            $("#table_set").show();
        };
        //设置
        $scope.edit=function (tr) {
            loading();
            $('#all').attr("checked",false);
            $scope.allfn();
            tr.td0 = false;
            $scope.thischecked(tr);
            $scope.list.splice(0, 2,tr);
            $scope.item.spareTime ="";
            $scope.item.mostClasses ="";
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var zTree1 = $.fn.zTree.getZTreeObj("tree1");
            zTree.checkAllNodes(false);
            zTree1.checkAllNodes(false);
            var teacherId =tr.teacherId;
            remotecallasync("teacherSparetime_getnodes", {teacherId:teacherId}, function (data) {//获取选课信息
                if(data.length>0){
                    closeLoading();
                    $scope.item.spareTime = data[0].spareTime;
                    $scope.item.mostClasses = data[0].mostClasses;
                    $scope.$apply();
                    if(data[0].scheduleTime!=null){//获取选课节数
                        for(var i=0;i<data[0].scheduleTime.length;i++){//拆分scheduleTime中存储的字符串
                            var ztree_str=data[0].scheduleTime.substr(i,3);
                            if(data[0].scheduleTime.substr(i+3,1)=="|"){
                                i+=3;
                            }else{
                                ztree_str=data[0].scheduleTime.substr(i,4);
                                i+=4;
                            }
                            for(var j=0;j<zNodes.length;j++){
                                if(zNodes[j].rs==ztree_str){
                                    zTree.checkNode(zTree.getNodeByParam("id",zNodes[j].id),true);
                                }
                            }
                        }
                    }
                    if(data[0].nonscheduleTime!=null) {//获取不选课节数
                        for (var m = 0; m < data[0].nonscheduleTime.length; m++) {//拆分nonscheduleTime中存储的字符串
                            var ztree_str = data[0].nonscheduleTime.substr(m,3);
                            if(data[0].nonscheduleTime.substr(m+3,1)==="|"){
                                m += 3;
                            }else{
                                ztree_str=data[0].nonscheduleTime.substr(m,4);
                                m+=4;
                            }
                            for (var n = 0; n < zNodes.length; n++) {
                                if (zNodes[n].rs == ztree_str) {
                                    zTree1.checkNode(zTree1.getNodeByParam("id", zNodes[n].id), true);
                                }
                            }
                        }
                    }
                    closeLoading();
                    parent.pMsg("加载教师排课信息成功");
                }else{
                    closeLoading();
                    parent.pMsg("数据为空");
                }
            });
            $("#modal").show();
            $("#table_set").show();
        };
       //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
            }else{
                num--;
                $scope.all = false;
                tr.td0 = false;
            }
            if(num==$scope.datas.length){
                $scope.all=true;
            }else {
                $scope.all=false;
            }
        };
        //隐藏
        $scope.cancel=function () {
            $("#table_set").hide();
            $("#modal").hide();
            $scope.list=[];
            $scope.item={};
            $scope.all = false;
            for(i=0;i<$scope.datas.length;i++){
                $scope.datas[i].td0=false;
            }
        };
        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                num=0;
            }else{
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=true;
                }
                num=$scope.datas.length;
            }
        };
        //验证+保存
        $("#MenuForm").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                var setIds = $("input[name='teacherId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要设置的教师Id
                var node=new Array();
                var node1=new Array();
                var j=0,k=0,classes=0;
                var zTree = $.fn.zTree.getZTreeObj("tree");
                var zTree1 = $.fn.zTree.getZTreeObj("tree1");
                var act=zTree.transformToArray(zTree.getNodes());//树形菜单序列化
                var act1=zTree.transformToArray(zTree1.getNodes());//树形菜单序列化
                for(var i=0;i<7;i++){//判断每天排课节次是否超过教师每天最多上课课时
                    classes=0;
                    for(var j=0;j<act.length;j++){
                        if(act[j].pId==i&&act[j].checked=== true){
                            classes++;
                            if(classes>$scope.mostClasses){
                                closeLoading();
                                parent.pMsg("排课节次有错误:教师每天授课不能超过"+$scope.mostClasses+"课时");
                                return;
                            }
                        }
                    }
                }
                for(var i=0,n=0;i<act.length;i++)//检测是否存在一节课同时被选为排课节次和不排课节次
                {
                    if(act[i].pId==""||act[i].pId==null){
                        continue;
                    }
                    if(act[i].checked=== true){
                        for(var m=0,p=0;m<act1.length;m++)//
                        {
                            if(act1[m].checked=== true){
                                if(act[i].rs===act1[m].rs){
                                    var getParentNode=act[i].getParentNode();
                                    closeLoading();
                                    parent.pMsg("排课信息冲突:"+getParentNode.name+act[i].name+"不能既是排课节次，又是不排课节次");
                                    return;
                                }
                            }
                        }
                    }
                }
                for(var i=0,n=0;i<act.length;i++)//获取排课节次
                {
                    if(act[i].checked=== true){
                        if(act[i].pId==""||act[i].pId==null){
                            continue;
                        }
                        node[n] =act[i].rs;
                        j++;
                        n++;
                    }
                }
                for(var m=0,p=0;m<act1.length;m++)//获取不排课节次
                {
                    if(act1[m].checked=== true){
                        if(act1[m].pId==""||act1[m].pId==null){
                            continue;
                        }
                        node1[p] =act1[m].rs;
                        k++;
                        p++;
                    }
                }
                var ztree_node=node.join("|");//拼接字符串
                var ztree_node1=node1.join("|");
                var parames = $("#MenuForm").serializeObject();//参数
                parames["teacherIds"]=setIds;
                parames["node"]=ztree_node;
                parames["node1"]=ztree_node1;
                remotecall("teacherSparetime_edit1",parames,function (data) {
                  if(data){
                        closeLoading();
                        parent.pMsg("设置成功");
                        //重新加载
                        $("#table_set").hide();
                        $("#modal").hide();
                        $('.table-addform').hide();
                        $('table,.title,.pagingbox').show();
                        $('#MenuForm input').text("");
                        $scope.search();
                        $scope.$apply();
                    }else  {
                        closeLoading();
                        parent.pMsg("设置失败");
                    }
                },function (data) {
                    closeLoading();
                    parent.pMsg("数据库请求失败");
                    console.log(data);
                });
            },
            rules:{
                spareTime:{
                    number:true
                },
                mostClasses:{
                    number:true
                }
            },
            messages:{
                spareTime:{
                    number:"请输入合法数字"
                },
                mostClasses:{
                    number:"请输入合法数字"
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
    //绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#search").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>

