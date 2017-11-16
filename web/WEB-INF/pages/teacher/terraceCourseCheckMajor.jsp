<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-05-2
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
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：开课课程审核
<hr>
<div class="title">
    <table-btn ng-click="previous()">返回上层</table-btn>
</div>
<table-nav>
    <li ng-click="dofilter(1)" class="sele">待审核列表</li>
    <li ng-click="dofilter(2)" >现有开课课程</li>
    <li ng-click="dofilter(3)" >未通过列表</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">

    <span class="span_width" >平&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;台：</span>
    <select type="text" ng-model="terraceName" name="terraceName" class="forminput" id="terraceName" >
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="terrace in terraces" value="{{terrace.terraceId}}" ng-bind="terrace.terraceName"></option>
    </select>
    <span class="span_width" >培养层次：</span>
    <select  type="text" ng-model="majorLevel" name="majorLevel" class="forminput" id="majorLevel">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="majorLevel in majorLevels" value="{{majorLevel.wordbookValue}}" ng-bind="majorLevel.wordbookValue"></option>
    </select>
    <span class="span_width" >开课学期：</span>
    <select  ng-model="termName" name="termName" class="forminput sel" id="termName"/>
    <option value="">--请选择--</option>
    <option ng-repeat="option in terms" value="{{option.semester}}" ng-bind="option.semester"></option>
    </select>

    <span ng-if="show=='1'" class="span_width">审核类别：</span>
    <select  type="text" ng-model="$parent.checktype" name="checktype" class="forminput" id="checktype" ng-if="show=='1'"/>
    <option value="">--请选择--</option>
    <option value="新增">新增</option>
    <option value="修改">修改</option>
    <option value="删除">删除</option>
    </select>
    <table-btn id="search" ng-click="loadData()">搜索</table-btn>
    <table-btn ng-if="show=='1'" ng-click="pass()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>通过</table-btn>
    <table-btn ng-if="show=='1'" ng-click="reject()"><img src="<%=request.getContextPath()%>/images/tablereject.png"/>拒绝</table-btn>
</div>

<!--平台课程列表-->
<div class="tablebox" id="allInfo">
    <table class="table"  style="table-layout:fixed">
        <thead>
        <th ng-if="show==1" class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
        <th>年级</th>
        <th>学院</th>
        <th>专业</th>
        <th>培养层次</th>
        <th>平台</th>
        <th>课程</th>
        <th>课程类别三</th>
        <th>课程类别四</th>
        <th>课程类别五</th>
        <th>开课学期</th>
        <th>主修/辅修</th>
        <th>备注</th>
        <th>审核状态</th>
        <th>审核类别</th>
        <th ng-if="show==3">未通过原因</th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-if="show==1" class="thischecked" ng-click="thischecked(Info)">
                <input type="checkbox" ng-model="Info.td0" name="mtc_id" value="{{Info.mtc_id}}"/>
            </td>
            <td  ng-bind="Info.mtc_grade"></td>
            <td ng-bind="Info.majorCollege"></td>
            <td ng-bind="Info.majorName"></td>
            <td ng-bind="Info.level"></td>
            <td ng-bind="Info.terraceName"></td>
            <td ng-bind="Info.chineseName"></td>
            <td ng-bind="Info.courseCategory_3"></td>
            <td ng-bind="Info.courseCategory_4"></td>
            <td ng-bind="Info.courseCategory_5"></td>
            <td ng-bind="Info.mtc_courseTerm"></td>
            <td ng-bind="Info.mtc_majorWay"></td>
            <td ng-bind="Info.mtc_note"></td>
            <td ng-bind="Info.mtc_checkStatus"></td>
            <td  ng-bind="Info.mtc_checkType"></td>
            <td  ng-if="show==3" ng-bind="Info.mtc_refuseReason" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width: 100%"
                 ng-click="ReasonDetail(Info.mtc_refuseReason,$index)" class="Ar"></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox">
    <paging></paging>
</div>

</body>
</html>
<script>
    var college = decodeURI(GetQueryString("college"));
    var major = decodeURI(GetQueryString("major"));
    var grade = decodeURI(GetQueryString("grade"));
    var filter=0;
    var mtc_id=null;
    var num=0;
    var oldsearchchecktype="";
    var app = angular.module('app',[]).controller('ctrl',function ($scope) {
        $scope.show=1;
        $scope.all = false;
        $scope.datalist=[];
        $scope.dataitem={};

        $scope.previous=function(){
            location.href = 'terraceCourseCheck.form';
        }
//加载平台信息
        remotecall("terraceBox_loading",'',function (data) {
            $scope.terraces = data;
            console.log($scope.terraces);
            loadTerrace = true;
        },function (data) {
            parent.pMsg("加载数据失败");
        });

        //加载开学学期
        remotecall("teacher_terraceCourse_loadterm","",function (data) {
            closeLoading();//关闭加载层
            $scope.terms = data;
        },function (data) {
            closeLoading();//关闭加载层
            parent.pMsg("请求数据库失败");
        });

        //加载培养层次
        remotecall("majorLevelBox_loading", {}, function (data) {
            console.log(data)
            $scope.majorLevels = data;
            loadmajorLevel = true;
        }, function (data) {
            parent.pMsg("加载培养层次数据失败！");
        });

        //加载数据
        $scope.loadData = function (){
            if ($scope.show == 1) {
                oldsearchchecktype=$scope.checktype;
            }
            console.log($scope.checktype);
            loading();//加载
            remotecall("teacher_terraceCourseCheck_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr,filter: $scope.show,
                college: college,
                major: major,
                grade: grade,
                terraceName:$scope.terraceName,
                termName:$scope.termName,
                majorLevel:$scope.majorLevel,
                checkType: $scope.checktype},function (data) {
                $scope.allInfo = data.rows;
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
                num=0;
                $scope.all = false;
                for(i=0;i<$scope.allInfo.length;i++){
                    $scope.allInfo[i].td0=false;
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
        }
//点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadData();
        }
        $scope.loadDataFirst();
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
            if(str==3){
                $scope.show=3;
                $scope.checktype="";
            }else if(str==1){
                $scope.show=1;
                $scope.checktype=oldsearchchecktype;
            }
            else if(str==2){
                $scope.show=2;
                $scope.checktype="";
            }
            $scope.loadData();

        }
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
        //通过功能
        $scope.pass = function () {
            var checknum=$scope.datalist.length;
            if(checknum<1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else{
                //$scope.dataitem=$scope.datalist[0];
                loading();
                parent.pConfirm("确认通过选中的"+checknum+"条内容吗？",function () {
                    remotecall("teacher_terraceCourseCheck_pass",{passIds:$scope.datalist},function (data) {
                        closeLoading();//关闭加载层
                        if(data){
                            parent.pMsg("审核通过");
                            //重新加载菜单
                            $scope.Cdetail($scope.item);
                            $scope.$apply();
                        }else {
                            parent.pMsg("审核不通过");
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("审核请求失败");
                        console.log(data);
                    });
                },function () {
                    closeLoading();//关闭加载层
                });
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
                    value: ' ', //初始时的值，默认空字符
                }, function (value) {
                    if (value) {
                        loading();
                        remotecallasync("teacher_terraceCourseCheck_reject",{mtc_id:$scope.dataitem.mtc_id,reason:value},function (data) {
                            closeLoading();//关闭加载层
                            if(data){
                                $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                                $scope.Cdetail($scope.item);
                                $scope.$apply();
                            }else {
                                parent.pMsg("驳回原因不能为空");
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
                var index = $scope.datalist.indexOf(tr);
                if (index > -1) {
                    $scope.datalist.splice(index, 1);
                }
            }
            if(num==$scope.allInfo.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                $scope.all=true;
                for(i=0;i<$scope.allInfo.length;i++){
                    $scope.allInfo[i].td0=true;
                    $scope.datalist.push($scope.allInfo[i]);
                }
                num=$scope.allInfo.length;
            }else{
                $scope.all=false;
                for(i=0;i<$scope.allInfo.length;i++){
                    $scope.allInfo[i].td0=false;
                    $scope.datalist=[];
                    $scope.dataitem={};
                }
                num=0;
            }
        };
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>