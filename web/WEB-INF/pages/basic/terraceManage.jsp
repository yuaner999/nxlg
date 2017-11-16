<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/18
  Time: 13:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <script src="<%=request.getContextPath()%>/js/font/jedate/jquery.jedate.min.js" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/js/font/jedate/skin/jedate.css" />
    <style>
        #menuform span{width:180px}
        .text-center span{width:110px!important}
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：平台管理
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" /> 新建</table-btn>
    <table-btn class="top" ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <%--<table-btn class="top" ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>--%>
    <input class="tablesearchbtn" type="text" placeholder="请输入平台名称进行搜索" onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>平台名称</th>
        <%--<th>最少选修学分/学期</th>--%>
        <%--<th>最少选修课程门数/学期</th>--%>
        <%--<th>最多选修学分/学期</th>--%>
        <%--<th>最多选修课程门数/学期</th>--%>
        <%--<th>平台开放起始时间</th>--%>
        <%--<th>平台开放结束时间</th>--%>
        <th style="width: 194px"></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="terraceId" value="{{data.terraceId}}"/>
            </td>
            <td ng-bind="data.terraceName"></td>
            <%--<td ng-bind="data.minCredits"></td>--%>
            <%--<td ng-bind="data.minClasses"></td>--%>
            <%--<td ng-bind="data.maxCredits"></td>--%>
            <%--<td ng-bind="data.maxClasses"></td>--%>
            <%--<td ng-bind="data.startTime"></td>--%>
            <%--<td ng-bind="data.endTime"></td>--%>
            <td><table-btn ng-click="edit(data)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="delete(data)">删除</table-btn></td>
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
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：平台管理 > 新增/修改
    <hr>
    <form id="MenuForm">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li style="display: none"><span>平台Id：</span><input type="text"  ng-model="terraceitem.terraceId" name="terraceId" class="forminput" id="terraceId"/></li>
                <li><span>平台名称：</span><input type="text"  ng-model="terraceitem.terraceName" name="terraceName" class="forminput" id="terraceName"/></li>
                <%--<li><span>每学期最少选修学分：</span><input type="text" ng-model="terraceitem.minCredits" name="minCredits" class="forminput" id="minCredits"/></li>--%>
                <%--<li><span>每学期最少选修课程门数：</span><input type="text"  ng-model="terraceitem.minClasses" name="minClasses" class="forminput" id="minClasses"/></li>--%>
                <%--<li><span>每学期最多选修学分：</span><input type="text" ng-model="terraceitem.maxCredits" name="maxCredits" class="forminput" id="maxCredits"/></li>--%>
                <%--<li><span>每学期最多选修课程门数：</span><input type="text"  ng-model="terraceitem.maxClasses" name="maxClasses" class="forminput" id="maxClasses"/></li>--%>
                <%--<li><span>平台开放起始时间：</span><input type="text" ng-model="terraceitem.startTime" name="startTime" class="forminput" id="startTime"/></li>--%>
                <%--<li><span>平台开放结束时间：</span><input type="text" ng-model="terraceitem.endTime" name="endTime" class="forminput" id="endTime"/></li>--%>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
</body>
</html>
<script>
    var add_edit = true;//true为新建，false为修改
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.search();
        }

        //加载平台数据
        $scope.datas=[];
        $scope.search = function () {
            loading();//加载
            remotecall("terraceManage_pageload",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
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
                $scope.allfn();
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            $scope.terracelist=[];
            $scope.terraceitem={};
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
        $scope.terracelist=[];
        $scope.terraceitem={};
        //首次加载菜单
        //先定义，后使用，否则出错误！！！
        $scope.search();
        //删除功能
        $scope.delete=function (tr) {
            loading;

            var deleteIds=new Array(tr.terraceId);
            parent.pConfirm("确认删除该条数据吗？",function () {
                remotecall("terraceManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        closeLoading();
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        $scope.search();
                        $scope.$apply();
                    }else {
                        closeLoading();
                        parent.pMsg("删除失败");
                    }
                },function (data) {
                    closeLoading();
                    parent.pMsg("删除失败");
                    console.log(data);
                });
            },function () {
                closeLoading();
            });
        };
        //批量删除功能
        $scope.deletes = function () {
            loading();
            //获取所选择的行
            if($("input[name='terraceId']:checked").length<1){
                closeLoading();
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='terraceId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有内容吗？",function () {
                remotecall("terraceManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        closeLoading();
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        $scope.search();
                        $scope.$apply();
                    }else {
                        closeLoading();
                        parent.pMsg("删除失败");
                    }
                },function (data) {
                    closeLoading();
                    parent.pMsg("删除失败:加载数据库失败");
                    console.log(data);
                });
            },function () {
                closeLoading();
            });
        };
        //新建
        $scope.add = function () {
            add_edit=true;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
            $("#MenuForm input").value={};
            $("#startTime").val("");
            $("#endTime").val("");
        };
        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.terracelist.push(tr);
            }else{
                num--;
                tr.td0 = false;
                $scope.all = false;
                var index = $scope.terracelist.indexOf(tr);
                if (index > -1) {
                    $scope.terracelist.splice(index, 1);
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
            add_edit=false;

            $scope.terraceitem=tr;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();

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
            $scope.search();
            $scope.terracelist=[];
            $scope.terraceitem={};
            $scope.all = false;
            $scope.allfn();
        };
        //新建和修改，验证+保存
        $("#MenuForm").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                if(add_edit){
                    var parames = $("#MenuForm").serializeObject();//参数
//                    if(parames.minCredits>parames.maxCredits){
//                        parent.pMsg("每学期最少选修学分不能大于最多选修学分");
//                        closeLoading();
//                        return;
//                    }
//                    if(parames.minClasses>parames.maxClasses){
//                        parent.pMsg("每学期最少选修课程门数不能大于最多选修课程门数");
//                        closeLoading();
//                        return;
//                    }
                    remotecall("terraceManage_add",parames,function (data) {
                        if(data.result){
                            closeLoading();
                            parent.pMsg("添加成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $('#MenuForm input').text("");
                            $scope.search();
                            $scope.$apply();
                        }else {
                            closeLoading();
                            parent.pMsg(data.errormessagge);
                        }
                    },function (data) {
                        closeLoading();
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }else{
                    var parames = $("#MenuForm").serializeObject();//参数
//                    if(parames.endTime<=parames.startTime){
//                        closeLoading();
//                        parent.pMsg("平台开放结束时间必须大于平台开放起始时间");
//                        return;
//                    }
                    remotecallasync("terraceManage_edit",parames,function (data) {
                        if(data.result){
                            closeLoading();
                            parent.pMsg("修改成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $scope.search();
                            $scope.$apply();
                        }else {
                            closeLoading();
                            parent.pMsg(data.errormessagge);
                        }
                    },function (data) {
                        closeLoading();
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }
            },
            rules:{
                terraceName:{
                    required:true
                },
//                minCredits:{
//                    required:true
//                },
//                minClasses:{
//                    required:true
//                },
//                maxCredits:{
//                    required:true
//                },
//                maxClasses:{
//                    required:true
//                },
//                startTime:{
//                    required:true
//                },
//                endTime:{
//                    required:true
//                }
            },
            messages:{
                terraceName:{
                    required:"请输入平台名称"
                },
//                minCredits:{
//                    required:"请输入每学期最少选修学分"
//                },
//                minClasses:{
//                    required:"请输入最少选修课程门数"
//                },
//                maxCredits:{
//                    required:"请输入最多选修学分"
//                },
//                maxClasses:{
//                    required:"请输入最多选修课程门数"
//                },
//                startTime:{
//                    required:"请输入平台开放起始时间"
//                },
//                endTime:{
//                    required:"请输入平台开放结束时间"
//                }
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
        //排序
        $scope.orderType='wordbookKey';
        $scope.order='-';
        $scope.sorting=function(type){
            $scope.orderType=type;
            if($scope.order===''){
                $scope.order='-';
                $scope.search();
            }else{
                $scope.order='';
                $scope.search();
            }
        }
    });

    //日历
    var start = {
        format: 'YYYY-MM-DD hh:mm:ss',
        minDate: $.nowDate(0), //设定最小日期为当前日期
        isinitVal:true,
        festival:false,
        ishmsVal:false,
        maxDate: '2099-06-30 23:59:59', //最大日期
        choosefun: function(elem,datas){
            end.minDate = datas; //开始日选好后，重置结束日的最小日期
        }
    };
    var end = {
        format: 'YYYY-MM-DD hh:mm:ss',
        minDate: $.nowDate(0), //设定最小日期为当前日期
        festival:false,
        maxDate: '2099-06-16 23:59:59', //最大日期
        choosefun: function(elem,datas){
            start.maxDate = datas; //将结束日的初始值设定为开始日的最大日期
        }
    };
    //    $('#startTime').jeDate(start);
    //    $('#endTime').jeDate(end);
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>