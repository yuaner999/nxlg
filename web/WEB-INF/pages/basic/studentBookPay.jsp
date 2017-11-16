<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/18
  Time: 17:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/zTreeStyle/zTreeStyle.css"/>
    <script src="<%=request.getContextPath()%>/js/jquery.ztree.all.js" type="text/javascript" charset="utf-8"></script>
    <style>
        #MenuForm span{ width:200px;}
        .table>tbody>tr>td{max-width: 200px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis}
        .table_detail{height: 410px;width:506px;position: absolute;border: 3px solid #c5add7;}
        .span_detail{font-weight: bold;line-height: 3em;width:123px;font-family: wingdings;display: inline-block; }
        #modal {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            z-index: 999;
            display:none
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
        #modal1 {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            z-index: 99999;
            display:none
        }
        #modal .mask1 {
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            background-color: #000;
            opacity: 0;
        }
        #table_detail{
            z-index: 9999;
        }
        .div_pay{border-top: 2px dashed #c5add7;padding: 12px;position: absolute;bottom: 18px;width:96%}
        .div_pay a{display: block;text-decoration: none;background-color:#c5add7 }
        .btn_pay{width:50%;margin-left: 25%;margin-top: 22px;color: white;font-weight:bold;
            background-color: #c5add7;letter-spacing: 5px;
            font-family:'Consolas', 'Monaco', 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace}
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--导航筛选 此页不需要-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：学生教材缴费
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="pay()"><img src="<%=request.getContextPath()%>/images/tablechange_07.png" />现在缴费</table-btn>
    <%--<input class="tablesearchbtn" type="text" placeholder="请输入关键字进行搜索" onkeyup="getSearchStr(this)" />--%>
    <%--<table-btn id="search" ng-click="search()">搜索</table-btn>--%>
</div>
<%--教材信息--%>
<div style="margin-bottom: 12px;
    position: absolute;
    margin-left: 406px;
    font-size: initial;
    line-height: 2em;
    width: 835px;
    height: 50px;
    top: 7px;
    text-align: -webkit-center;
    padding-top: 0px;">
    <div style="display: inline-block;margin-right: 52px;">
        <span>当前缴费状态：</span><input type="text" readonly ng-model="status" style="color:red;margin:5px;width:306px;">
    </div>
</div>
<!--表格-->
<div style="width:100%">
    <div class="tablebox" style="width:100%;">
        <table class="table">
            <thead>
            <th>课程代码</th>
            <th>课程名称</th>
            <th>教材名称</th>
            <th>出版社</th>
            <th>版次</th>
            <th>书号</th>
            <th>价格</th>
            <%--<th></th>--%>
            </thead>
            <tbody>
            <tr ng-repeat="data in datas">
                <%--<td><img src="<%=request.getContextPath()%>/images/details.png" style="cursor: pointer" ng-click="checked(data);checkdetail()"/>--%>
                <%--{{data.name}}--%>
                <%--</td>--%>
                <td ng-bind="data.courseCode"></td>
                <td ng-bind="data.chineseName"></td>
                <td ng-bind="data.name"></td>
                <td ng-bind="data.press"></td>
                <td ng-bind="data.edition"></td>
                <td ng-bind="data.booknumber"></td>
                <td ng-bind="data.price"></td>
                <%--<td><table-btn ng-click="edit(data)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="delete(data)">删除</table-btn></td>--%>
            </tr>
            </tbody>
        </table>
    </div>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>
<%--遮罩层--%>
<div id="modal">
    <div class="mask"></div>
</div>
<%--遮罩层--%>
<div id="modal1">
    <div class="mask1"></div>
</div>
<%--查看详情--%>
<div id="table_detail"  title="缴费页面" style="display:none;width:500px;height:440px;padding:10px;position:absolute;border:2px #c5add7 solid; left:30%;top:15%;background-color:#ffffff">
    <div id="table_box1" style="margin-bottom: 10px;margin-top: 10px;">
        <label style="color: rgb(197, 173, 215);">缴费页面</label>
        <img style="float: right; position:absolute; top:15px;right:14px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="cancel()">
    </div>
    <div id="table_box" style="margin-bottom: 10px;margin-top: 10px;">
        <div id="valid_result"  style="display: inline-block;width:100%;height: 0px;border: 2px solid #c5add7;overflow: auto"></div>
    </div>
    <div style="text-align: center">
        <span style="color: red;text-align: center">————缴费前请认真核对个人信息，确保无误后缴费————</span>
    </div>
    <div id="table_det" style="margin-top: 12px;margin-left: 140px;position: absolute">
        <ul>
            <li><span class="span_detail">学 号：</span><span ng-bind="studentNum"/></li>
            <li><span class="span_detail">姓 名：</span><span type="text" ng-bind="studentName"/></li>
            <li><span class="span_detail">书费总金额：</span><span ng-bind="'￥'+shouldPay"/></li>
            <li><span class="span_detail">已缴费金额：</span><span type="text" ng-bind="'￥'+realPay"/></li>
            <li><span class="span_detail">应缴费金额：</span><span type="text"  ng-bind="'￥'+pay_num"/></li>
        </ul>
    </div>
    <!--支付方式
-->
    <%--<div style="border-top: 2px dashed #c5add7;padding: 12px;position: absolute;bottom: 18px;width:96%" >--%>
    <%--<a class="" href="" ng-click="" style="display: block;text-decoration: none;background-color:#c5add7 ">--%>
    <%--<span style="margin-left: 41%">支付方式</span><span style="float: 50%;margin-left: 26%">微信支付 ></span>--%>
    <%--</a>--%>
    <%--<table-btn id="btn_pay" class="top" ng-click="payNow()" style="width:50%;margin-left: 25%;margin-top: 22px;color: white;font-weight:bold;--%>
    <%--background-color: #c5add7;letter-spacing: 5px;--%>
    <%--font-family:'Consolas', 'Monaco', 'Bitstream Vera Sans Mono', 'Courier New', Courier, monospace">点我去缴费</table-btn>--%>
    <%--</div>--%>
    <div class="div_pay">
        <a class="" href="" ng-click="">
            <span style="margin-left: 41%">支付方式</span><span style="float: 50%;margin-left: 26%">微信支付 ></span>
        </a>
        <table-btn class="btn_pay" ng-click="payNow()">点我去缴费</table-btn>
    </div>
</div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope,$filter) {
        //加载信息
        $scope.isChange=true;
        $scope.search = function () {
            loading();//加载
            remotecall("studentBookPay_load",{pageNum:pageNum,pageSize:pageSize},function (data) {
                if(data==1){
                    closeLoading();//关闭加载层
                    parent.pMsg("没有您的缴费信息：非学生用户，若有疑问请联系管理员");
                    return ;
                }
                //数据为0时提示
                if(data.total==0){
                    closeLoading();//关闭加载层
                    parent.pMsg("暂时没有您的缴费信息和选课信息，若有疑问请联系管理员");
                }else{
                    closeLoading();//关闭加载层
                    $scope.datas = data.rows;
                    $scope.status= data.status;//当前缴费状态
                    if(data.status==""||data.status==null){
                        $scope.status="没有您的缴费信息，若有疑问请联系管理员";//当前缴费状态
                    }
                    $scope.shouldPay= parseFloat(data.shouldPay);//缴费总金额
                    $scope.studentNum= data.rows[0].studentNum;//学号
                    $scope.studentName= data.rows[0].studentName;//姓名
                    $scope.realPay=parseFloat(data.rows[0].realPay);//已缴纳费用
                    $scope.pay_num=$scope.shouldPay-$scope.realPay;//当前应该缴纳费用
                    if(parseFloat($scope.pay_num)<0){
                        $scope.pay_num=0;
                    }
                    $scope.studentId=data.studentId;//学生Id
                    $scope.semester=data.semester;//当前学期
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
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
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
        $scope.search();
        $scope.list=[];
        $scope.item={};
        //首次加载菜单
        //先定义，后使用，否则出错误！！！
        //显示缴费页面
        $scope.pay=function (tr) {
            if($scope.status=="已缴费"){
                parent.pMsg("您已缴费");
                return;
            }else if($scope.status!="未缴费"){
                parent.pMsg("没有您的缴费信息，若有疑问请联系管理员");
                return;
            }
            loading();
            var date=new Date();
            var dateAsString = $filter('date')(date, "yyyy-MM-dd HH:mm:ss");
            remotecall("studentBookPay_loadTime",'',function (data) {
                closeLoading();
                if(data){
                    if(data[0].wordbookValue>dateAsString||data[1].wordbookValue<dateAsString){
                        parent.pMsg("暂时不能缴费: 请在自助缴费开放时间内进行缴费");
                        return;
                    }else{
                        $("#modal").show();
                        $("#table_detail").show();}
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
        };

//        假支付
//        缴费
        $scope.payNow=function () {
            loading();
            var date=new Date();
            var dateAsString = $filter('date')(date, "yyyy-MM-dd HH:mm:ss");
            remotecall("studentBookPay_loadTime","",function (data) {
                closeLoading();
                if(data){
                    if(data[0].wordbookValue>dateAsString||data[1].wordbookValue<dateAsString){
                        parent.pMsg("暂时不能缴费: 请在自助缴费开放时间内进行缴费");
                        return;
                    }else{
                        var payNum=$scope.pay_num;
                        var studentId=$scope.studentId;//学生Id
                        var semester=$scope.semester;//当前学期
                        var shouldPay=$scope.shouldPay;
                        if(payNum!=shouldPay){
                            parent.pMsg("您的缴费金额有误，请仔细核对，若有疑问请联系管理员");
                            return;
                        };
                        remotecall("studentBookPay_pay",{payNum:payNum,studentId:studentId,semester:semester,shouldPay:shouldPay},function (data) {
                            if(data===1){
                                closeLoading();//关闭加载层
                                parent.pMsg("支付失败:应缴费用与数据库不符，请联系管理员");
                            }else if(data){
                                closeLoading();//关闭加载层
                                parent.pMsg("支付成功,3s后跳转到首页");
                                $("#modal1").show();
                                $scope.search();
                                setTimeout(function () {
                                    $scope.cancel();
                                },3000);
                                $scope.isChange=true;
                            }else{
                                closeLoading();//关闭加载层
                                parent.pMsg("支付失败");
                            }
                        },function (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("加载数据库失败");
                            console.log(data);
                        });
                    }
                }
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
                console.log(data);
            });
        };
        //隐藏
        $scope.cancel=function () {
            $("#table_detail").hide();
            $("#modal").hide();
            $("#modal1").hide();
        };
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>


