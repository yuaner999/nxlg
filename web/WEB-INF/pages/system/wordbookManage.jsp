<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-03-15
  Time: 15:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：数据字典
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" /> 新建</table-btn>
    <table-btn class="top" ng-click="delete()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <input class="tablesearchbtn" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>字典的键</th>
        <th>字典的值</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas|orderBy:order+orderType">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="wordbookId" value="{{data.wordbookId}}"/>
            </td>
            <td ng-bind="data.wordbookKey"  class="th-left"></td>
            <td ng-bind="data.wordbookValue"  class="th-left"></td>
            <td><table-btn ng-click="edit(data)">修改</table-btn><b style="margin-right: 10px"></b><table-btn ng-click="del(data)">删除</table-btn></td>
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
    <form id="MenuForm">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <%--<li style="display: none;"><span>ID：</span><input type="text" name="wordbookId" class="forminput" /></li>--%>
                <li><span>字典的键：</span><input type="text"  ng-model="bookitem.wordbookKey" name="wordbookKey" class="forminput" id="wordbookKey"/></li>
                <li><span>字典的值：</span><input type="text" ng-model="bookitem.wordbookValue" name="wordbookValue" class="forminput" id="wordbookValue"/></li>
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
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        var num=0;//checked数量

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadWordbook();
        }

        //加载数据字典
        $scope.loadWordbook = function () {
            loading();//加载
            remotecall("wordbookManage_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
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
                changeSelect();//改变分页选中样式
                for(i=0;i<$scope.datas.length;i++){
                    $scope.datas[i].td0=false;
                }
                $scope.all=false;
                num=0;
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            $scope.booklist=[];
            $scope.bookitem={};
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
                $scope.loadWordbook();
            }
        };
        //checked 复选框判断
        $scope.all = false;
        $scope.booklist=[];
        $scope.bookitem={};
        //首次加载菜单
        //先定义，后使用，否则出错误！！！
        $scope.loadWordbook();
        //批量删除功能
        $scope.delete = function () {
            //获取所选择的行
            if($("input[name='wordbookId']:checked").length<1){
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='wordbookId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有内容吗？",function () {
                loading();
                remotecall("wordbookManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        parent.pMsg("批量删除成功");
                        //重新加载菜单
                        closeLoading();//关闭加载层
                        $scope.loadWordbook();
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
            $scope.booklist.push(tr);
            $scope.bookitem=$scope.booklist[0];
            parent.pConfirm("确认删除选中的内容吗？",function () {
                loading();
                remotecall("wordbookManage_del",$scope.bookitem,function (data) {
                    if(data){
                        closeLoading();//关闭加载层
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        $scope.loadWordbook();
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
        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.booklist.push(tr);
            }else{
                num--;
                tr.td0 = false;
                $scope.all=false;
                var index = $scope.booklist.indexOf(tr);
                if (index > -1) {
                    $scope.booklist.splice(index, 1);
                }
            }
            if(num==$scope.datas.length){
                $scope.all=true;
            }else{
                $scope.all=false;
            }
        };
        //修改
        $scope.edit= function (tr) {
            add_edit=false;
            $scope.booklist.push(tr);
            $scope.bookitem=$scope.booklist[0];
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
            $scope.booklist=[];
            $scope.bookitem={};
            $scope.all = false;
            for(i=0;i<$scope.datas.length;i++){
                $scope.datas[i].td0=false;
            }
            $scope.all=false;
            num=0;
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
        //新建和修改，验证+保存
        $("#MenuForm").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                if(add_edit){
                    var parames = $("#MenuForm").serializeObject();//参数
                    remotecall("wordbookManage_add",parames,function (data) {
                        if(data.result){
                            closeLoading();//关闭加载层
                            parent.pMsg(data.msg);
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $('#MenuForm input').text("");
                            $scope.loadWordbook();
                            $scope.$apply();
                        }else {
                            closeLoading();//关闭加载层
                            parent.pMsg(data.msg);
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }else{
                    remotecallasync("wordbookManage_edit",$scope.bookitem,function (data) {
                        if(data.result){
                            closeLoading();//关闭加载层
                            parent.pMsg(data.msg);
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $scope.loadWordbook();
                            $scope.$apply();
                        }else {
                            closeLoading();//关闭加载层
                            parent.pMsg(data.msg);
                        }
                    },function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }
            },
            rules:{
                wordbookKey:{
                    required:true
                },
                wordbookValue:{
                    required:true
                }
            },
            messages:{
                wordbookKey:{
                    required:"请输入字典的键"
                },
                wordbookValue:{
                    required:"请输入字典的值"
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
        //排序
//        $scope.orderType='wordbookKey';
//        $scope.order='-';
//        $scope.sorting=function(type){
//            $scope.orderType=type;
//            if($scope.order===''){
//                $scope.order='-';
//                $scope.loadWordbook();
//            }else{
//                $scope.order='';
//                $scope.loadWordbook();
//            }
//        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>