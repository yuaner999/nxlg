<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2017-04-19
  Time: 15:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
</head>
<style>
    <%--查看详情--%>
    .table-show{
        display: none;
        position: absolute;
        top: 20%;
        left: 14% !important;
        z-index: 8;
        max-width: 900px;
        min-width: 900px;
        padding: 70px 10px 0px;
        border: 1px solid #c5add7;
        background-color: #edeaf1;
    }
    .table-score{
        display: none;
        position: absolute;
        top: 30%;
        left: 35% !important;
        z-index: 10;
        width: 500px;
        min-width: 300px;
        padding: 70px 10px 10px;
        border: 1px solid #c5add7;
        background-color: #ffffff;
    }
    .scorecol{
        margin-left:10px;
    }
    .scorecol li{
        margin-bottom:5px;
    }
    .scorecol li span{
        margin-right:5px;
        width:230px;
        display: inline-block;
     }
    .bttn{
        margin-left: 26%;
        margin-top:30px;
        border: 1px solid #c5add7;
        height: 26px;
        background: #edeaf1;
    }
    .show ul{
        width: 30%;
        padding-left: 40px;
        margin-left: 100px;
        float: left;
    }
    .show li{
        margin: 10px 60px;
        display: inline-flex;
    }
    .show li span{
        min-width: 105px;
        display: inline-block;
        margin-right: 20px;
    }
    .show li>span:first-child,.tips li>span:first-child{
        color:#5c307d;
        font-family: "微软雅黑";
    }
    .black{
        position: fixed;
        top: 0;
        left: 0;
        height: 100%;
        width: 100%;
        background: #000;
        opacity: 0.3;
        filter: alpha(opacity=0);
        z-index: 7;
        display: none;
    }
    .black1{
        position: fixed;
        top: 0;
        left: 0;
        height: 100%;
        width: 100%;
        background: #000;
        opacity: 0.5;
        filter: alpha(opacity=0.2);
        z-index: 9;
        display: none;
    }
    .tips ul{
        float:left;
        margin:20px 0px 10px 30px;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：专业平台学分设置
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <span  class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;院：</span>
    <select  type="text" ng-model="college" name="college" class="forminput" id="college">
        <option value="">--请选择--</option>
        <option ng-repeat="option in majorCollege" value="{{option.wordbookValue}}"
                ng-bind="option.wordbookValue"></option>
    </select>
    <span  class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;科：</span>
    <select  type="text" ng-model="subjectOne" name="subjectOne" class="forminput" id="subjectOne">
        <option value="">--请选择--</option>
        <option ng-repeat="option in subjects" value="{{option.wordbookValue}}"
                ng-bind="option.wordbookValue"></option>
    </select>
    <input class="tablesearchbtn" type="text" ng-model="majorName" name="majorName" placeholder="请输入专业名称"/>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th>院(系)/部</th>
        <th>专业名称</th>
        <th>所属学科</th>
        <th>培养层次</th>
        <th>学制</th>
        <th>专业状态</th>
        <th>审核状态</th>
        <th>设置学分</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td ng-bind="data.majorCollege"></td>
            <td ng-bind="data.majorName"></td>
            <td ng-bind="data.subject"></td>
            <td ng-bind="data.level"></td>
            <td ng-bind="data.length"></td>
            <td ng-bind="data.majorStatus"></td>
            <td ng-bind="data.checkStatus"></td>
            <td ng-click="thischecked(data)"><table-btn>设置</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
<%--查看详情--%>
<div class="table-show">
    <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <table class="table">
        <thead>
        <th>平台名称</th>
        <%--<th>最少选修学分/学期</th>--%>
        <%--<th>最少选修课程门数/学期</th>--%>
        <%--<th>最多选修学分/学期</th>--%>
        <%--<th>最多选修课程门数/学期</th>--%>
        <th>该平台总学分</th>
        <th>在该平台需修满学分</th>
        <th>本专业在该平台需修满学分</th>
        <th>其他专业在该平台修满学分</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="terrace in terraces">
            <td ng-bind="terrace.terraceName"></td>
            <td ng-bind="terrace.scoreall"></td>
            <td ng-bind="terrace.scoretotal"></td>
            <td ng-bind="terrace.scorethis"></td>
            <td ng-bind="terrace.scoreother"></td>
            <td ng-click="thischecked1(terrace)"><table-btn>设置</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<%--学分设置页面--%>
<div class="table-score">
    <form id="MenuForm">
        <div class="row">
            <ul class="scorecol">
                <li><span>该平台总学分：</span><input type="text"  ng-model="score.scoreall" name="scoreall" class="forminput" id="scoreall"/></li>
                <li><span>在该平台需修满学分：</span><input type="text"  ng-model="score.scoretotal" name="scoretotal" class="forminput" id="scoretotal"/></li>
                <li><span>本专业在该平台需修满学分：</span><input type="text" ng-model="score.scorethis" name="scorethis" class="forminput" id="scorethis"/></li>
                <li><span>其他专业在该平台修满学分：</span><input type="text"  ng-model="score.scoreother" name="scoreother" class="forminput" id="scoreother"/></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
<div class="black"></div>
<div class="black1"></div>
</body>
</html>
<script>
    var searchStr1="";//加载了两个列表
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        $scope.getOtheritem = {};
        //加载学院下拉框（查询条件）
        remotecall("majorCollege_load", '', function (data) {
            closeLoading();//关闭加载层
            $scope.majorCollege = data;
        }, function (data) {
            closeLoading();//关闭加载层
            parent.pMsg("加载学院失败");
        });
        //加载学科下拉框（查询条件）
        remotecall("subject_load", '', function (data) {
            closeLoading();//关闭加载层
            $scope.subjects = data;
        }, function (data) {
            closeLoading();//关闭加载层
            parent.pMsg("加载学科失败");
        });

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadData();
        }

        //加载数据
        $scope.load = function (){
            $scope.datalist=[];
            $scope.dataitem={};
            $scope.terracelist=[];
            $scope.terraceitem={};
        }
        $scope.loadData = function () {
            loading();//加载
            remotecall("teacher_majorList_load",{
                pageNum:pageNum,
                pageSize:pageSize,
                searchStr:searchStr,
                majorCollege: $scope.college,
                majorName: $scope.majorName,
                subject: $scope.subjectOne
            },function (data) {
                closeLoading();
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
                closeLoading();
                parent.pMsg("加载数据失败" );
            });
            $scope.load();
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
                $scope.loadData();
            }
        };
        //首次加载
        //先定义，后使用，否则出错误！！！
        $scope.loadData();
        //check事件
        $scope.thischecked = function  (tr) {
            $scope.datalist.push(tr);
            $scope.dataitem=$scope.datalist[0];
            $(".table-show,.black").show();
            loading();
            remotecall("teacher_majorScore_load",$scope.dataitem,function (data) {
                closeLoading();//关闭加载层
                if(data){
                    $scope.terraces = data;
                }else{parent.pMsg("没有平台信息");}
            },function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        };
        //check事件
        $scope.thischecked1 = function  (tr) {
            $scope.terracelist.push(tr);
            $scope.terraceitem=$scope.terracelist[0];
            $(".table-score,.black1").show();
           // $scope.scoreload();
            $scope.score=tr;
        };
        //学分加载
//        $scope.scoreload=function(){
//            $scope.terraceitem.majorId=$scope.dataitem.majorId;
//            loading();
//            remotecall("teacher_majorScore_load",$scope.terraceitem,function (data) {
//                closeLoading();//关闭加载层
//                $scope.score= data[0];
//                $(".table-score,.black1").show();
//            },function (data) {
//                closeLoading();//关闭加载层
//                parent.pMsg("数据库请求失败");
//            });
//        }
        //关闭
        $scope.close=function () {
            $('.table-show,.black,.black1').hide();
            $scope.load();
        }
        //取消
        $scope.cancel=function () {
            $('.table-show,.black,.black1,.table-score').hide();
            $scope.load();
        }
        //确定
        $("#MenuForm").validate({
            submitHandler:function(form){
                if(parseInt($scope.score.scorethis)+parseInt($scope.score.scoreother)-parseInt($scope.score.scoretotal)!=0){
                    parent.pMsg("第三个学分加第四个学分等于第二个学分");
                    return;
                }
                $scope.terraceitem.majorId=$scope.dataitem.majorId;
                $scope.terraceitem.scoreall=$scope.score.scoreall;
                $scope.terraceitem.scoretotal=$scope.score.scoretotal;
                $scope.terraceitem.scorethis=$scope.score.scorethis;
                $scope.terraceitem.scoreother=$scope.score.scoreother;
                loading();
                remotecallasync("teacher_majorScore_edit",$scope.terraceitem,function (data) {
                    closeLoading();//关闭加载层
                    if(data){
                        parent.pMsg("设置成功");
                        $('.table-show,.black,.black1,.table-score').hide();
                        $('#MenuForm input').text("");
                        $scope.loadData();
                        $scope.$apply();
                    }else {
                        parent.pMsg("设置失败");
                    }
                },function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("数据库请求失败");
                });
            },
            rules:{
                scoreall:{
                    required:true,
                    maxlength:45,
                    digits: true
                },
                scoretotal:{
                    required:true,
                    maxlength:45,
                    digits: true
                },
                scorethis:{
                    required:true,
                    maxlength:45,
                    digits: true
                },
                scoreother:{
                    required:true,
                    maxlength:45,
                    digits: true
                }
            },
            messages:{
                scoreall:{
                    required:"必填项",
                    maxlength:"长度不超过45个字符",
                    digits: "只能输入数字"
                },
                scoretotal:{
                    required:"必填项",
                    maxlength:"长度不超过45个字符",
                    digits: "只能输入数字"
                },
                scorethis:{
                    required:"必填项",
                    maxlength:"长度不超过45个字符",
                    digits: "只能输入数字"
                },
                scoreother:{
                    required:"必填项",
                    maxlength:"长度不超过45个字符",
                    digits: "只能输入数字"
                }
            },
            //重写showErrors
            showErrors: function (errorMap, errorList) {
                $.each(errorList, function (i, v) {
                    layer.tips(v.message, v.element, { time: 2000 });
                    return false;
                });
            },
            onfocusout: false
        });
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>