<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/19
  Time: 15:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <style>
        #MenuForm span{ width:135px;}
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：排课时间管理
<hr>
<!--导航筛选 此页不需要-->
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" /> 新建</table-btn>
    <table-btn class="top" ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <%--<table-btn class="top" ng-click="edit()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />修改</table-btn>--%>
    <input class="tablesearchbtn" type="text" placeholder="请输入学期进行搜索..." onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="search()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/></th>
        <th>学期</th>
        <th>起始周</th>
        <th>结束周</th>
        <th>排课天数/周</th>
        <th>上午上课节数</th>
        <th>下午上课节数</th>
        <th>晚上上课节数</th>
        <th>是否当前学期</th>
        <th style="width:160px;"></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="acId" value="{{data.acId}}"/>
            </td>
            <td ng-bind="data.semester"></td>
            <td ng-bind="data.startWeek"></td>
            <td ng-bind="data.endWeek"></td>
            <td ng-bind="data.days"></td>
            <td ng-bind="data.lessonsMorning"></td>
            <td ng-bind="data.lessonAfternoon"></td>
            <td ng-bind="data.lessonNight"></td>
            <td ng-bind="data.is_now=='true'?'是':'否'"></td>
            <td><table-btn ng-click="edit(data)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="checked(data)">删除</table-btn></td>
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
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：排课时间管理 > 新增/修改
    <hr>
    <form id="MenuForm">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li style="display: none"><span>排课Id：</span><input type="text"  ng-model="arrangecourseitem.acId" name="acId" class="forminput" id="acId"/></li>
                <li><span>学期：</span>
                    <select  ng-model="arrangecourseitem.semester" name="semester" class="forminput" id="semester" >
                        <option value="" >--请选择--</option>
                        <option value="{{Now-1}}/{{Now}}第一学期" >{{Now-1}}/{{Now}}第一学期</option>
                        <option value="{{Now-1}}/{{Now}}第二学期" >{{Now-1}}/{{Now}}第二学期</option>
                        <option value="{{Now}}/{{Now+1}}第一学期" >{{Now}}/{{Now+1}}第一学期</option>
                        <option value="{{Now}}/{{Now+1}}第二学期" >{{Now}}/{{Now+1}}第二学期</option>
                        <option value="{{Now+1}}/{{Now+2}}第一学期" >{{Now+1}}/{{Now+2}}第一学期</option>
                        <option value="{{Now+1}}/{{Now+2}}第二学期" >{{Now+1}}/{{Now+2}}第二学期</option>
                    </select>
                </li>
                <li><span>是否当前学期：</span>
                    <select  ng-model="arrangecourseitem.is_now" name="is_now" class="forminput" id="is_now">
                        <option value="" >--请选择--</option>
                        <option value=true>是</option>
                        <option value=false>否</option>
                    </select>
                </li>
                <li><span>课程起始周：</span><input type="text"  ng-model="arrangecourseitem.startWeek" name="startWeek" class="forminput" id="startWeek"/></li>
                <li><span>课程结束周：</span><input type="text" ng-model="arrangecourseitem.endWeek" name="endWeek" class="forminput" id="endWeek"/></li>
                <li><span>每周上课天数：</span><input type="text"  ng-model="arrangecourseitem.days" name="days" class="forminput" id="days"/></li>
                <li><span>上午上课节数：</span><input type="text" ng-model="arrangecourseitem.lessonsMorning" name="lessonsMorning" class="forminput" id="lessonsMorning"/></li>
                <li><span>下午上课节数：</span><input type="text" ng-model="arrangecourseitem.lessonAfternoon" name="lessonAfternoon" class="forminput" id="lessonAfternoon"/></li>
                <li><span>晚上上课节数：</span><input type="text" ng-model="arrangecourseitem.lessonNight" name="lessonNight" class="forminput" id="lessonNight"/></li>
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
        var now1=new Date();
        //获取当前年份
        $scope.Now=now1.getFullYear();
        //加载排课时间信息
        $scope.search = function () {
            loading();//加载
            remotecall("arrangecoursedateManage_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
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
            $scope.arrangecourselist=[];
            $scope.arrangecourseitem={};
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
        $scope.arrangecourselist=[];
        $scope.arrangecourseitem={};
        //首次加载菜单
        //先定义，后使用，否则出错误！！！
        $scope.search();
        //删除功能
        $scope.checked=function (tr) {
            loading();

            var deleteIds=new Array(tr.acId);
            parent.pConfirm("确认删除该条数据吗？",function () {
                remotecall("arrangecoursedateManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        closeLoading();//关闭加载层
                        $scope.search();
                        $scope.$apply();
                    }else {
                        parent.pMsg("删除失败");
                        closeLoading();//关闭加载层
                    }
                },function (data) {
                    parent.pMsg("删除失败");
                    closeLoading();//关闭加载层
                    console.log(data);
                });
            },function () {
                closeLoading();//关闭加载层
            });
        }
        //批量删除功能
        $scope.deletes = function () {
            loading();
            //获取所选择的行
            if($("input[name='acId']:checked").length<1){
                closeLoading();
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='acId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有内容吗？",function () {
                remotecall("arrangecoursedateManage_delete",{deleteIds:deleteIds},function (data) {
                    if(data){
                        parent.pMsg("删除成功");
                        //重新加载菜单
                        closeLoading();
                        $scope.search();
                        $scope.$apply();
                    }else {
                        parent.pMsg("删除失败");
                        closeLoading();
                    }
                },function (data) {
                    parent.pMsg("删除失败");
                    closeLoading();
                    console.log(data);
                });
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
            $("#MenuForm input").value={};
        };
        //check事件
        $scope.thischecked = function  (tr) {
            if(tr.td0 == false||tr.td0 == null){
                num++;
                tr.td0 = true;
                $scope.arrangecourselist.push(tr);
            }else{
                num--;
                $scope.all = false;
                tr.td0 = false;
                var index = $scope.arrangecourselist.indexOf(tr);
                if (index > -1) {
                    $scope.arrangecourselist.splice(index, 1);
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

                $scope.arrangecourseitem=tr;
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
            $scope.arrangecourselist=[];
            $scope.arrangecourseitem={};
            $scope.search();
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
        //新建和修改，验证+保存
        $("#MenuForm").validate({
            submitHandler:function(form){
                //验证通过,然后就保存
                loading();
                if(add_edit){
                    var parames = $("#MenuForm").serializeObject();//参数
                    if(parseInt(parames.endWeek)<=parseInt(parames.startWeek)){
                        closeLoading();
                        parent.pMsg("起始周不能大于结束周");
                        return;
                    }
                    remotecall("arrangecoursedateManage_add",parames,function (data) {
                        if(data===1){
                            parent.pMsg("该学期排课信息已存在");
                            closeLoading();
                        }else if(data){
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
                            parent.pMsg("添加失败");
                        }
                    },function (data) {
                        closeLoading();
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }else{
                    var parames = $("#MenuForm").serializeObject();//参数
                    if(parseInt(parames.endWeek)<=parseInt(parames.startWeek)){
                        parent.pMsg("起始周不能大于结束周");
                        closeLoading();
                        return;
                    }
                    remotecallasync("arrangecoursedateManage_edit",parames,function (data) {
                        if(data===1){
                            closeLoading();
                            parent.pMsg("该学期排课信息已存在");
                        }else if(data) {
                            closeLoading();
                            parent.pMsg("修改成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $scope.search();
                            $scope.$apply();
                        }else {
                            closeLoading();
                            parent.pMsg("修改失败");
                        }
                    },function (data) {
                        closeLoading();
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }
            },
            rules:{
                semester:{
                    required:true,
                    maxlength:4
                },
                is_now:{
                    required:true,
                    maxlength:4
                },
                startWeek:{
                    required:true,
                    max:60
                },
                endWeek:{
                    required:true,
                    max:60
                },
                days:{
                    required:true,
                    max:7
                },
                lessonsMorning:{
                    required:true,
                    max:4
                },
                lessonAfternoon:{
                    required:true,
                    max:4
                },
                lessonNight:{
                    required:true,
                    max:4
                }
            },
            messages:{
                semester:{
                    required:"请选择学期",
                    maxlength:"请选择学期"
                },
                is_now:{
                    required:"请选择",
                    maxlength:"请选择"
                },
                startWeek:{
                    required:"请输入课程起始周",
                    max:"请正确输入课程起始周"
                },
                endWeek:{
                    required:"请输入课程结束周",
                    max:"请正确输入课程结束周"
                },
                days:{
                    required:"请输入每周上课天数",
                    max:"请正确输入每周上课天数"
                },
                lessonsMorning:{
                    required:"请输入每周上午上课节数",
                    max:"请正确输入每周上午上课节数"
                },
                lessonAfternoon:{
                    required:"请输入每周下午上课节数",
                    max:"请正确输入每周下午上课节数"
                },
                lessonNight:{
                    required:"请输入每周晚上上课节数",
                    max:"请正确输入每周晚上上课节数"
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