<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/16
  Time: 9:24
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
<!--导航筛选-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：我的消息
<hr>
<table-nav>
    <li ng-click="dofilter(2)" class="sele">所有消息</li>
    <li ng-click="dofilter(1)">已读消息</li>
    <li ng-click="dofilter(0)">未读消息</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="reads()" ng-if="Var"><img src="<%=request.getContextPath()%>/images/tablepass.png" />批量标注为已读</table-btn>
    <table-btn class="top" ng-click="readall()" ng-if="Var"><img src="<%=request.getContextPath()%>/images/inforight_03.png" />全部标为已读</table-btn>
    <table-btn class="top" ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <input class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="search()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
        <th>消息标题</th>
        <th>消息内容</th>
        <th>日期</th>
        <th ng-if="IsRead">是否已读</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="messageId" value="{{data.messageId}}"/>
            </td>
            <%--<td ng-bind="data.messageTitle"></td>--%>
            <td><img src="<%=request.getContextPath()%>/images/details.png" style="cursor: pointer" ng-click="thischecked(data);checkdetail();read(data)"/>
                {{data.messageTitle}}
            </td>
            <td ng-bind="data.messageContent"></td>
            <td ng-bind="data.messageDate"></td>
            <td ng-if="IsRead" ng-bind="data.isRead"></td>
            <td><table-btn ng-click="read(data)" ng-if="Var">标为已读</table-btn>&nbsp&nbsp<table-btn ng-click="delete(data)">删除</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--查看详情--%>
<div id="table_detail"  title="查看详情" style="display:none;width:540px;height:350px;padding:10px;position:absolute;border:2px #c5add7 solid; left:28%;top:22%;background-color:#ffffff">
    <div id="table_box1" style="margin-bottom: 10px;margin-top: 10px;">
        <label style="color: rgb(197, 173, 215);">查看详情</label>
        <img style="float: right; position:absolute; top:15px;right:14px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    </div>
    <div id="table_box" style="margin-bottom: 10px;margin-top: 10px;">
        <div id="valid_result"  style="display: inline-block;width: 513px;height: 0px;border: 2px solid #c5add7;overflow: auto"></div>
    </div>
    <div id="table_det">
        <ul style="margin-top: 30px">
            <li><span class="span_detail">消息日期：</span><span type="text"  ng-bind="dataitem.messageDate"/></li>
            <li><span class="span_detail">消息标题：</span><span ng-bind="dataitem.messageTitle"/></li>
            <li><span class="span_detail">消息内容：</span><span type="text" ng-bind="dataitem.messageContent"/></li>
        </ul>
    </div>
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
    var filter=2;
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载、查询信息
        $scope.load = function () {
            loading();//加载
            remotecall("messageManage_load", {pageNum: pageNum, pageSize: pageSize,filter:filter, searchStr: searchStr}, function (data) {
                $scope.datas = data.rows;
                closeLoading();//关闭加载层
                pageCount = parseInt((data.total - 1) / pageSize) + 1;//页码总数
                $scope.pC = pageCount;
                var pages = [];
                for (var i = 1; i <= pageCount; i++) {
                    pages.push(i);
                }
                $scope.pages = pages;//共有多少页，页码内容
                changeSelect();//改变分页选中样式
                num=0;
                $scope.all = false;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                // 分页逻辑开始
                $scope.allPage=[];
                $scope.sliPage=[];
                for(var i=1;i<=Math.ceil(data.total/pageSize);i++){
                    $scope.allPage.push(i);
                }
                if($scope.datas.length<1&&pageNum>1)
                {
                    pageNum--;
                        $scope.load();
                    return;
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
        //分页加载跳转到指定页
        $scope.gotoPage = function (pn) {
            if(pn==-1){//上一页
                pn = pageNum-1;
            }
            if(pn==-2){//下一页
                pn = pageNum+1;
            }
            if(pn==1){
                pn =1;
            }
            if(pn==-3){
                pn =pageCount;
            }
            if(pn<1||pn>pageCount||pn==pageNum){//页码不正确
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
        pageNum=1;
        //首次加载
        //先定义，后使用，否则出错误！！！
        $scope.load();
        $scope.close=function () {
            $("#table_detail").hide();
            $("#modal").hide();
        }
        //右侧菜单栏
        $scope.dofilter=function(str){
            pageNum=1;
            if(str==0){
                $scope.Var=true;
                $scope.IsRead=false;
                $scope.all = false;
                $scope.list=[];
            }else if(str==1){
                $scope.Var=false;
                $scope.IsRead=false;
                $scope.all = false;
                $scope.list=[];
            }else if(str==2){
                $scope.Var=true;
                $scope.IsRead=true;
                $scope.all = false;
                $scope.list=[];
            }
            filter = str;
            $scope.load();
        }
        //删除功能
        $scope.delete=function (tr) {
            loading();//加载
            var deleteIds=new Array(tr.messageId);
            parent.pConfirm("确认删除选中的内容吗？",function (index) {
                layer.close(index);
                remotecall("messageManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        closeLoading();//关闭加载层
                        $scope.load();
                        $scope.$apply();
                    }else {
                        parent.pMsg("删除失败");
                        closeLoading();//关闭加载层
                    }
                },function (data) {
                    parent.pMsg("删除失败");
                    closeLoading();//关闭加载层
                    console.log(data);
                });
            },function () {
                closeLoading();//关闭加载层
            });

        };
        //批量删除功能
        $scope.deletes = function () {
            loading();//加载
            //获取所选择的行
            if($("input[name='messageId']:checked").length<1){
                parent.pMsg("请选择一条记录");
                closeLoading();
                return;
            }
            var deleteIds = $("input[name='messageId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有内容吗？",function () {
                remotecall("messageManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        parent.pMsg("删除成功");
                        //重新加载管理员信息
                        closeLoading();//关闭加载层
                        $scope.load();
                        $scope.$apply();
                    }else {
                        parent.pMsg("删除失败");
                        closeLoading();//关闭加载层
                    }
                },function (data) {
                    parent.pMsg("删除失败");
                    closeLoading();//关闭加载层
                    console.log(data);
                });
            },function () {
                closeLoading();//关闭加载层
            });
        };
        //查看详情
        $scope.checkdetail=function (tr) {
            $scope.dataitem={};
            $("#modal").show();
            $("#table_detail").show();
            $scope.dataitem=$scope.list[0];
        };
        //搜索
        $scope.search = function () {
            pageNum = 1;
            $scope.load();
        }
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
       //单个标注为已读
        $scope.read= function (tr) {
            loading();//加载

            var messageIds =new Array(tr.messageId);
            remotecall("messageManage_read",{messageIds:messageIds},function (data) {
                if(data){
                    parent.pMsg("消息已读");
                    //重新加载管理员信息
                    closeLoading();//关闭加载层
                    $scope.load();
                }else {
                    parent.pMsg("设置消息已读失败");
                    closeLoading();
                }
            },function (data) {
                parent.pMsg("设置消息已读失败");
                closeLoading();
                console.log(data);
            });
        };
        //批量标注为已读
        $scope.reads= function (tr) {
            loading();
            if($("input[name='messageId']:checked").length<1){//获取所选择的行
                parent.pMsg("请选择一条记录");
                closeLoading();//关闭加载层
                return;
            }
            var messageIds= $("input[name='messageId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            remotecall("messageManage_read",{messageIds:messageIds},function (data) {
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
        };
        //全部标为已读
        $scope.readall=function () {
            loading();
            remotecall("messageManage_readall","",function (data) {
                if(data){
                    parent.pMsg("设置成功");
                    //重新加载管理员信息
                    closeLoading();//关闭加载层
                    $scope.load();
                }else {
                    parent.pMsg("设置失败");
                    closeLoading();
                }
            },function (data) {
                parent.pMsg("设置失败");
                closeLoading();//关闭加载层
                console.log(data);
            });
        }
        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                $scope.all =true;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=true;
                    $scope.list.push($scope.datas[i]);
                }
                num=$scope.datas.length;
            }else{
                $scope.all =false;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                $scope.list=[];
                $scope.dataitem={};
                num=0;
            }
        };
    });

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
