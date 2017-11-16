<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/5/2
  Time: 15:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：培养计划审核
<hr>
<div class="title">
    <table-btn ng-click="previous()">返回上层</table-btn>
</div>
<table-nav>
    <li ng-click="dofilter(0)" class="sele">待审核培养计划</li>
    <li ng-click="dofilter(1)">现有培养计划</li>
    <li ng-click="dofilter(2)">未通过列表</li>
</table-nav>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-if="show==0" ng-click="pass()"><img src="<%=request.getContextPath()%>/images/tablepass.png"/>通过
    </table-btn>
    <span class="span_width">平&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;台：</span>
    <select type="text" ng-model="terraceName" name="terraceName" class="forminput" id="terraceName"
            >
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="terrace in terraces" value="{{terrace.terraceName}}" ng-bind="terrace.terraceName"></option>
    </select>
    <span class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;期：</span>
    <select type="text" ng-model="ep_term" name="ep_term" class="forminput" id="ep_term">
        <option value="" selected="selected">--请选择--</option>
        <option value="第一学期">第一学期</option>
        <option value="第二学期">第二学期</option>
    </select>
    <span ng-if="show==0" class="span_width">审核类别：</span>
    <select  type="text" ng-model="$parent.checktype" name="checktype" class="forminput" id="checktype" ng-if="show==0"/>
    <option value="">--请选择--</option>
    <option value="新增">新增</option>
    <option value="修改">修改</option>
    <option value="删除">删除</option>
    </select>
    <input class="tablesearchbtn" type="text" placeholder="请输入课程名称进行查询..." onkeyup="getSearchStr(this)"/>
    <table-btn  id="search" ng-click="loadDataSecond()">搜索</table-btn>

</div>
<!--平台课程列表-->
<div class="tablebox" id="allInfo">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th ng-if="Var" class="checked">
            <button><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></button>
        </th>
        <th>年级</th>
        <th>学院</th>
        <th>专业</th>
        <th>学期</th>
        <th>课程</th>
        <th>课程类别一</th>
        <th>培养平台</th>
        <th>考核方式</th>
        <th>学分</th>
        <th>周时</th>
        <th>备注</th>
        <th>审核状态</th>
        <th ng-if="Var">审核类别</th>
        <th ng-if="Var&&show=='0'">操作</th>
        <th ng-if="Var&&show=='2'">未通过原因</th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-if="Var" class="thischecked" ng-click="thischecked(Info)">
                <input type="checkbox" ng-model="Info.td0" name="ep_id" value="{{Info.ep_id}}"/>
            </td>
            <td ng-bind="Info.ep_grade"></td>
            <td ng-bind="Info.ep_college"></td>
            <td ng-bind="Info.ep_major"></td>
            <td ng-bind="Info.ep_term"></td>
            <td ng-bind="Info.chineseName"></td>
            <td ng-bind="Info.courseCategory_1"></td>
            <td ng-bind="Info.ep_terrace"></td>
            <td ng-bind="Info.ep_checkway"></td>
            <td ng-bind="Info.totalCredit"></td>
            <td ng-bind="Info.ep_week"></td>
            <td ng-bind="Info.ep_note"></td>
            <td ng-bind="Info.ep_checkStatus"></td>
            <td ng-if="Var" ng-bind="Info.ep_checkType"></td>
            <td ng-if="Var&&show=='0'">
                <table-btn ng-if="show==0" ng-click="reject(Info.ep_id)"><img
                        src="<%=request.getContextPath()%>/images/tablereject.png"/>拒绝
                </table-btn>
            <td  ng-if="Var&&show=='2'" ng-bind="Info.ep_refuseReason" style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;width:100%;"
                 ng-click="ReasonDetail(Info.ep_refuseReason,$index)" class="Ar"></td>
            </td>
        </tr>
        <tr>
            <td colspan={{colspans}}>总学分：{{totalCredit}}</td>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
</body>
</html>
<script>
    var college = decodeURI(GetQueryString("college"));
    var major = decodeURI(GetQueryString("major"));
    var grade = decodeURI(GetQueryString("grade"));
    var ep_id = null;
    var num = 0;
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        $scope.Var = true;
        $scope.show = 0;
        $scope.colspans = 15;//设置总学分行跨列
        $scope.all = false;
        $scope.datalist = [];
        $scope.dataitem = {};
        //加载数据

        //点击搜索查询数据
        $scope.loadDataSecond = function () {
            pageNum=1;
            $scope.loadData();
        }

        $scope.previous = function () {
            location.href = 'educatePlanCheck.form';
        }
        $scope.loadData = function () {
            loading();//加载
            remotecall("teacher_educatePlanCheck_load", {
                filter: $scope.show,
                pageNum: pageNum,
                pageSize: pageSize,
                searchStr: searchStr,
                college: college,
                major: major,
                grade: grade,
                terraceName: $scope.terraceName,
                ep_term: $scope.ep_term
            }, function (data) {
                $scope.allInfo = data.result.rows;
                $scope.totalCredit = data.totalCredit[0].totalCredit;
                data.total = data.result.total;
                closeLoading();//关闭加载层
                pageCount = parseInt((data.total - 1) / pageSize) + 1;//页码总数
                // 分页逻辑开始
                $scope.allPage = [];
                $scope.sliPage = [];
                for (var i = 1; i <= Math.ceil(data.total / pageSize); i++) {
                    $scope.allPage.push(i);
                }
                for (var i = 0; i < $scope.allPage.length; i += pageShow) {
                    $scope.sliPage.push($scope.allPage.slice(i, i + pageShow));
                }
                $scope.TotalPageCount = $scope.allPage.length;
                $scope.TotalDataCount = data.total;
                $scope.pages = $scope.sliPage[Math.ceil(pageNum / pageShow) - 1];
                $('.paging li').removeClass('sele');
                if (pageNum % pageShow == 0 && pageNum != 0) {
                    var dx = pageShow - 1;
                } else {
                    var dx = pageNum % pageShow - 1;
                }
                setTimeout(function () {
                    $('.paging li').eq(dx).addClass('sele')
                }, 100);
                num = 0;
                $scope.all = false;
                for (i = 0; i < $scope.allInfo.length; i++) {
                    $scope.allInfo[i].td0 = false;
                }
                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载数据失败");
            });
        }
        $scope.loadDataSecond();
        //加载平台信息
        remotecall("terraceBox_loading", '', function (data) {
            $scope.terraces = data;
            loadTerrace = true;
        }, function (data) {
            parent.pMsg("加载数据失败");
        });
        //分页
        $scope.gotoPage = function (pn, i) {
            if (pn == -1) {//上一页
                pn = pageNum - 1;
            }
            if (pn == -2) {//下一页
                pn = pageNum + 1;
            }
            if (pn == -3) {//最后一页
                pn = pageCount;
            }
            if (pn < 1 || pn > pageCount) {//页码不正确
                return;
            } else {
                pageNum = pn;//改变当前页
                //重新加载菜单

                    $scope.loadData();

            }
        };
        $scope.dofilter = function (str) {
            pageNum = 1;
            if (str == 1) {
                $scope.Var = false;
                $scope.show = 1;
                $scope.colspans = 12;//设置总学分行跨列
            } else if (str == 0) {
                $scope.Var = true;
                $scope.show = 0;
                $scope.colspans = 15;//设置总学分行跨列
            }
            else if (str == 2) {
                $scope.Var = true;
                $scope.show = 2;
                $scope.colspans = 15;//设置总学分行跨列
            }
            $scope.loadData();

        }
        //理由详情
        $scope.ReasonDetail=function(data,i){
            if(data==null||data==""||data.length<=5)return;
            $(".Ar:eq("+i+")").addClass("RRR");
            layer.tips(data,".RRR" ,{
                tips: [4, '#c5add7'],
                time: 3000
            });
            $(".Ar:eq("+i+")").removeClass("RRR");
        }
        //通过功能
        $scope.pass = function () {
            var checknum = $scope.datalist.length;
            if (checknum < 1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else {
                //$scope.dataitem=$scope.datalist[0];
                parent.pConfirm("确认通过选中的所有内容吗？", function () {
                    loading();
                    remotecallasync("teacher_educatePlanCheck_pass", {passIds: $scope.datalist}, function (data) {
                        closeLoading();
                        if (data) {
                            parent.pMsg("审核通过");
                            //重新加载菜单
                            $scope.Cdetail($scope.item);
                            $scope.$apply();
                        } else {
                            parent.pMsg("审核不通过");
                        }
                    }, function (data) {
                        closeLoading();
                        parent.pMsg("审核请求失败");
                    });
                }, function () {
                });
            }
        };
        //批量拒绝
        $scope.refuse = function () {
            var checknum = $scope.datalist.length;
            if (checknum < 1) {
                parent.pMsg("请选择一条记录");
                return;
            }
            else {
                //$scope.dataitem=$scope.datalist[0];
                parent.pConfirm("确认驳回选中的所有内容吗？", function () {
                    loading();
                    remotecallasync("teacher_educatePlanCheck_refuse", {passIds: $scope.datalist}, function (data) {
                        closeLoading();
                        if (data) {
                            parent.pMsg("驳回完成");
                            //重新加载菜单
                            $scope.Cdetail($scope.item);
                            $scope.$apply();
                        } else {
                            parent.pMsg("驳回失败");
                        }
                    }, function (data) {
                        closeLoading();
                        parent.pMsg("数据库连接异常，请联系管理员解决");
                    });
                }, function () {
                });
            }
        };
        //拒绝
        $scope.reject = function (id) {
            var tc_id1 = id;
            var checknum = $scope.datalist.length;
            $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").show();
            $(".layui-layer-shade").hide();
            $scope.dataitem = $scope.datalist[0];
            layer.prompt({
                title: '未通过原因',
                formType: 2,
                value: ' ', //初始时的值，默认空字符
            }, function (value) {
                if (value) {
                    loading();
                    remotecallasync("teacher_educatePlanCheck_reject", {ep_id: tc_id1, reason: value}, function (data) {
                        closeLoading();
                        if (data) {
                            $(".layui-layer-shade,.layui-layer,.layui-anim,.layui-layer-dialog,.layui-layer-prompt").hide();
                            $scope.Cdetail($scope.item);
                            $scope.$apply();
                        } else {
                            parent.pMsg("驳回理由不能为空");
                        }
                    }, function (data) {
                        closeLoading();
                        parent.pMsg("数据库请求失败");
                    });
                    return false;
                }
            });
        };
        //check事件
        $scope.thischecked = function (tr) {
            if (tr.td0 == false || tr.td0 == null) {
                num++;
                tr.td0 = true;
                $scope.datalist.push(tr);
            } else {
                num--;
                tr.td0 = false;
                var index = $scope.datalist.indexOf(tr);
                if (index > -1) {
                    $scope.datalist.splice(index, 1);
                }
            }
            if (num == $scope.allInfo.length) {
                $scope.all = true;
            } else {
                $scope.all = false;
            }
        };
        //全选
        $scope.allfn = function () {
            if ($scope.all == false) {
                $scope.all = true;
                for (i = 0; i < $scope.allInfo.length; i++) {
                    $scope.allInfo[i].td0 = true;
                    $scope.datalist.push($scope.allInfo[i]);
                }
                num = $scope.allInfo.length;
            } else {
                $scope.all = false;
                for (i = 0; i < $scope.allInfo.length; i++) {
                    $scope.allInfo[i].td0 = false;
                    $scope.datalist = [];
                    $scope.dataitem = {};
                }
                num = 0;
            }
        };
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>