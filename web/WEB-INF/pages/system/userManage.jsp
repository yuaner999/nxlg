<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-14
  Time: 15:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=request.getContextPath()%>/js/jquery.md5.js" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/table-resetpassword.css"/>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：用户管理
<hr>
<div class="title">
    <table-btn ng-click="enable()"><img src="<%=request.getContextPath()%>/images/tablepass.png" />启用</table-btn>
    <table-btn ng-click="disable()"><img src="<%=request.getContextPath()%>/images/tablereject.png" />停用</table-btn>
    <table-btn ng-click="reset()"><img src="<%=request.getContextPath()%>/images/resetpassword1.png" style="width:18px;height:18px"/>重置密码</table-btn>
    <input  class="tablesearchbtn" type="text"  placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>用户名</th>
        <th>类型名称</th>
        <th>角色名称</th>
        <th>是否停用账号</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="user in users">
            <td class="thischecked" ng-click="thischecked(user)">
                <input type="checkbox" ng-model="user.td0" name="userIdSelect" value="{{user.userId}}"/>
            </td>
            <td ng-bind="user.userName"></td>
            <td ng-bind="user.typeName"></td>
            <td ng-bind="user.roleName"></td>
            <td ng-bind="user.userStatus"></td>
            <td><table-btn ng-click="edit(user)">修改</table-btn></td>
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
                <li style="display: none;"><span>ID：</span><input type="text" name="userId" class="forminput" /></li>
                <li><span>用户名：</span><input type="text" ng-model="useritem.userName" name="userName" class="forminput" id="userName"/></li>
                <li><span>角色名称：</span>
                    <select  ng-model="useritem.roleId" name="roleId" class="forminput" id="roleId">
                        <option  value="" selected >--请选择--</option>
                        <option ng-repeat="option in options" value="{{option.roleId}}" >{{option.roleName}}</option>
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
<!--重置密码-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-resetpassword container-fluid a-show">
    <form id="Form1">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li style="display: none;"><span>ID：</span><input type="text" name="userId" class="forminput" /></li>
                <li><span>新的登录密码：</span><input type="password"  name="password" class="forminput" id="password"/></li>
                <li><span>确认登录密码：</span><input type="password"  name="password1" class="forminput" id="password1"/></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel1()">取消</span>
        </div>
    </form>
</div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadUser();
        }

        //加载数据
        var num=0;
        $scope.loadUser = function () {
            loading();//加载层
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("userManage_loadUser",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
                $scope.users = data.rows;//加载的数据对象，‘roles’根据不同需求而变

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

                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            remotecall("userManage_loadRole",'',function (data) {
                closeLoading();
                $scope.options = data;
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载角色名称失败,或连接数据库失败");
                console.log(data);
            });
            $scope.userlist=[];
            $scope.useritem={};
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
                pageNum = pn;
                $scope.loadUser();
            }
        };
        //修改用户信息
        $scope.edit= function (tr) {
            add_edit=false;
            $scope.userlist.push(tr);
            $scope.useritem = $scope.userlist[0];
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('.table-addform').show();
            $('table,.title,.pagingbox').hide();
        };
        //重置密码
        $scope.reset=function () {
            var checknum=$scope.userlist.length;
            if(checknum!=1){
                parent.pMsg("请选择一条记录");
                return;
            }
            else{
                $('.table-resetpassword').addClass('a-show');
                $('.table-resetpassword').removeClass('a-hide');
                $('.table-resetpassword').show();
                $('table,.title,.pagingbox').hide();
            }
        }
        //启用
        $scope.enable = function () {
            loading();
            //获取所选择的行
            if($("input[name='userIdSelect']:checked").length<1){
                closeLoading();//关闭加载层
                parent.pMsg("请至少选择一条记录");
                return;
            }
            var enableIds = $("input[name='userIdSelect']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要启用的Id
            parent.pConfirm("确认启用所选中的用户吗？",function () {
                remotecall("userManage_Enable",{enableIds:enableIds},function (data) {
                    if(data){
                        parent.pMsg("启用成功");
                        closeLoading();//关闭加载层
                        //重新加载数据
                        $scope.loadUser();
                        $scope.$apply();
                    }else {
                        parent.pMsg("启用失败");
                        closeLoading();//关闭加载层
                    }
                },function (data) {
                    parent.pMsg("数据库连接失败");
                    closeLoading();//关闭加载层
                    console.log(data);
                });
            },function () {
                closeLoading();//关闭加载层
            });
        };
        //停用
        $scope.disable = function () {
            loading();
            //获取所选择的行
            if($("input[name='userIdSelect']:checked").length<1){
                closeLoading();//关闭加载层
                parent.pMsg("请至少选择一条记录");
                return;
            }
            var enableIds = $("input[name='userIdSelect']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要停用的Id
            parent.pConfirm("确认停用所选中的用户吗？",function () {
                remotecall("userManage_Disable",{enableIds:enableIds},function (data) {
                    if(data){
                        parent.pMsg("停用成功");
                        closeLoading();//关闭加载层
                        //重新加载数据
                        $scope.loadUser();
                        $scope.$apply();
                    }else {
                        parent.pMsg("停用失败");
                        closeLoading();//关闭加载层
                    }
                },function (data) {
                    parent.pMsg("数据库连接失败");
                    closeLoading();//关闭加载层
                    console.log(data);
                });
            },function () {
                closeLoading();//关闭加载层
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
            $scope.userlist=[];
            $scope.useritem={};
            $scope.all = false;
            for(i=0;i<$scope.users.length;i++){
                $scope.users[i].td0=false;
            }
            $scope.loadUser();
        };
        //隐藏
        $scope.cancel1=function () {
            $('.table-resetpassword').addClass('a-hide');
            $('.table-resetpassword').removeClass('a-show');
            setTimeout(function () {
                $('.table-resetpassword').hide();
            },300);
            $('table,.title,.pagingbox').show();
            $scope.userlist=[];
            $scope.useritem={};
            $scope.all = false;
            for(i=0;i<$scope.users.length;i++){
                $scope.users[i].td0=false;
            }
        };
        //首次加载用户信息
        $scope.loadUser();
        //checked 复选框判断
        $scope.all = false;
        $scope.userlist=[];
        $scope.useritem={};
        $scope.allfn = function  () {
            if($scope.all == false){
                for(i=0;i<$scope.users.length;i++){
                    $scope.users[i].td0=false
                }
                num=0;
            }else{
                for(i=0;i<$scope.users.length;i++){
                    $scope.users[i].td0=true
                }
                num=$scope.users.length;
            }
        };
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.userlist.push(tr);
            }else{
                num--;
                tr.td0 = false;
                $scope.all = false;
                var index = $scope.userlist.indexOf(tr);
                if (index > -1) {
                    $scope.userlist.splice(index, 1);
                }
            }
            if(num==$scope.users.length){
                $scope.all=true;
            }else {
                $scope.all=false;
            }
        };
        $("#Form").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                    var parames = $("#Form").serializeObject();//参数
                    var edit_Id =  $scope.useritem.userId;
                    parames.userId=edit_Id;
                    remotecallasync("userName_unique", parames, function (data) {//判断用户名是否已存在
                        if (data.length == '0'||data[0].userId == edit_Id) {
                            parames.typeName=$("#roleId option:selected").text();//获取角色名称
                            parames.roleId=$("#roleId option:selected").val();//获取角色Id
                            parames.userId=edit_Id;//获取修改用户Id
                            remotecallasync("userManage_editUser", parames, function (data) {
                                if(data.result){
                                    closeLoading();//关闭加载层
                                    parent.pMsg("修改用户信息成功");
                                    //重新加载用户
                                    $('.table-addform').hide();
                                    $('table,.title,.pagingbox').show();
                                    $scope.loadUser();
                                    $scope.$apply();
                                    $scope.userlist=[];
                                    $scope.useritem={};
                                } else {
                                    parent.pMsg(data.errormessage);
                                    closeLoading();//关闭加载层
                                }
                            }, function (data) {
                                parent.pMsg("数据库请求失败");
                                closeLoading();//关闭加载层
                                console.log(data);
                            });
                        } else {
                            parent.pMsg("用户名已存在");
                            $scope.loadUser();
                            closeLoading();//关闭加载层
                            return;
                        }
                    }, function (data) {
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
            },
            rules:{
                userName:{
                    required:true,
                    maxlength:25
                },
                roleId:{
                    required:true,
                    maxlength:5
                },
            },
            messages:{
                userName:{
                    required:"请输入用户名",
                    maxlength:"长度不超过25个字符"
                },
                roleId:{
                    required:"请选择",
                    maxlength:"请选择"
                },
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
            //搜索 绑定回车事件
        });
        $("#Form1").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                var userId = $("input[name='userIdSelect']:checked").map(function(index,elem) {
                    return $(elem).val();
                }).get();//获取用户Id
                var password=$.md5($("#password").val());
                remotecallasync("userManage_resetPassword", {userId:userId[0],password:password}, function (data) {
                        if(data){
                            closeLoading();//关闭加载层
                            parent.pMsg("重置密码成功");
                            //重新加载用户
                            $('.table-resetpassword').hide();
                            $('table,.title,.pagingbox').show();
                            $scope.loadUser();
                            $scope.$apply();
                            $scope.userlist=[];
                            $scope.useritem={};
                        } else {
                            parent.pMsg("重置密码失败");
                            closeLoading();//关闭加载层
                        }
                    }, function (data) {
                        parent.pMsg("数据库请求失败");
                        closeLoading();//关闭加载层
                        console.log(data);
                    });
            },

            rules:{
                password:{
                    required:true,
                    maxlength:15
                },
                password1:{
                    equalTo:password,
                },
            },
            messages:{
                password:{
                    required:"请输入新密码",
                    maxlength:"长度不超过15个字符"
                },
                password1:{
                    equalTo:"密码不一致",
                },
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
            //搜索 绑定回车事件
        });
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>