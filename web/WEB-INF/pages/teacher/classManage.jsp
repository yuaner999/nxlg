<%--
  Created by IntelliJ IDEA.
  User: gq
  Date: 2017/6/1
  Time: 10:51
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
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：班级管理
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" /> 新建</table-btn>
    <table-btn class="top" ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <%--<table-btn class="top" ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>--%>
    <%--<table-btn class="top" ng-click="checkdetail()"><img src="<%=request.getContextPath()%>/images/details.png" />查看详情</table-btn>--%>
    <input class="tablesearchbtn" type="text" placeholder="请输入班级名称进行搜索..." onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>班级名称</th>
        <%--<th>所属学院</th>--%>
        <%--<th>所属专业</th>--%>
        <th>所属年级</th>
        <%--<th>创建人</th>--%>
        <%--<th>创建时间</th>--%>
        <%--<th>更新人</th>--%>
        <%--<th>更新时间</th>--%>
        <th>操作</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="classId" value="{{data.classId}}"/>
            </td>
            <td ng-bind="data.className"></td>
            <%--<td ng-bind="data.collegeName"></td>--%>
            <%--<td ng-bind="data.majorName"></td>--%>
            <td ng-bind="data.gradeName"></td>
            <%--<td ng-bind="data.createMan"></td>--%>
            <%--<td ng-bind="data.createDate"></td>--%>
            <%--<td ng-bind="data.updateMan"></td>--%>
            <%--<td ng-bind="data.updateDate"></td>--%>
            <td><table-btn ng-click="edit(data)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="delete(data)">删除</table-btn></td>
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
<!--新建表单-->
<!--class a-show  是显示动画  如果要隐藏先删除a-show  再添加a-hide Class 等待300毫秒动画时间之后再隐藏-->
<div class="table-addform container-fluid a-show">
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：班级管理 > 新增/修改
    <hr>
    <form id="MenuForm">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li style="display: none"><span>班级id：</span>
                    <input  ng-model="item.classId" name="classId" class="forminput" id="classId"/>
                </li>
                <%--<li ><span>学院名称：</span>--%>
                    <%--<select  ng-model="item.collegeName" name="collegeName" class="forminput" id="collegeName" ng-change="changeCollege(item.collegeName)">--%>
                        <%--<option value="" >--请选择--</option>--%>
                        <%--<option ng-repeat="college in colleges" value="{{college.wordbookValue}}">{{college.wordbookValue}}</option>--%>
                    <%--</select>--%>
                <%--</li>--%>
                <%--<li ><span>专业名称：</span>--%>
                    <%--<select  ng-model="item.majorName" name="majorName" class="forminput" id="majorName">--%>
                        <%--<option value="" >--请选择--</option>--%>
                        <%--<option ng-repeat="major in newMajors" value="{{major.majorName}}">{{major.majorName}}</option>--%>
                    <%--</select>--%>
                <%--</li>--%>
                <li ><span>年级名称：</span>
                    <select  ng-model="item.gradeName" name="gradeName" class="forminput" id="gradeName">
                        <option value="" >--请选择--</option>
                        <option ng-repeat="grade in grades" value="{{grade.wordbookValue}}">{{grade.wordbookValue}}</option>
                    </select>
                </li>
                <li ><span>班级名称：</span>
                    <input  ng-model="item.className" name="className" class="forminput" id="className"/>
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
    var add_edit = true;//true为新建，false为修改
    var num=0;
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载下拉选项
        remotecall("teacher_loadCoMaGrInfo",{},function (data) {
            $scope.colleges=data.college;
            $scope.majors=data.major;
            $scope.grades=data.grade;
        },function (data) {});
        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.search();
        }
        //学院信息
        $scope.search = function () {
            loading();
            remotecall("classManage_loadclasses",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
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
            $scope.item={};
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
        //删除功能
        $scope.delete=function (tr) {
            loading();

            var deleteIds=new Array(tr.classId);
            parent.pConfirm("确认删除该条数据吗？",function () {
                remotecall("classManage_delete",{deleteIds:deleteIds},function (data) {
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
            //获取所选择的行
            $("#table_detail").hide();
            if($("input[name='classId']:checked").length<1){
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='classId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有内容吗？",function () {
                loading();
                remotecall("classManage_delete",{deleteIds:deleteIds},function (data) {
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
            },function () {});
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
        //修改
        $scope.edit= function (tr) {
            add_edit=false;
            $("#table_detail").hide();
            $('#all').attr("checked",false);
            $scope.allfn();
            tr.td0 = true;
            $scope.list.splice(0, 1,tr);
            var checknum=$scope.list.length;
            if(checknum!=1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else{
                var newMajors=[];
                for (var i = 0; i < $scope.majors.length; i++) {
                    var obj = $scope.majors[i];
                    if(obj.majorCollege===tr.collegeName){
                        newMajors.push(obj)
                    }
                }
                $scope.newMajors=newMajors;
                $scope.item=$scope.list[0];
                $('.table-addform').addClass('a-show');
                $('.table-addform').removeClass('a-hide');
                $('table,.title,.pagingbox').hide();
                $('.table-addform').show();
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
            $scope.search();
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
                    remotecall("classManage_addclass",parames,function (data) {
                        if(data.result){
                            closeLoading();
                            parent.pMsg("添加成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $('#MenuForm input').text("");
                            $scope.search();
                            $scope.$apply();
                        }else  {
                            closeLoading();
                            parent.pMsg(data.errormessage);
                        }
                    },function (data) {
                        closeLoading();
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }else{
                    var parames = $("#MenuForm").serializeObject();//参数
                    remotecallasync("classManage_editclass",parames,function (data) {
                        if(data.result) {
                            closeLoading();
                            parent.pMsg("修改成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $scope.search();
                            $scope.$apply();
                        }else {
                            closeLoading();
                            parent.pMsg(data.errormessage);
                        }
                    },function (data) {
                        closeLoading();
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }
            },
            rules:{
                gradeName:{
                    required:true
                },
                className:{
                    required:true
                }
            },
            messages:{
                gradeName:{
                    required:"请输入年级名称"
                },
                className:{
                    required:"请输入班级名称"
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