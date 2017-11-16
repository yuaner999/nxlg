<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/12
  Time: 17:21
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
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：课程排课时间
<hr>
<!--导航筛选 此页不需要-->
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="edits()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />批量设置</table-btn>
    <input class="tablesearchbtn" type="text" placeholder="请输入关键字进行搜索" onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="search()">搜索</table-btn>
</div>
<%--排课节次信息--%>
<div style=" position: absolute;
    margin-left: 513px;
    font-size: initial;
    line-height: 2em;
    top: 7px;">
    <div style="display: inline-block;color:red;font-size: smaller;margin-left: 106px;margin-top: 57px;">
        <span>注：“排课节次”和“不排课节次”中1代表第一大节，依次类推，点击右侧设置可以查看详细的已设置的排课节次信息</span>
    </div>
</div>
<!--表格-->
<div style="width:100%">
    <div class="tablebox" style="width:100%;">
        <table class="table">
            <thead>
            <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
            <th>课程代码</th>
            <th>课程名称</th>
            <th>承担单位</th>
            <th>总学分</th>
            <th>总学时</th>
            <th>排课节次</th>
            <th>不排课节次</th>
            <th></th>
            </thead>
            <tbody>
            <tr ng-repeat="data in datas">
                <td class="thischecked" ng-click="thischecked(data)">
                    <input id="tchecked" type="checkbox" ng-model="data.td0" name="courseId" value="{{data.courseId}}"/>
                </td>
                <td ng-bind="data.courseCode"></td>
                <td ng-bind="data.chineseName"></td>
                <td ng-bind="data.assumeUnit"></td>
                <td ng-bind="data.totalCredit"></td>
                <td ng-bind="data.totalTime"></td>
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
<div id="table_set"  title="设置" style="z-index: 9999;display:none;width:500px;height:440px;padding: 7px 19px;position:absolute;border:2px #c5add7 solid; left:30%;top:16%;background-color:#ffffff">
    <div id="table_box1" style="margin-top: 22px;">
        <label style="color: rgb(197, 173, 215);">设置</label>
        <img style="float: right; position:absolute; top:0px;right:0px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="cancel()">
    </div>
    <div id="table_box" style="margin-bottom: 10px;overflow: hidden">
        <div id="valid_result"  style="display: inline-block;width: 596px;height: 0px;border: 2px solid #c5add7;overflow: auto"></div>
    </div>

    <div class="tablebox" style="width:auto;margin-left: 72px;margin-top: 30px">
        <div style="position: absolute;margin: 10px 2px;overflow:auto;height: 407px;">
            <span style="font-weight: bold;">排课节次:</span>
            <ul id="tree" class="ztree" style="margin-top: 12px"></ul>
        </div>
        <div class="tablebox" style="margin-left: 200px;margin-top: 10px;position: absolute;overflow:auto;height: 407px;">
            <span style="font-weight: bold;">不排课节次:</span>
            <ul id="tree1" class="ztree" style="margin-top: 12px"></ul>
        </div>
    </div>

    <div class="set_time" style="position: absolute;width: 100%;bottom: 109px;">
        <form id="MenuForm">
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
    var zNodes=new Array();
    var filter=1;
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载信息
        $scope.search = function () {
            loading();//加载
            remotecall("courseManage_loadCourse",{filter:filter,pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                $scope.datas = data.rows;
                closeLoading();//关闭加载层
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
            {"id":11, "pId":1, "name":"第一大节","rs":"1"}, {"id":12, "pId":1, "name":"第二大节","rs":"2"},
            {"id":13, "pId":1, "name":"第三大节","rs":"3"}, {"id":14, "pId":1, "name":"第四大节","rs":"4"},
            {"id":15, "pId":1, "name":"第五大节","rs":"5"},
        ];
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
            if($("input[name='courseId']:checked").length<1){
                parent.pMsg("请选择一条记录");
                return;
            }
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var zTree1 = $.fn.zTree.getZTreeObj("tree1");
            zTree.checkAllNodes(false);//清空所有选中状态
            zTree1.checkAllNodes(false);
            $("#modal").show();
            $("#table_set").show();
        };
        //设置
        $scope.edit=function (tr) {
            $('#all').attr("checked",false);
            $scope.thischecked(tr);
            $scope.list.splice(0, 2,tr);
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var zTree1 = $.fn.zTree.getZTreeObj("tree1");
            zTree.checkAllNodes(false);
            zTree1.checkAllNodes(false);
            var courseId =tr.courseId;
            loading();
            remotecallasync("classesTime_getnodes", {courseId:courseId}, function (data) {//获取选课信息
                if(data.length>0){
                    if(data[0].scheduleTime!=null&&data[0].scheduleTime!=""){//获取选课节数
                        for(var i=0;i<data[0].scheduleTime.length;i++){//拆分scheduleTime中存储的字符串
                            var ztree_str=data[0].scheduleTime.substr(i,1);
                            if(data[0].scheduleTime.substr(i+1,1)=="|"){
                                i+=1;
                            }else{
                                ztree_str=data[0].scheduleTime.substr(i,2);
                                i+=2;
                            }
                            for(var j=0;j<zNodes.length;j++){
                                if(zNodes[j].rs==ztree_str){
                                    zTree.checkNode(zTree.getNodeByParam("id",zNodes[j].id),true);
                                }
                            }
                        }
                    }
                    if(data[0].nonscheduleTime!=null&&data[0].nonscheduleTime!="") {//获取不选课节数
                        for (var m = 0; m < data[0].nonscheduleTime.length; m++) {//拆分nonscheduleTime中存储的字符串
                            var ztree_str = data[0].nonscheduleTime.substr(m,1);
                            if(data[0].nonscheduleTime.substr(m+1,1)==="|"){
                                m += 1;
                            }else{
                                ztree_str=data[0].nonscheduleTime.substr(m,2);
                                m+=2;
                            }
                            for (var n = 0; n < zNodes.length; n++) {
                                if (zNodes[n].rs == ztree_str) {
                                    zTree1.checkNode(zTree1.getNodeByParam("id", zNodes[n].id), true);
                                }
                            }
                        }
                    }
                    closeLoading();//关闭加载层
                    parent.pMsg("加载排课信息成功");
                }else{
                    closeLoading();//关闭加载层
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
                var setIds = $("input[name='courseId']:checked").map(function(index,elem) {
                    return $(elem).val();
                }).get();//需要设置的Id
                var node=new Array();
                var node1=new Array();
                var j=0,k=0;
                var zTree = $.fn.zTree.getZTreeObj("tree");
                var zTree1 = $.fn.zTree.getZTreeObj("tree1");
                var act=zTree.transformToArray(zTree.getNodes());//树形菜单序列化
                var act1=zTree.transformToArray(zTree1.getNodes());//树形菜单序列化
                for(var i=0,n=0;i<act.length;i++)//检测是否存在一节课同时被选为排课节次和不排课节次
                {
                    if(act[i].checked=== true){
                        for(var m=0,p=0;m<act1.length;m++)//
                        {
                            if(act1[m].checked=== true){
                                if(act[i].rs===act1[m].rs){
                                    closeLoading();//关闭加载层
                                    parent.pMsg("排课信息冲突:"+act[i].name+"不能既是排课节次，又是不排课节次");
                                    return;
                                }
                            }
                        }
                    }
                }
                for(var i=0,n=0;i<act.length;i++)//获取排课节次
                {
                    if(act[i].checked=== true){
                        node[n] =act[i].rs;
                        j++;
                        n++;
                    }
                }
                for(var m=0,p=0;m<act1.length;m++)//获取不排课节次
                {
                    if(act1[m].checked=== true){
                        node1[p] =act1[m].rs;
                        k++;
                        p++;
                    }
                }
                var ztree_node=node.join("|");//拼接字符串
                var ztree_node1=node1.join("|");
                var parames = $("#MenuForm").serializeObject();//参数
                parames["courseIds"]=setIds;
                parames["node"]=ztree_node;
                parames["node1"]=ztree_node1;
                remotecall("classesTime_edit",parames,function (data) {
                    if(data){
                        closeLoading();//关闭加载层
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
                        closeLoading();//关闭加载层
                        parent.pMsg("设置失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("数据库请求失败");
                    console.log(data);
                });
            },
            rules:{
            },
            messages:{
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
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>


