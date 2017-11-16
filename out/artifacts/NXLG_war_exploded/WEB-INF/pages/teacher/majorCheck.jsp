<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-17
  Time: 15:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：专业审核
<hr>
<table-nav>
    <li ng-click="dofilter(1)" class="sele">待审核列表</li>
    <li ng-click="dofilter(0)" >现有专业列表</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-if="top"ng-click="pass()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>通过</table-btn>
    <table-btn ng-if="top"ng-click="reject()"><img src="<%=request.getContextPath()%>/images/tablereject.png"/>拒绝</table-btn>
    <input class="tablesearchbtn s" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadData()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th ng-if="top" class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
        <th>院(系)/部</th>
        <th>专业名称</th>
        <th>所属学科</th>
        <th>培养层次</th>
        <th>学制</th>
        <th>专业状态</th>
        <th>审核状态</th>
        <th>审核类别</th>
        <th ng-if="top==false">未通过原因</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td ng-if="top" class="thischecked" ng-click="thischecked(data)">
                <input type="checkbox" ng-model="data.td0" name="majorId" value="{{data.majorId}}"/>
            </td>
            <td ng-bind="data.majorCollege"></td>
            <td ng-bind="data.majorName"></td>
            <td ng-bind="data.subject"></td>
            <td ng-bind="data.level"></td>
            <td ng-bind="data.length"></td>
            <td ng-bind="data.majorStatus"></td>
            <td ng-bind="data.checkStatus"></td>
            <td ng-bind="data.checkType"></td>
            <td ng-if="top==false" class="Ar" ng-bind="data.refuseReason" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"
                ng-click="ReasonDetail(data.refuseReason,$index)"></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
<!--新建表单-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <form id="AddForm">
        <ul class="col-sm-3 col-xs-3">
            <%--<li><input type="text"  ng-model="dataitem.majorId" class="forminput" style="display:none"/></li>--%>
            <li>
                <span>院(系)/部：</span>
                <select  ng-model="dataitem.majorCollege" name="majorCollege" class="forminput" id="majorCollege">
                    <option value="">--请选择--</option>
                    <option ng-repeat="option in options_majorCollege" value="{{option.wordbookValue}}" ng-bind="option.wordbookValue"></option>
                </select>
            </li>
            <li><span>国标专业个数：</span><input type="text"  ng-model="dataitem.internationalNum" name="internationalNum" class="forminput" id="internationalNum"/></li>
            <li><span>国标专业代码：</span><input type="text"  ng-model="dataitem.internationalCode" name="internationalCode" class="forminput" id="internationalCode"/></li>
            <li><span>专业代码：</span><input type="text"  ng-model="dataitem.majorCode" name="majorCode" class="forminput" id="majorCode"/></li>
            <li><span>专业名称：</span><input type="text" ng-model="dataitem.majorName" name="majorName" class="forminput" id="majorName"/></li>
        </ul>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
</body>
</html>
<script>
    var filter=1;
    var majorid=null;
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.top=true;
        //加载数据字典
        $scope.loadData = function () {
            loading();//加载
            remotecall("teacher_majorCheck_load",{pageNum:pageNum,pageSize:pageSize,filter:filter,searchStr:searchStr},function (data) {
                closeLoading();//关闭加载层
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
                num=0;
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
                parent.pMsg("加载数据失败" );
                console.log(data);
            });
            $scope.datalist=[];
            $scope.dataitem={};
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
                //重新加载菜单
                $scope.loadData();
            }
        };
        $scope.dofilter=function(str){
            pageNum=1;
            if(str==1){
                $scope.top=true;
            }else if(str==0){
                $scope.top=false;
            }
            filter = str;
            $scope.loadData();
        }
        //checked 复选框判断
        $scope.all = false;
        $scope.datalist=[];
        $scope.dataitem={};
        //首次加载
        //先定义，后使用，否则出错误！！！
        $scope.loadData();
        //通过功能
        $scope.pass = function () {
            var checknum=$scope.datalist.length;
            if(checknum<1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else{
                //$scope.dataitem=$scope.datalist[0];
                parent.pConfirm("确认通过选中的所有内容吗？",function () {
                    loading();
                    remotecallasync("teacher_majorCheck_pass",{passIds:$scope.datalist},function (data) {
                        closeLoading();//关闭加载层
                        if(data){
                            parent.pMsg("审核通过");
                            //重新加载菜单
                            $scope.loadData();
                            $scope.$apply();
                        }else {
                            parent.pMsg("审核不通过");
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("审核请求失败");
                        console.log(data);
                    });
                },function () {});
            }
        };
        //拒绝
        $scope.reject = function () {
            var checknum=$scope.datalist.length;
            if(checknum!=1) {
                parent.pMsg("只能选择一条记录");
                return;
            }
            else{
                $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").show();
                $(".layui-layer-shade").hide();
                $scope.dataitem=$scope.datalist[0];
                layer.prompt({
                    title: '未通过原因',
                    formType: 2,
                }, function (str) {
                    if (str) {
                        if(str==""){return;}
                        loading();
                        remotecallasync("teacher_majorCheck_reject",{majorId:$scope.dataitem.majorId,reason:str},function (data) {
                            closeLoading();//关闭加载层
                            if(data){
                                $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                                $scope.loadData();
                                $scope.$apply();
                            }else {
                                parent.pMsg("添加失败");
                            }
                        },function (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("数据库请求失败");
                            console.log(data);
                        });
                        return false;
                    }
                });
            }
        };
        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.datalist.push(tr);
            }else{
                num--;
                tr.td0 = false;
                $scope.all=false;
                var index = $scope.datalist.indexOf(tr);
                if (index > -1) {
                    $scope.datalist.splice(index, 1);
                }
            }
            if(num==$scope.datas.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                $scope.all =true;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=true
                    $scope.datalist.push($scope.datas[i]);
                }
                num=$scope.datas.length;
            }else{
                $scope.all =false;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                $scope.datalist=[];
                $scope.dataitem={};
                num=0;
            }
        };
        //理由详情
        $scope.ReasonDetail=function(data,i){
            if(data==null||data==""||data.length<=5)return;
            $(".Ar:eq("+i+")").addClass("RRR");
            layer.tips(data,".RRR" ,{
                tips: [4, '#c5add7'],
                time: 3000
            });
            $(".Ar:eq("+i+")").removeClass("RRR");
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>