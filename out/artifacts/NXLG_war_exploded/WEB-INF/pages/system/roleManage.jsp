<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-14
  Time: 14:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：角色管理
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" />新建</table-btn>
    <table-btn ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <%--<table-btn ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>--%>
    <input  class="tablesearchbtn" type="text"  placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadRole()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>角色名称</th>
        <th>是否系统角色</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="role in roles">
            <td class="thischecked" ng-click="thischecked(role)">
                <input style="cursor: pointer" type="checkbox" ng-model="role.td0" name="roleIdSelect" value="{{role.roleId}}"/><%--ng-checked="all"--%>
            </td>
            <td ng-bind="role.roleName"></td>
            <td ng-bind="role.isSystem"></td>
            <td class="thischecked" ng-click="thischecked(role)" style="display: none">
                <input type="checkbox" ng-model="role.td0" name="isSystemSelect" value="{{role.isSystem}}" ng-checked="all"/>
            </td>
            <td class="thischecked" ng-click="thischecked(role)" style="display: none">
                <input type="checkbox" ng-model="role.td0" name="roleNameSelect" value="{{role.roleName}}" ng-checked="all"/>
            </td>
            <td><table-btn ng-click="edit(role)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="delete(role)">删除</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<!--分页-->
<div class="pagingbox">
    <paging></paging>
</div>
<!--新建表单-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <form id="Form">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li style="display: none;"><span>ID：</span><input type="text" name="roleId" class="forminput" /></li>
                <li><span style="width:120px;text-align: center">角色名称：</span><input type="text" ng-model="checkitem.roleName" name="roleName" class="forminput" id="roleName"/></li>
                <li><span style="width:120px">是否系统角色：</span>
                    <select  ng-model="checkitem.isSystem" name="isSystem" class="forminput" id="isSystem" >
                        <option value="" >--请选择--</option>
                        <option value="是" >是</option>
                        <option value="否" >否</option>
                    </select>
                </li>
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
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载数据
        $scope.loadRole = function () {
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("roleManage_loadRole",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                closeLoading();//关闭加载层
                $scope.roles = data.rows;//加载的数据对象，‘roles’根据不同需求而变
                pageCount = parseInt((data.total-1)/pageSize)+1;//页码总数
                $scope.pC = pageCount;//页码总数
                var pages = [];
                for(var i=1;i<=pageCount;i++){
                    pages.push(i);
                }
                $scope.TotalPageCount=pageCount;
                $scope.TotalDataCount=data.total;
                $scope.pages = pages;//共有多少页，页码内容
                changeSelect();//改变分页选中样式
                $scope.all = false;
                for(i=0;i<$scope.roles.length;i++){
                    $scope.roles[i].td0=false;
                }
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
                    closeLoading();//关闭加载层
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            $scope.checklist=[];
            $scope.checkitem={};
        };
        //分页加载跳转到指定页
        $scope.gotoPage = function (pn) {
            if(pn==-1){//上一页
                pn = pageNum-1;
            }
            if(pn==-2){//下一页
                pn = pageNum+1;
            }
            if(pn==-3){
                pn =pageCount;
            }
            if(pn<1||pn>pageCount||pn==pageNum){//页码不正确
                return;
            }else {
                pageNum = pn;//改变当前页
                //重新加载
                $scope.loadRole();
            }
        };
        //删除功能
        $scope.delete=function (tr) {
            loading();
            var deleteIds=new Array(tr.roleId);
            parent.pConfirm("确认删除该角色吗？",function () {
                //判断需要删除管理员是否存在系统角色
                if($scope.checklist[0].isSystem!= '是'){
                    remotecall("roleManage_deleteRole", {deleteIds: deleteIds}, function (data) {
                        if (data) {
                            parent.pMsg("删除成功");
                            //重新加载角色
                            closeLoading();//关闭加载层
                            $scope.loadRole();
                            $scope.$apply();
                        } else {
                            parent.pMsg("删除失败，存在用户属于该角色");
                            closeLoading();//关闭加载层
                        }
                    }, function (data) {
                        parent.pMsg("删除失败,数据库加载失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                }else{
                    closeLoading();//关闭加载层
                    parent.pMsg("删除失败，系统角色不能删除");
                }
            },function () {
                closeLoading();//关闭加载层
            });
        };
        //批量删除功能
        $scope.deletes = function () {
            loading();
            //获取所选择的行
            var isdelete=true;
            if($("input[name='roleIdSelect']:checked").length<1){
                closeLoading();//关闭加载层
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='roleIdSelect']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            var editIds = $("input[name='isSystemSelect']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的管理员属性
            parent.pConfirm("确认删除选中的所有角色吗？",function () {
                for(var i=0;i<editIds.length;i++)//判断需要删除管理员是否存在系统角色
                {
                    var editId=editIds[i];
                    if(editId=='是')
                    {
                        isdelete=false;
                    }
                }
                if(isdelete){
                    remotecall("roleManage_deleteRole", {deleteIds: deleteIds}, function (data) {
                        if (data) {
                            parent.pMsg("删除成功");
                            //重新加载角色
                            closeLoading();//关闭加载层
                            $scope.loadRole();
                            $scope.$apply();
                        } else {
                            parent.pMsg("删除失败，存在用户属于该角色");
                            closeLoading();//关闭加载层
                        }
                    }, function (data) {
                        parent.pMsg("删除失败,数据库加载失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                }else{
                    closeLoading();//关闭加载层
                    parent.pMsg("删除失败，选项中有系统角色");
                }
            },function () {
                closeLoading();//关闭加载层
            });
        };
        //新建
        $scope.add = function () {
            add_edit=true;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
            $("#Form input").value="";
        };
        //修改
        $scope.edit= function (tr) {
            add_edit = false;
            $scope.checkitem = {};
            $('#all').attr("checked", false);
            $scope.allfn();
            tr.td0 = true;
            $scope.checklist.splice(0, 1, tr);
            var editId =$scope.checklist[0].isSystem;
            if (editId == '是'){
                parent.pMsg("系统角色不允许修改");
                return;
            }
            $scope.checkitem = $scope.checklist[0];
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-addform').show();
            $('table,.title,.pagingbox').hide();
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
            $scope.checklist=[];
            $scope.checkitem={};
            $scope.all = false;
            for(i=0;i<$scope.roles.length;i++){
                $scope.roles[i].td0=false;
            }
        };
        //首次加载角色
        $scope.loadRole();
        //checked 复选框判断
        $scope.all = false;
        $scope.checklist=[];
        $scope.checkitem={};
        $scope.allfn = function  () {
            if($scope.all == false){
                for(i=0;i<$scope.roles.length;i++){
                    $scope.roles[i].td0=false
                }
                num=0;
            }else{
                for(i=0;i<$scope.roles.length;i++){
                    $scope.roles[i].td0=true
                }
                num=$scope.roles.length;
            }
        };
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.checklist.push(tr);
            }else{
                num--;
                tr.td0 = false;
                $scope.all = false;
                var index = $scope.checklist.indexOf(tr);
                if (index > -1) {
                    $scope.checklist.splice(index, 1);
                }
            }
            if(num==$scope.roles.length){
                $scope.all=true;
            }else {
                $scope.all=false;
            }
        };
        //表单验证
        $("#Form").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                if(add_edit){//如果是添加
                    var parames = $("#Form").serializeObject();//参数
                    remotecallasync("roleName_unique", parames, function (data) {//判断角色是否已存在
                        if (data.length == '0') {
                            remotecallasync("roleManage_addRole", parames, function (data){
                                if (data != false) {
                                    parent.pMsg("添加角色成功");
                                    closeLoading();//关闭加载层
                                    //重新加载角色
                                    $('.table-addform').hide();
                                    $('table,.title,.pagingbox').show();
                                    $('#UserForm input').text("");
                                    $scope.loadRole();
                                    $scope.$apply();
                                    $scope.checklist = [];
                                    $scope.checkitem = {};
                                } else {
                                    parent.pMsg("添加角色失败");
                                    closeLoading();//关闭加载层
                                }
                            }, function (data) {
                                parent.pMsg("数据库请求失败");
                                closeLoading();//关闭加载层
                                console.log(data);
                            });
                        } else {
                            parent.pMsg("角色已存在");
                            closeLoading();//关闭加载层
                        }
                    }, function (data) {
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                }else{//修改
                    var parames = $("#Form").serializeObject();//参数
                    var roleId = $("input[name='roleIdSelect']:checked").map(function(index,elem) {
                        return $(elem).val();
                    }).get();//根据Id判断 修改角色时只允许修改本角色Id和数据库中不存在的用户名角色
                    remotecallasync("roleName_unique", parames, function (data) {//判断角色是否已存在
                        if (data.length == '0'||data[0].roleId == roleId[0]) {
                            parames.roleId=roleId[0];
                            remotecallasync("roleManage_editRole", parames, function (data) {
                                if(data){
                                    closeLoading();//关闭加载层
                                    parent.pMsg("修改角色成功");
                                    //重新加载角色
                                    $('.table-addform').hide();
                                    $('table,.title,.pagingbox').show();
                                    $scope.loadRole();
                                    $scope.$apply();
                                    $scope.checklist=[];
                                    $scope.checkitem={};
                                } else {
                                    parent.pMsg("数据库请求失败");
                                    closeLoading();//关闭加载层
                                }
                            }, function (data) {
                                parent.pMsg("数据库请求失败");
                                closeLoading();//关闭加载层
                                console.log(data);
                            });
                        } else {
                            parent.pMsg("修改失败,角色已存在");
                            closeLoading();//关闭加载层
                        }
                    }, function (data) {
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
                }
            },
            rules:{
                roleName:{
                    required:true,
                    maxlength:25
                },
                isSystem:{
                    required:true,
                    maxlength:1
                }
            },
            messages:{
                roleName:{
                    required:"请输入角色名",
                    maxlength:"长度不超过25个字符"
                },
                isSystem:{
                    required:"请选择是否为系统管理员",
                    maxlength:"请选择"
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