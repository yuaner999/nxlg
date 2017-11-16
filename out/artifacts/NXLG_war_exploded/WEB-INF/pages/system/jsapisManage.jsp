<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-06
  Time: 15:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
</head>
<style>
    .tablebox{

    }
    .jsapis{
        display: none;
    }
    .forminput{
        width: 300px;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：接口管理
<hr>

<!--表格-->
<div class="tablebox a-show a-hide">
    <table class="table">
        <thead>
        <%--<th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>--%>
        <th><button ng-click="sorting('menuName')">名称<b></b></button></th>
        <th>父菜单</th>
        <th><button ng-click="sorting('menuSort')">顺序 <b></b></button></th>
        <th>URL</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="menu in menus">
            <%--<td class="thischecked" ng-click="thischecked(menu)">
                <input type="checkbox" ng-model="menu.td0" name="menuIdSelect" value="{{menu.menuId}}"/>
            </td>--%>
            <td ng-bind="menu.menuName"><%--<img src="<%=request.getContextPath()%>/images/details.png" style="cursor: pointer" ng-click="thischecked(menu);edit()"/>--%></td>
            <td ng-bind="menu.menuParentName"></td>
            <td ng-bind="menu.menuSort"></td>
            <td ng-bind="menu.menuUrl" class="th-left"></td>
            <td><table-btn ng-click="loadJsapis(menu)">查看接口</table-btn></td>
        </tr>
        </tbody>
    </table>
    <!--分页 此页不需要-->
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>

<%--接口列表--%>
<div class="jsapis a-show a-hide">
    <div class="title">
        <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" />新建</table-btn>
        <table-btn class="top" ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
        <table-btn class="top" ng-click="goback()">返回</table-btn>
    </div>
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>菜单名称<b></b></th>
        <th>URL</th>
        <th>接口地址</th>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="jsapi in jsapis">
            <td class="thischecked" ng-click="thischecked(jsapi)">
                <input type="checkbox" ng-model="jsapi.td0" name="jsapiIdSelect" value="{{jsapi.mj_id}}"/>
            </td>
            <td ng-bind="jsapi.menuName"></td>
            <td ng-bind="jsapi.menuUrl"></td>
            <td ng-bind="jsapi.jsapis_name"></td>
            <td><table-btn ng-click="edit(jsapi)">修改接口</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>

<%--新建信息--%>
<div class="table-addform container-fluid a-show a-hide">
    <form id="jsapisForm">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li style="display: none;"><span>菜单_接口id：</span><input type="text" ng-model="jsapi.mj_id" name="mj_id" class="forminput" id="mj_id" /></li>
                <li style="display: none;"><span>菜单id：</span><input type="text" ng-model="meunNow.menuId" name="menuId" class="forminput" id="menuId" /></li>
                <li><span>菜单名称：</span><span type="text" ng-bind="meunNow.menuName" name="menuName" class="forminput" id="menuName"></span></li>
                <li><span>菜单URL：</span><span type="text" ng-bind="meunNow.menuUrl" name="menuUrl" class="forminput" id="menuUrl"></span></li>
                <li><span>接口地址：</span><input type="text" ng-model="jsapi.jsapis_name" name="jsapis_name" class="forminput" id="jsapis_name"/></li>
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
var add_edit=true;
var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
    var num=0;//checked数量
    var ordervalue = 0;
    var orderkey = 'menuSort';
    $scope.meunNow;
    $scope.loadData = function () {
        var value='';
        if(ordervalue%2==0){
            value='0';//正序
        }else{
            value='1';
        }
        loading();//加载层
        //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
        remotecall("menuManage_loadMenu",{orderkey:orderkey,ordervalue:value,pageNum:pageNum,pageSize:pageSize},function (data) {
            $scope.menus = data.rows;//加载的数据对象，‘menus’根据不同需求而变
            pageCount = parseInt((data.total-1)/pageSize)+1;//页码总数
            $scope.pC = pageCount;//页码总数
            var pages = [];
            for(var i=1;i<=pageCount;i++){
                pages.push(i);
            }
            $scope.pages = pages;//共有多少页，页码内容
            changeSelect();//改变分页选中样式
            $scope.all = false;
            for(i=0;i<$scope.menus.length;i++){
                $scope.menus[i].td0=false;
            }
            $scope.all=false;
            num=0;
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
            if(data.total==0){
                parent.pMsg("暂无数据");
            }

        },function (data) {
            parent.pMsg("加载数据失败");
            console.log(data);
        });
        //加载父菜单
        remotecall("menuManage_loadParentMenu",'',function (data) {
            $scope.options = data;
            closeLoading();//关闭加载层
        },function (data) {
            closeLoading();//关闭加载层
            parent.pMsg("加载父菜单失败");
            console.log(data);
        });
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
            //重新加载
            $scope.loadData();
        }
    };

    //加载接口列表
    $scope.loadJsapis = function (tr) {
        if (tr == 0){
            tr = $scope.meunNow;
        }else {
            $scope.meunNow = tr;
        }
        remotecall("jsapisManage_load",{menuId:tr.menuId},function (data) {
            if(data[0].jsapis_name == null){
                parent.pMsg("该菜单暂无调用接口");
            }else {
                $('.tablebox').hide();
                $('.jsapis').show();
                $scope.jsapis = data;
                $scope.checklist=[];
            }
        },function (data) {
            parent.pMsg("加载数据失败");
            console.log(data);
        });
    };

    //返回菜单列表
    $scope.goback = function () {
        $('.tablebox').show();
        $('.jsapis').hide();
    };

    //全选
    $scope.allfn = function  () {
        if($scope.all == false){
            for(i=0;i<$scope.jsapis.length;i++){
                $scope.jsapis[i].td0=false
            }
            num=0;
        }else{
            for(i=0;i<$scope.jsapis.length;i++){
                $scope.jsapis[i].td0=true
            }
            num=$scope.jsapis.length;
        }
    };
    //check事件
    $scope.thischecked = function  (tr) {
        if(tr.td0 == false||tr.td0 == null){
            num++;
            tr.td0 = true;
            $scope.checklist.push(tr);
        }else{
            num--;
            tr.td0 = false;
            $scope.all=false;
            var index = $scope.checklist.indexOf(tr);
            if (index > -1) {
                $scope.checklist.splice(index, 1);
            }
        }
        if(num==$scope.jsapis.length){
            $scope.all=true;
        }else{
            $scope.all=false;
        }
    };

    //批量删除
    $scope.deletes = function () {
        loading();
        //获取所选择的行
        if($("input[name='jsapiIdSelect']:checked").length < 1){
            closeLoading();
            parent.pMsg("请选择一条数据");
            return;
        }
        var deleteIds = $("input[name='jsapiIdSelect']:checked").map(function (index,elem) {
            return $(elem).val();
        }).get();//需要删除的id
        closeLoading();
        parent.pConfirm("确认删除所选中的接口吗？",function () {
            remotecall("jsapisManage_deletes",{deleteIds:deleteIds},function (data) {
                if (data){
                    parent.pMsg("删除成功");
                    $scope.loadJsapis(0);
                    $scope.$apply();
                }else {
                    parent.pMsg("删除失败");
                    console.log(data);
                }
            });
        });
    };

    //新建
    $scope.add = function () {
        $('.jsapis').hide();
        $('.table-addform').show();
        add_edit = true;
    };

    //修改
    $scope.edit = function (tr) {
        $('.jsapis').hide();
        $('.table-addform').show();
        add_edit = false;
        $scope.jsapi = tr;
    };

    //取消按钮
    $scope.cancel = function () {
        $('.jsapis').show();
        $('.table-addform').hide();
        $scope.loadJsapis(0);
        $scope.jsapi = {};
    };

    //排序
    $scope.sorting = function (key) {
        ordervalue++;
        orderkey= key;
        $scope.loadData();
    };

    //新建和修改，验证+保存
    $("#jsapisForm").validate({
        submitHandler:function(form){
            loading();
            //验证通过,然后就保存
            var parames = $("#jsapisForm").serializeObject();//参数
            if(add_edit){//新建
                remotecall("jsapisManage_addJsapi",parames,function (data) {
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("添加成功");
                        //重新加载菜单
                        $('.table-addform').hide();
                        $('.jsapis').show();
                        $('#jsapisForm input').text("");
                        $scope.loadJsapis(0);
                        $scope.$apply();
                        $scope.checklist=[];
                        $scope.checkitem={};
                    }else {
                        closeLoading();//关闭加载层
                        parent.pMsg("添加失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("数据库请求失败");
                    console.log(data);
                });
            }else{//修改
                remotecallasync("jsapisManage_editJsapi",parames,function (data) {
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("修改成功");
                        //重新加载菜单
                        $('.table-addform').hide();
                        $('.jsapis').show();
                        $('#jsapisForm input').text("");
                        $scope.loadJsapis(0);
                        $scope.$apply();
                        $scope.checklist=[];
                        $scope.checkitem={};
                    }else {
                        closeLoading();//关闭加载层
                        parent.pMsg("修改失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("数据库请求失败");
                    console.log(data);
                });
            }
        },
        rules:{
            menuName:{
                required:true,
                maxlength:45
            },
            menuSort:{
                required:true,
                digits:true,
                maxlength:11
            },
            menuUrl:{

                maxlength:100
            }
        },
        messages:{
            menuName:{
                required:"请输入菜单名",
                maxlength:"长度不超过45个字符"
            },
            menuSort:{
                required:"请输入菜单URL",
                digits:"输入值必须为整数",
                maxlength:"长度不超过11个字符"
            },
            menuUrl:{
                maxlength:"长度不超过100个字符"
            }
        },
        //重写showErrors
        showErrors: function (errorMap, errorList) {
            var msg = "";
            $.each(errorList, function (i, v) {
                layer.tips(v.message, v.element, { time: 2000 });
                return false;
            });
        },
        /* 失去焦点时不验证 */
        onfocusout: false
    });

    //初始化
    $scope.loadData();
});
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>