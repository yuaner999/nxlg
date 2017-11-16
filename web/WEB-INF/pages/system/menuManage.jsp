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
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：菜单管理
<hr>
    <div class="title">
        <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" />新建</table-btn>
        <table-btn class="top" ng-click="delete()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    </div>
    <!--表格-->
    <div class="tablebox">
        <table class="table">
            <thead>
                <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
                <th><button ng-click="sorting('menuName')">名称<b></b></button></th>
                <th>父菜单</th>
                <th><button ng-click="sorting('menuSort')">顺序 <b></b></button></th>
                <th>URL</th>
                <th></th>
            </thead>
            <tbody>
            <tr ng-repeat="menu in menus">
                <td class="thischecked" ng-click="thischecked(menu)">
                    <input type="checkbox" ng-model="menu.td0" name="menuIdSelect" value="{{menu.menuId}}"/>
                </td>
                <td  class="th-left"><img src="<%=request.getContextPath()%>/images/details.png" style="cursor: pointer" ng-click="thischecked(menu);edit()"/>
                    {{menu.menuName}}
                </td>
                <td ng-bind="menu.menuParentName"></td>
                <td ng-bind="menu.menuSort"></td>
                <td ng-bind="menu.menuUrl" class="th-left"></td>
                <td><table-btn ng-click="edit(menu)">修改</table-btn><b style="margin-right: 10px"></b><table-btn ng-click="del(menu)">删除</table-btn></td>
            </tr>
            </tbody>
        </table>
    </div>
    <!--分页 此页不需要-->
    <div class="pagingbox">
        <paging></paging>
    </div>
    <!--新建表单-->
    <!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
    <div class="table-addform container-fluid a-show">
        <form id="MenuForm">
            <div class="row">
                <ul class="col-sm-3 col-xs-3">
                    <li style="display: none;"><span>ID：</span><input type="text" name="menuId" class="forminput" /></li>
                    <li><span>名称：</span><input type="text" ng-model="checkitem.menuName" name="menuName" class="forminput" id="menuName"/></li>
                    <li>
                        <span>父菜单：</span>
                        <select  ng-model="checkitem.menuParent" name="menuParent" class="forminput" id="menuParent" >
                            <option value="">无</option>
                            <option ng-repeat="option in options" value="{{option.menuId}}" ng-bind="option.menuName"></option>
                        </select>
                    </li>
                    <li><span>顺序：</span><input type="text"  ng-model="checkitem.menuSort" name="menuSort" class="forminput" id="menuSort"/></li>
                    <li><span>URL：</span><input type="text" ng-model="checkitem.menuUrl" name="menuUrl" class="forminput" id="menuUrl"/></li>
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
        //加载菜单
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
                //重新加载菜单
                $scope.loadData();
            }
        };
        //批量删除功能
        $scope.delete = function () {
            //获取所选择的行
            if($("input[name='menuIdSelect']:checked").length<1){
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='menuIdSelect']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有菜单吗？",function () {
                loading();
                remotecall("menuManage_deleteMenu",{deleteIds:deleteIds},function (data) {
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("批量删除成功");
                        //重新加载菜单
                        $scope.loadData();
                        $scope.$apply();
                    }else {
                        closeLoading();//关闭加载层
                        parent.pMsg("批量删除失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("批量删除失败");
                    console.log(data);
                });
            },function () {});
        };
        //删除一个
        $scope.del = function (tr){
            $scope.checklist.push(tr);
            $scope.checkitem=$scope.checklist[0];
            parent.pConfirm("确认删除选中的菜单吗？",function () {
                loading();
                remotecall("menuManage_delMenu",$scope.checkitem,function (data) {
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        $scope.loadData();
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
            },function () {});
        }
        //新建
        $scope.add = function () {
            add_edit=true;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
            $("#MenuForm input").value="";
        };
        //修改
        $scope.edit= function (tr) {
            add_edit=false;
            $scope.checklist.push(tr);
            $scope.checkitem=$scope.checklist[0];
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
            $scope.loadData();
            //清空选中
            $scope.checklist=[];
            $scope.checkitem={};
            $scope.all = false;
            for(i=0;i<$scope.menus.length;i++){
                $scope.menus[i].td0=false;
            }
            $scope.all=false;
            num=0;
        };
        //首次加载菜单
        $scope.loadData();
        //checked 复选框判断
        $scope.all = false;
        $scope.checklist=[];
        $scope.checkitem={};
        //全选
        $scope.allfn = function  () {
            if($scope.all == false){
                for(i=0;i<$scope.menus.length;i++){
                    $scope.menus[i].td0=false
                }
                num=0;
            }else{
                for(i=0;i<$scope.menus.length;i++){
                    $scope.menus[i].td0=true
                }
                num=$scope.menus.length;
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
            if(num==$scope.menus.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        //新建和修改，验证+保存
        $("#MenuForm").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                if(add_edit){//新建
                   var parames = $("#MenuForm").serializeObject();//参数
                    remotecall("menuManage_addMenu",parames,function (data) {
                        if(data){
                            closeLoading();//关闭加载层
                            parent.pMsg("添加成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $('#MenuForm input').text("");
                            $scope.loadData();
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
                    remotecallasync("menuManage_editMenu",$scope.checkitem,function (data) {
                        if(data){
                            closeLoading();//关闭加载层
                            parent.pMsg("修改成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $scope.loadData();
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
        //排序
        $scope.sorting = function (key) {
            ordervalue++;
            orderkey= key;
            $scope.loadData();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>