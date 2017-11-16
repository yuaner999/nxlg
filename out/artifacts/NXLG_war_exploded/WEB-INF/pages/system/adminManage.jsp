<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/3/17
  Time: 14:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：管理员管理
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" /> 新建</table-btn>
    <table-btn class="top" ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <%--<table-btn class="top" ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>--%>
    <input class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="search()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>姓名</th>
        <th>电话</th>
        <th>邮箱</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas|orderBy:order+orderType">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="adminId" value="{{data.adminId}}"/>
            </td>
            <td ng-bind="data.adminName"></td>
            <td ng-bind="data.adminPhone"></td>
            <td ng-bind="data.adminEmail"></td>
            <td><table-btn ng-click="edit(data)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="delete(data)">删除</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
<!--新建管理员-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <form id="Form">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li><span>用户名：</span><input type="text" ng-model="adminitem.userName" name="userName" class="forminput" id="userName" placeholder="用户登录时使用"></li>
                <li><span>姓名：</span><input type="text"  ng-model="adminitem.adminName" name="adminName" class="forminput" id="adminName"/></li>
                <%--<li><span>头像：</span>--%>
                    <%--<img src="<%=request.getContextPath()%>/images/upload.jpg" ng-click="uploadIcon('#PreView')" style="width: 20px;height: 20px; cursor: pointer"/>--%>
                    <%--<input type="text" class="forminput" style="border: 0px; cursor:pointer;width:68px" value="上传头像" readonly="readonly" ng-click="uploadIcon('#PreView')"/><span style="color:red;font-size:smaller;display: inline-table;line-height:28px">建议图片300*410</span>--%>
                <%--</li>--%>
                <li><span>电话：</span><input type="text"  ng-model="adminitem.adminPhone" name="adminPhone" class="forminput" id="adminPhone"/></li>
                <li><span>邮箱：</span><input type="text" ng-model="adminitem.adminEmail" name="adminEmail" class="forminput" id="adminEmail"/></li>
            </ul>
            <%--<ul class="col-sm-3 col-xs-3">--%>

                <%--&lt;%&ndash;<img src="<%=request.getContextPath()%>/upload/images/"  id="PreView" style="margin-top:10px; width: 120px;height: 170px;"  name="adminIcon" id="adminIcon">&ndash;%&gt;--%>
                    <%--<img src="<%=request.getContextPath()%>/images/icon_error.png"  id="PreView" style="margin-top:10px; width: 120px;height: 166px;"  name="adminIcon" id="adminIcon">--%>
            <%--</ul>--%>
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
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        var img_id;//获取图片Id
        var img_ischange;
        var num=0;
        //加载、查询管理员信息
        $scope.loadAdmin = function () {
            loading();//加载
            remotecall("adminManage_loadAdmin", {
                pageNum: pageNum,
                pageSize: pageSize,
                searchStr: searchStr
            }, function (data) {
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
                $scope.TotalPageCount=pageCount;
                $scope.TotalDataCount=data.total;
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
            if(pn==-3){
                pn =pageCount;
            }
            if(pn<1||pn>pageCount||pn==pageNum){//页码不正确
                return;
            }else {
                pageNum = pn;//改变当前页
                //重新加载管理员信息
                $scope.loadAdmin();
            }
        };
        //checked 复选框判断
        $scope.all = false;
        $scope.adminlist=[];
        $scope.adminitem={};
        //首次加载管理员信息
        //先定义，后使用，否则出错误！！！
        $scope.loadAdmin();
        //删除功能
        $scope.delete=function (tr) {
            loading();

            var deleteIds=new Array(tr.adminId);
            parent.pConfirm("确认删除该条数据吗？",function () {
                remotecall("adminManage_delete",{deleteIds:deleteIds},function (data) {
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
            if($("input[name='adminId']:checked").length<1){
                closeLoading();
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='adminId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有内容吗？",function () {
                remotecall("adminManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        closeLoading();
                        parent.pMsg("删除成功");
                        //重新加载管理员信息
                        $scope.loadAdmin();
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
        //新建
        $scope.add = function () {
            add_edit=true;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
            $("#Form input").value="";
            $("#PreView").attr("src",'<%=request.getContextPath()%>/images/icon_error.png');//新建时加载默认图片
        };
        //搜索
        $scope.search = function () {
            pageNum = 1;
            $scope.loadAdmin();
        }
        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.adminlist.push(tr);
            }else{
                num--;
                tr.td0 = false;
                $scope.all = false;
                var index = $scope.adminlist.indexOf(tr);
                if (index > -1) {
                    $scope.adminlist.splice(index, 1);
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
            loading();

            var user_name;
            var adminId = tr.adminId;
            remotecallasync("admin_loadimg", {adminId:adminId}, function (data) {//修改时加载用户图片
                closeLoading();
                if (data.length!='0') {
                    user_name=data[0].userName;
                    img_ischange=data[0].adminIcon;
                    $("#PreView").attr("src",serverimg(data[0].adminIcon));
                }
                else{
                    $("#PreView").attr("src",'<%=request.getContextPath()%>/images/icon_error.png');//加载默认图片
                }
                $scope.adminitem = $scope.adminlist[0];
                $scope.adminitem.userName=user_name;
                $('.table-addform').addClass('a-show');
                $('.table-addform').removeClass('a-hide');
                $('table,.title,.pagingbox').hide();
                $('.table-addform').show();
                $scope.$apply();
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
            $scope.adminlist=[];
            $scope.adminitem={};
            $scope.loadAdmin();
            for(i=0;i<$scope.datas.length;i++){
                $scope.datas[i].td0=false
            }
        };
        //上传图片
        $scope.uploadIcon = function (selector) {
            imguploadandpreview(selector, '1', function (data) {
                img_id=data.fid;//获取图片存储id
            });
        }
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
        //新建和修改，验证+保存
        $("#Form").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                if(add_edit) { //如果添加
                    var parames = $("#Form").serializeObject();//参数
                        parames["adminIcon"]=img_id;  //获取新增的图片Id
                        remotecallasync("adminManage_add", parames, function (data) {
                            if (data == 2) {  //如果新增成功
                                closeLoading();
                                parent.pMsg("添加管理员成功");
                                //重新加载用户
                                $('.table-addform').hide();
                                $('table,.title,.pagingbox').show();
                                $('#UserForm input').text("");
                                $scope.loadAdmin();
                                $scope.$apply();
                                $scope.adminlist = [];
                                $scope.adminitem = {};
                                img_id="";
                            }else if(data==0){
                                closeLoading();
                                parent.pMsg("姓名已存在");
                            }
                            else if(data==1){
                                closeLoading();
                                parent.pMsg("用户名已存在");
                            }else{
                                closeLoading();
                                parent.pMsg("添加管理员失败");
                            }
                        }, function (data) {
                            closeLoading();
                            parent.pMsg("数据库请求失败");
                            console.log(data);
                        });
                }else{//如果修改//
                    var edit_name = $scope.adminlist[0].adminId;//修改时获取管理员Id
                    var edit_Id;//存储用户Id
                    var parames = $("#Form").serializeObject();//参数
                    parames["adminId"]=edit_name; //判断是否修改管理员Id
                    if(img_id==""||img_id==null){//如果不上传图片
                        parames["adminIcon"]=img_ischange;
                    }else{
                        parames["adminIcon"]=img_id;
                    };
                    remotecall("adminName_userName",{adminId:edit_name},function (data) {//获取用户Id 用于判断修改管理员信息修改的用户名是否冲突
                        if(data){
                        edit_Id = data[0].userId;
                        }
                    });
                    parames["userId"]=edit_Id; //判断是否修改用户Id
                        remotecallasync("adminManage_edit", parames, function (data) {
                            if(data==2){
                                closeLoading();//关闭加载层
                                parent.pMsg("修改成功");
                                //重新加载用户
                                $('.table-addform').hide();
                                $('table,.title,.pagingbox').show();
                                $scope.loadAdmin();
                                $scope.$apply();
                                $scope.adminlist=[];
                                $scope.adminitem={};
                                img_id="";
                            } else if(data==0){
                                closeLoading();//关闭加载层
                                parent.pMsg("姓名已存在");
                            } else if(data==1){
                                parent.pMsg("用户名已存在");
                                closeLoading();//关闭加载层
                            }else{
                                parent.pMsg("修改失败");
                                closeLoading();//关闭加载层
                            }
                        }, function (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("数据库请求失败");
                            console.log(data);
                        });
                  }
            },
            rules:{
                userName:{
                    required:true
                },
                adminName:{
                    required:true
                },
                adminPhone:{
                    required:true,
                    tel:true
                },
                adminEmail:{
                    required:true,
                    email:true
                }
            },
            messages:{
                userName:{
                    required:"请输入用户名"
                },
                adminName:{
                    required:"请输入姓名"
                },
                adminPhone:{
                    required:"请输入电话",
                    tel:"请输入正确的电话"
                },
                 adminEmail:{
                     required:"请输入邮箱",
                     email:"请输入正确的邮箱"
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
        <%--//图片加载失败时进行处理--%>
        <%--function onError(obj) {--%>
            <%--obj.src="<%=request.getContextPath()%>/images/icon_error.png')";--%>
          <%--};--%>
    });

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>