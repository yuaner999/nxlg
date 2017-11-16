<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/26
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <style>
        #menuform span{width:150px}
        .text-center span{width:110px!important}
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：空余教室设置
<hr>
<!--导航筛选 此页不需要-->
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" /> 新建</table-btn>
    <table-btn class="top" ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <%--<table-btn class="top" ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>--%>
    <span class="span_width">周时：</span>
    <select type="text" ng-model="searchRoom.teachweek" name="teachweek" class="forminput" id="teachweek"/>
    <option value="" selected="selected">--请选择--</option>
    <option value="1">第01周</option>
    <option value="2">第02周</option>
    <option value="3">第03周</option>
    <option value="4">第04周</option>
    <option value="5">第05周</option>
    <option value="6">第06周</option>
    <option value="7">第07周</option>
    <option value="8">第08周</option>
    <option value="9">第09周</option>
    <option value="10">第10周</option>
    <option value="11">第11周</option>
    <option value="12">第12周</option>
    <option value="13">第13周</option>
    <option value="14">第14周</option>
    <option value="15">第15周</option>
    <option value="16">第16周</option>
    <option value="17">第17周</option>
    <option value="18">第18周</option>
    <option value="19">第19周</option>
    <option value="20">第20周</option>
    </select>

    <span class="span_width">上课日期：</span>
    <select type="text" ng-model="searchRoom.timeweek" name="timeweek" class="forminput" id="timeweek"/>
    <option value="" selected="selected">--请选择--</option>
    <option value="1">星期一</option>
    <option value="2">星期二</option>
    <option value="3">星期三</option>
    <option value="4">星期四</option>
    <option value="5">星期五</option>
    <option value="6">星期六</option>
    <option value="7">星期天</option>
    </select>

    <span class="span_width">节次：</span>
    <select type="text" style="margin-right: 20px;" ng-model="searchRoom.timepitch" name="timepitch" class="forminput" id="timepitch"/>
    <option value="" selected="selected">--请选择--</option>
    <option value="1">第一节</option>
    <option value="2">第二节</option>
    <option value="3">第三节</option>
    <option value="4">第四节</option>
    <option value="5">第五节</option>
    </select>

    <%--<input class="tablesearchbtn" type="text" placeholder="请输入关键字进行搜索" ng-model="week" />--%>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>周次</th>
        <th>日期/星期</th>
        <th>节次</th>
        <th>教室类型</th>
        <th>教室数量</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="scId" value="{{data.scId}}"/>
            </td>
            <td ng-bind="data.week"></td>
            <td ng-bind="data.weekday"></td>
            <td ng-bind="data.classes"></td>
            <td ng-bind="data.classtype"></td>
            <td ng-bind="data.num"></td>
            <td><table-btn ng-click="delete(data)">删除</table-btn></td>
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
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：空余教室设置 > 新增
    <hr>
    <form id="MenuForm">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li style="display: none"><span>空教室Id：</span><input type="text"  ng-model="item.scId" name="scId" class="forminput" id="scId"/></li>
                <li><span>周次：</span><input type="text"  ng-model="item.week" name="week" class="forminput" id="week"/></li>
                <li>
                    <span>日期/星期：</span>
                    <select  ng-model="item.weekday" name="weekday" class="forminput" id="weekday" >
                        <option value="">--请选择--</option>
                        <option value="星期一">星期一</option>
                        <option value="星期二">星期二</option>
                        <option value="星期三">星期三</option>
                        <option value="星期四">星期四</option>
                        <option value="星期五">星期五</option>
                        <option value="星期六">星期六</option>
                        <option value="星期日">星期日</option>
                    </select>
                </li>
                <%--<li><span>节次：</span><input type="text" ng-model="item.classes" name="classes" class="forminput" id="classes"/></li>--%>
                <li>
                    <span class="span_width">节次：</span>
                    <select type="text" ng-model="item.classes" name="classes" class="forminput" id="classes"/>
                    <option value="">--请选择--</option>
                    <option value="1">第一大节</option>
                    <option value="2">第二大节</option>
                    <option value="3">第三大节</option>
                    <option value="4">第四大节</option>
                    <option value="5">第五大节</option>
                    </select>
                </li>
                <%--<li><span>教室类型：</span><input type="text"  ng-model="item.classtype" name="classtype" class="forminput" id="classtype"/></li>--%>
                <li>
                    <span>教室类型：</span>
                    <select  ng-model="item.classtype" name="classtype" class="forminput" id="classtype" >
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options" value="{{option.crt_type}}" ng-bind="option.crt_type"></option>
                    </select>
                </li>
                <li><span>教室数量：</span><input type="text" ng-model="item.num" name="num" class="forminput" id="num"/></li>
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
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.searchRoom={
            teachweek:"",
            timeweek:"",
            timepitch:""
        };
        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.search();
        }
        //加载空教室信息
        $scope.search = function () {
            loading();//加载
            remotecall("spareClassroom_load",{
                pageNum:pageNum,
                pageSize:pageSize,
                searchStr:searchStr,
                teachweek:$scope.searchRoom.teachweek,
                weekday:$scope.searchRoom.timeweek,
                classes:$scope.searchRoom.timepitch
            },function (data) {
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

                $scope.all = false;
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            remotecall("basic_classroom_loadwordbook_classroomtype",'',function (data) {
                $scope.options= data;
                closeLoading();//关闭加载层
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载教室类型失败");
                console.log(data);
            });
            $scope.list=[];
            $scope.item={};
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

        //删除功能
        $scope.delete=function (tr) {
            loading();

            var deleteIds=new Array(tr.scId);
            parent.pConfirm("确认删除该条吗？",function () {
                remotecall("spareClassroom_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        $scope.search();
                        $scope.$apply();
                    }else {
                        closeLoading();//关闭加载层
                        parent.pMsg("删除失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("删除失败");
                    console.log(data);
                });
            },function () {
                closeLoading();//关闭加载层
            });
        };
        //批量删除功能
        $scope.deletes = function () {
            //获取所选择的行
            loading();
            $("#table_detail").hide();
            if($("input[name='scId']:checked").length<1){
                parent.pMsg("请选择一条记录");
                closeLoading();//关闭加载层
                return;
            }
            var deleteIds = $("input[name='scId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有内容吗？",function () {
                remotecall("spareClassroom_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        $scope.search();
                        $scope.$apply();
                    }else {
                        closeLoading();//关闭加载层
                        parent.pMsg("删除失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("删除失败");
                    console.log(data);
                });
            },function () {
                closeLoading();//关闭加载层
            });
        };
        //新建
        $scope.add = function () {
            add_edit=true;
            $("#table_detail").hide();
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
            $("#MenuForm input").value={};
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
                $scope.all = false;
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
        //新建，验证+保存
        $("#MenuForm").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                    var parames = $("#MenuForm").serializeObject();//参数
                    remotecall("spareClassroom_add",parames,function (data) {
                        if(data===2){
                            closeLoading();//关闭加载层
                            parent.pMsg("该周、节次信息已存在");
                        }else if(data){
                            closeLoading();//关闭加载层
                            parent.pMsg("添加成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $('#MenuForm input').text("");
                            $scope.search();
                            $scope.$apply();
                        }else  {
                            closeLoading();//关闭加载层
                            parent.pMsg("教室数量不能小于1");
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
            },
            rules:{
                week:{
                    required:true,
                    digits:true,
                    number:true
                },
                weekday:{
                    required:true,
                    maxlength:6
                },
                classes:{
                    required:true,
                    maxlength:6
                },
                classtype:{
                    required:true,
                    maxlength:6
                },
                num:{
                    required:true,
                    digits:true,
                    number:true
                }
            },
            messages:{
                week:{
                    required:"请输入周次",
                    digits:"请输入正确的周次",
                    number:"请输入正确的周次"
                },
                weekday:{
                    required:"请选择",
                    maxlength:"请选择"
                },
                classes:{
                    required:"请输入节次",
                    maxlength:"请输入节次"
                },
                classtype:{
                    required:"请选择教室类型",
                    maxlength:"请选择教室类型"
                },
                num:{
                    required:"请输入教室数量",
                    digits:"请输入正确的教室数量",
                    number:"请输入正确的教室数量"
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
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
