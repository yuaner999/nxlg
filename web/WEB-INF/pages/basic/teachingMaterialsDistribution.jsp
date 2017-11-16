<%--
  Created by IntelliJ IDEA.
  User: gq
  Date: 2017/6/1
  Time: 16:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <style>
        #MenuForm span{ width:135px;}
        .table>tbody>tr>td{max-width: 200px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis}
        .table_detail{height: 410px;width:506px;position: absolute;border: 3px solid #c5add7;}
        .span_detail{font-weight: bold;line-height: 3em;width:75px!important;margin-left: 69px;}
        #modal {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            z-index: 999;
            display:none;
        }
        #modal .mask {
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            background-color: #000;
            opacity: 0.5;
        }
        #table_detail{
            z-index: 9999;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教材发放列表
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <%--<span>学院名称：</span>--%>
    <%--<select  ng-model="item.collegeName" name="collegeName" class="forminput" id="collegeName" ng-change="changeCollege(item.collegeName)">--%>
        <%--<option value="" >--请选择--</option>--%>
        <%--<option ng-repeat="college in colleges" value="{{college.wordbookValue}}">{{college.wordbookValue}}</option>--%>
    <%--</select>--%>
    <%--<span style="margin-left: 10px">专业名称：</span>--%>
    <%--<select  ng-model="item.majorName" name="majorName" class="forminput" id="majorName">--%>
        <%--<option value="" >--请选择--</option>--%>
        <%--<option ng-repeat="major in newMajors" value="{{major.majorName}}">{{major.majorName}}</option>--%>
    <%--</select>--%>
    <span style="margin-left: 10px">发放状态：</span>
    <select  ng-model="item.is_giveout" name="is_giveout" class="forminput" id="is_giveout">
        <option  value="">全部</option>
        <option  value="是">已发放</option>
        <option  value="否">未发放</option>
    </select>
    <span style="margin-left: 10px">学期名称：</span>
    <select  ng-model="item.semester" name="semester" class="forminput" id="semester">
        <option value="">--请选择--</option>
        <option ng-repeat="semester in semesters" value="{{semester.semester}}">{{semester.semester}}</option>
    </select>
    <%--<table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" /> 新建</table-btn>--%>
    <%--<table-btn class="top" ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>--%>
    <%--<table-btn class="top" ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>--%>
    <%--<table-btn class="top" ng-click="checkdetail()"><img src="<%=request.getContextPath()%>/images/details.png" />查看详情</table-btn>--%>
    <input class="tablesearchbtn" type="text" placeholder="请输入班级名称进行搜索..." onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="search()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>班级名称</th>
        <th>年级名称</th>
        <%--<th>学院名称</th>--%>
        <th>教材名称</th>
        <th>教材数量</th>
        <th>教材所属学期</th>
        <th>是否发放</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="distributionId" value="{{data.distributionId}}"/>
            </td>
            <td ng-bind="data.className"></td>
            <td ng-bind="data.gradeName"></td>
            <%--<td ng-bind="data.collegeName"></td>--%>
            <td ng-bind="data.name"></td>
            <td ng-bind="data.booktotalnum"></td>
            <td ng-bind="data.semester"></td>
            <td ng-bind="data.is_giveout"></td>
            <td><button style="border: 1px solid #c5add7;height: 26px;color: #5c307d; padding: 0 17px;background: lightgrey;
                        -webkit-transition: all .2s;display: inline-block;vertical-align: middle;line-height: 26px;cursor: default"
                        ng-readonly="true" ng-if="data.is_giveout=='是'">已发放</button>
                <table-btn ng-click="edit(data)" ng-if="data.is_giveout=='否'">已发放</table-btn></td>
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
    var num=0;
    var add_edit = true;//true为新建，false为修改
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载下拉选项
        remotecall("teacher_loadCoMaGrInfo",{},function (data) {
            $scope.colleges=data.college;
            $scope.majors=data.major;
            $scope.newMajors=data.major;
            $scope.grades=data.grade;
            $scope.semesters=data.semester;
        },function (data) {});
        //学院信息
        $scope.search = function () {
            loading();
            remotecall("distribution_loadinfo",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr,is_giveout:$scope.item.is_giveout,semester:$scope.item.semester},function (data) {
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
        };
        //学院下拉选 change事件
        $scope.changeCollege=function (college){
            var newMajors=[];
            for (var i = 0; i < $scope.majors.length; i++) {
                var obj = $scope.majors[i];
                if(obj.majorCollege==college){
                    newMajors.push(obj)
                }
            }
            $scope.newMajors=newMajors;
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

        $scope.close=function () {
            $("#modal").hide();
            $("#table_detail").hide();
        }

        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.list.push(tr);
                if($scope.list.length==$scope.datas.length){
//                    $('#all').attr("checked",true);
                    document.getElementById("all").checked=true;
                }
            }else{
                num--;
                $scope.all = false;
                tr.td0 = false;
                var index = $scope.list.indexOf(tr);
                if (index > -1) {
                    $scope.list.splice(index, 1);
                }
            }
            if(num==$scope.datas.length){
                $scope.all=true;
            }else {
                $scope.all=false;
            }
        };
        //修改
        $scope.edit= function (tr) {
            if(tr.is_giveout==="是"){
                parent.pMsg("已经发放过了！");
                return;
            }
            loading();
            remotecall("distribution_edit",{deleteId:tr.distributionId},function (data) {
                if(data){
                    closeLoading();
                    parent.pMsg("发放成功！");
                    //重新加载菜单
                    $scope.search();
//                    $scope.$apply();
                }else {
                    closeLoading();
                    parent.pMsg("发放失败！");
                }
            },function (data) {
                closeLoading();
                parent.pMsg("发放失败");
                console.log(data);
            });
        };
        //隐藏
        $scope.cancel=function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            },300);
            $('table,.title,.pagingbox').show();
            //清空选中
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
                    $scope.datas[i].td0=false
                }
                num=0;
            }else{
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=true
                }
                num=$scope.datas.length;
            }
        };
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>