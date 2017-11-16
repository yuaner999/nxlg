<%--
  Created by IntelliJ IDEA.
  User: gq
  Date: 2017/6/2
  Time: 10:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <%--打印课表的js插件--%>
    <script src="<%=request.getContextPath()%>/js/explore_tabexcle/jquery-migrate-1.2.1.min.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/explore_tabexcle/jquery.jqprint-0.3.js"></script>
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
        #cmbmodal {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            z-index: 2;
        }
        #cmbmodal .cmbmask {
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            background-color: #000;
            opacity: 0;
        }
        #table_detail{
            z-index: 9999;
        }
        /*人造下拉*/
        .listbox{
            position: relative;
            display: inline-block;
        }
        .listbox .after{
            content: '';
            position: absolute;
            right: 3px;
            height: 0;
            top: 11px;
            transform: scaleX(.5);
            -webkit-transform: scaleX(.5);
            -moz-transform: scaleX(.5);
            -ms-transform: scaleX(.5);
            width: 0;
            border: 6px solid transparent;
            border-top-color: rgb(51,51,51);
            cursor: pointer;
            z-index: 33;
        }
        .list{
            position: absolute;
            top:26px;
            left:0;
            width: 100%;
            background: #fff;
            border: 1px solid rgb(30,144,255);

        }
        .list div{
            cursor: pointer;
            padding:0 5px;
        }
        .list div:hover{
            background: rgb(30,144,255);
            color: #fff;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教材预购统计
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <%--<span>学院名称：</span>--%>
    <%--<select  ng-model="item.collegeName" name="collegeName" class="forminput" id="collegeName" ng-change="changeCollege(item.collegeName)">--%>
        <%--<option value="" >--请选择--</option>--%>
        <%--<option ng-repeat="college in colleges" value="{{college.wordbookValue}}">{{college.wordbookValue}}</option>--%>
    <%--</select>--%>
    <%--<span style="margin-left: 10px">专业名称：</span>--%>
    <%--<select  ng-model="item.majorName" name="majorName" class="forminput" id="majorName" ng-change="changeMajor(item.majorName)">--%>
        <%--<option value="" >--请选择--</option>--%>
        <%--<option ng-repeat="major in newMajors" value="{{major.majorName}}">{{major.majorName}}</option>--%>
    <%--</select>--%>
    <span style="margin-left: 10px">班级名称：</span>
    <%--<select  ng-model="item.className" name="className" class="forminput" id="className">--%>
        <%--<option  value="">全部</option>--%>
        <%--<option ng-repeat="class in newclasses" value="{{class.className}}">{{class.className}}</option>--%>
    <%--</select>--%>
    <div class="listbox">
        <input style="width:216px;" type="text" ng-model="fakeValue" class="forminput" ng-click="leaveInput()" ng-keyup="changeoptions(fakeValue)"  placeholder="--全部--"/>
        <div id="cmbDiv" class="list" ng-show="fakeSelect" style="max-height: 600px;overflow: scroll;z-index: 3;">
            <div ng-click="chooseItem(class)" ng-bind="class.className" ng-repeat="class in newClasses"></div>
        </div>
        <div class="after" ng-click="selectAll()"></div>
    </div>
    <table-btn id="search" ng-click="search()">搜索</table-btn>
    <table-btn style="width: 120px;margin-left: 50px;" ng-click="btnExcel()" class="btnExcel">导出预购信息</table-btn>
    <%--<table-btn style="width: 120px;margin-left: 20px;" onclick="exploretable()">打印预购信息</table-btn>--%>
    <form id="exportTo" method="post" hidden></form>
</div>
<!--表格-->
<div class="tablebox" id="usetoprint">
    <table class="table">
        <thead>
        <%--<th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>--%>
        <th>教材名称</th>
        <th>教材数量</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <%--<td class="thischecked" ng-click="thischecked(data)">--%>
                <%--<input id="tchecked" type="checkbox" ng-model="data.td0" name="distributionId" value="{{data.distributionId}}" ng-checked="all"/>--%>
            <%--</td>--%>
            <td class="th-left" ng-bind="data.name"></td>
            <td ng-bind="data.booktotalnum"></td>
        </tr>
        </tbody>
    </table>
</div>
<%--遮罩层--%>
<div id="modal">
    <div class="mask"></div>
</div>
<div id="cmbmodal" ng-show="fakeSelect" ng-click="blurfunction()">
    <div class="cmbmask"></div>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
</body>
</html>
<script>
    var add_edit = true;//true为新建，false为修改
    var fakenum=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载下拉选项
        remotecall("teacher_loadCoMaGrInfo",{},function (data) {
            $scope.colleges=data.college;
            $scope.majors=data.major;
            $scope.newMajors=data.major;
            $scope.grades=data.grade;
            $scope.classes=data.class;
            $scope.newClasses=data.class;
            $scope.semesters=data.semester;
        },function (data) {});

        $scope.search = function () {
            loading();
            remotecall("beforeBuying_load",{pageNum:pageNum,pageSize:pageSize,className:$scope.fakeValue},function (data) {
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
        //专业下拉选 change事件
        $scope.changeMajor=function (major){
            var newClasses=[];
            for (var i = 0; i < $scope.classes.length; i++) {
                var obj = $scope.classes[i];
                if(obj.majorName==major){
                    newClasses.push(obj)
                }
            }
            $scope.newClasses=newClasses;
        };
        //导出Excel
        $scope.btnExcel=function () {
            var url="../../export/exportBeforeBuyingInfo.form?collegeName="+$scope.item.collegeName+"&majorName="+$scope.item.majorName+"&className="+$scope.fakeValue;
            $("#exportTo").attr("action",url);
            $("#exportTo").submit();
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
                tr.td0 = true;
                $scope.list.push(tr);
            }else{
                tr.td0 = false;
                $('#all').attr("checked",false);
                var index = $scope.list.indexOf(tr);
                if (index > -1) {
                    $scope.list.splice(index, 1);
                }
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
                    $scope.$apply();
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
            }else{
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=true
                }
            }
        };
        //人造下拉的逻辑
        $scope.fakeInput=function () {
            this.fakeSelect=true;
        }
        $scope.leaveInput=function () {
            if(fakenum>=2)fakenum=0;
            if(fakenum==0){
                $scope.fakeSelect=true;
            }
            if(fakenum==1){
                $scope.fakeSelect=false;
            }
            fakenum++;
        }
        $scope.blurfunction=function () {
             $scope.fakeSelect=false;
            fakenum++;
        }
        $scope.chooseItem=function (obj) {
            $scope.fakeSelect=false;
            $scope.fakeValue=obj.className;
            fakenum++;
        }
        $scope.changeoptions=function (obj) {
            $scope.fakeSelect=true;
            $scope.newClasses=[];
            if(!$scope.classes || $scope.classes.length==0) $scope.classes=[];
            for (var i = 0; i < $scope.classes.length; i++) {
                var item = $scope.classes[i];
                if(item.className.indexOf(obj) >=0 ){
                    $scope.newClasses.push(item);
                }
            }
        }
        $scope.selectAll=function (){
            $scope.fakeSelect=true;
            $scope.newClasses=$scope.classes;
        }
    });
    function exploretable() {
        $("#usetoprint").jqprint();
    }
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>