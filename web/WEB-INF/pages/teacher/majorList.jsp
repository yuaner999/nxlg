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
    .table-show {
        display: none;
        position: absolute;
        top: 20%;
        left: 20% !important;
        z-index: 100;
        max-width: 1026px;
        min-width: 750px;
        padding-top: 70px;
        border: 1px solid #c5add7;
        background-color: #edeaf1;
    }

    .bttn {
        margin-left: 26%;
        margin-top: 30px;
        border: 1px solid #c5add7;
        height: 26px;
        background: #edeaf1;
    }

    .show ul {
        width: 30%;
        padding-left: 40px;
        margin-left: 100px;
        float: left;
    }

    .show li {
        margin: 10px 60px;
        display: inline-flex;
    }

    .show li span {
        min-width: 190px;
        display: inline-block;
    }

    .show li > span:first-child, .tips li > span:first-child {
        color: #5c307d;
        font-family: "微软雅黑";
    }

    .black {
        position: fixed;
        top: 0;
        left: 0;
        height: 100%;
        width: 100%;
        background: #000;
        opacity: 0.5;
        filter: alpha(opacity=0);
        z-index: 10;
        display: none;
    }

    .tips ul {
        float: left;
        margin: 20px 0px 10px 60px;
    }

    /*窗口样式*/
    .windowbox {
        display: none;
    }

    .window {
        padding-top: 25px;
        position: absolute;
        top: 20%;
        left: 20% !important;
        z-index: 100;
        max-width: 1026px;
        min-width: 750px;
        border: 1px solid #c5add7;
        background-color: #edeaf1;
    }

    .window > ul {
        padding: 15px;
    }

    .window > img {
        float: right;
        position: absolute;
        top: 25px;
        right: 15px;
    }

    .window li {
        margin: 10px 0;
        color: #5c307d;
    }

    .window {
    }

    #detailTotal {
        padding: 15px;
        color: #5c307d;
        font-weight: bold;
        font-size: 16px;
    }

    .table-nav li {
        width: 160px;
    }

    .title .tablesearchbtn {
        margin-left: 0px;
        margin-right: 12px;
        width: 240px;
        vertical-align: middle;
    }
</style>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：专业列表
<hr>
<!--筛选条件按钮组-->
<table-nav ng-show="show=='3'">
    <li ng-click="dofilter(0)" class="sele">必修课学分完成情况</li>
    <li ng-click="dofilter(1)">必修课人数统计</li>
</table-nav>

<div class="title">
    <span ng-show="show=='1'" class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;院：</span>
    <select ng-show="show=='1'" type="text" ng-model="college" name="college" class="forminput" id="college">
        <option value="">--请选择--</option>
        <option ng-repeat="option in majorCollege" value="{{option.wordbookValue}}"
                ng-bind="option.wordbookValue"></option>
    </select>

    <span ng-show="show=='1'" class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;科：</span>
    <select ng-show="show=='1'" type="text" ng-model="subjectOne" name="subjectOne" class="forminput" id="subjectOne">
        <option value="">--请选择--</option>
        <option ng-repeat="option in subjects" value="{{option.wordbookValue}}"
                ng-bind="option.wordbookValue"></option>
    </select>

    <input class="tablesearchbtn" type="text" ng-model="majorName" name="majorName" placeholder="请输入专业名称"/>
    <%--<input class="tablesearchbtn" ng-show="show=='1'" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>--%>
    <table-btn id="search" ng-if="show=='1'" ng-click="loadDataFirst()">搜索</table-btn>
    <table-btn ng-if="show=='2'" ng-click="previous()">返回</table-btn>
    <table-btn ng-if="show=='4'" ng-click="previous()">返回</table-btn>
    <table-btn ng-if="show=='3'" ng-click="previous1()">返回</table-btn>
    <span ng-if="show=='3'">您所在的<span ng-bind="majorscores.studentGrade"></span>级,<span ng-show="filter=='0'"> 必修课学分完成情况如下</span><span
            ng-show="filter=='1'"> 必修课人数统计如下</span></span>


    <%--&lt;%&ndash;<input class="tablesearchbtn" ng-show="show=='1'" type="text" placeholder="请输入想要搜索的内容" onkeyup="getSearchStr(this)"/>&ndash;%&gt;--%>
    <%--<table-btn id="search" ng-if="show=='1'" ng-click="loadDataFirst()">搜索</table-btn>--%>
    <%--<table-btn ng-if="show=='2'" ng-click="previous()">返回</table-btn>--%>
    <%--<table-btn ng-if="show=='4'" ng-click="previous()">返回</table-btn>--%>
    <%--<table-btn ng-if="show=='3'" ng-click="previous1()">返回</table-btn>--%>
    <%--<span ng-if="show=='3'">您所在的<span ng-bind="majorscores.studentGrade"></span>级,<span ng-show="filter=='0'"> 必修课学分完成情况如下</span><span ng-show="filter=='1'"> 必修课人数统计如下</span></span>--%>
</div>

<div class="title">

</div>

<!--表格-->
<div class="tablebox" ng-if="show=='1'">
    <table class="table">
        <thead>
        <th>院(系)/部</th>
        <th>专业名称</th>
        <th>所属学科</th>
        <th>培养层次</th>
        <th>学制</th>
        <th>专业状态</th>
        <%--<th>审核状态</th>--%>
        <th>详情</th>
        <th>培养计划</th>
        <th>查看自己所修学分</th>
        <th>查看其它同学学分情况</th>
        <th>查看学分完成情况</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td ng-bind="data.majorCollege"></td>
            <td ng-bind="data.majorName"></td>
            <td ng-bind="data.subject"></td>
            <td ng-bind="data.level"></td>
            <td ng-bind="data.length"></td>
            <td ng-bind="data.majorStatus"></td>
            <%--&lt;%&ndash;<td ng-bind="data.checkStatus"></td>&ndash;%&gt;--%>
            <%--<td>--%>
                <%--<table-btn ng-click="detail(data)">详情</table-btn>--%>
                <%--&nbsp;--%>
                <%--<table-btn ng-click="educatePlan(data,true)">培养计划</table-btn>--%>
                <%--&nbsp;--%>
                <%--<table-btn ng-click="getScore(data)">查看自己所修学分</table-btn>--%>
                <%--&nbsp;--%>
                <%--<table-btn ng-click="getOther(data)">查看其它同学学分情况</table-btn>--%>
                <%--&nbsp;--%>
                <%--<table-btn ng-click="getfinish(data)">查看学分完成情况</table-btn>--%>
            <%--</td>--%>
            <td><table-btn ng-click="detail(data)">详情</table-btn></td>
            <td><table-btn ng-click="educatePlan(data,true)">培养计划</table-btn></td>
            <td><table-btn ng-click="getScore(data)">查看自己所修学分</table-btn></td>
            <td><table-btn ng-click="getOther(data)">查看其它同学学分情况</table-btn></td>
            <td><table-btn ng-click="getfinish(data)">查看学分完成情况</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<div class="tablebox" ng-show="show=='3'">
    <table class="table" ng-show="filter=='0'">
        <thead>
        <th>10%以下</th>
        <th>10%-59%</th>
        <th>60%-99%</th>
        <th>100%</th>
        </thead>
        <tbody>
        <tr>
            <td ng-bind="majorscores.sum1"></td>
            <td ng-bind="majorscores.sum2"></td>
            <td ng-bind="majorscores.sum3"></td>
            <td ng-bind="majorscores.sum4"></td>
        </tr>
        </tbody>
    </table>
    <table class="table" ng-show="filter=='1'">
        <thead>
        <th>课程名</th>
        <th>课程代码</th>
        <th>课程类别</th>
        <th>已修人数</th>
        <th>未修人数</th>
        </thead>
        <tbody>
        <tr ng-repeat="majorclass in majorclasss">
            <td ng-bind="majorclass.chineseName"></td>
            <td ng-bind="majorclass.courseCode"></td>
            <td ng-bind="majorclass.courseCategory_1"></td>
            <td ng-bind="majorclass.people0"></td>
            <td ng-bind="majorclass.people1"></td>
        </tr>
        </tbody>
    </table>
</div>
<%--培养计划--%>
<div class="tablebox" id="educatePlan" ng-if="show=='2'">
    <table class="table">
        <thead>
        <th>年级</th>
        <th>学院</th>
        <th>专业</th>
        <th>学期</th>
        <th>课程</th>
        <th>课程类别一</th>
        <th>培养平台</th>
        <th>考核方式</th>
        <th>周时</th>
        <th>备注</th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-bind="Info.ep_grade"></td>
            <td ng-bind="Info.ep_college"></td>
            <td ng-bind="Info.ep_major"></td>
            <td ng-bind="Info.ep_term"></td>
            <td ng-bind="Info.chineseName"></td>
            <td ng-bind="Info.courseCategory_1"></td>
            <td ng-bind="Info.ep_terrace"></td>
            <td ng-bind="Info.ep_checkway"></td>
            <td ng-bind="Info.ep_week"></td>
            <td ng-bind="Info.ep_note"></td>
        </tr>
        </tbody>
    </table>
</div>

<%--查看详情--%>
<div class="table-show" id="detail">
    <img style="float: right; position:absolute; top:15px;right:15px"
         src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <ul>
            <li><span>院(系)/部：</span><span ng-bind="dataitem.majorCollege">计算机院</span></li>
            <li><span>国标专业个数：</span><span ng-bind="dataitem.internationalNum">10</span></li>
            <li><span>国标专业代码：</span><span ng-bind="dataitem.internationalCode">1001</span></li>
            <li><span>专业代码：</span><span ng-bind="dataitem.majorCode">0110</span></li>
            <li><span>专业名称：</span><span ng-bind="dataitem.majorName">技术</span></li>
            <li><span>培养对象：</span><span ng-bind="dataitem.trainingobjects">技术</span></li>
            <li><span>本届选修人数：</span><span ng-bind="dataitem.majorName.length">技术</span></li>
        </ul>
        <ul>
            <li><span>所属学科：</span><span ng-bind="dataitem.subject">工</span></li>
            <li><span>培养层次：</span><span ng-bind="dataitem.level">本</span></li>
            <li><span>学制：</span><span ng-bind="dataitem.length">4</span></li>
            <li><span>设置年份：</span><span ng-bind="dataitem.settingYear">2000</span></li>
            <li><span>专业状态：</span><span ng-bind="dataitem.majorStatus">启</span></li>
            <li><span>专业名称：</span><span ng-bind="dataitem.majorName">技术</span></li>
            <li><span>专业简介：</span><span ng-bind="dataitem.introduction">技术</span></li>
        </ul>
    </div>
    <table-btn class="bttn" ng-click="modify()">选修该专业</table-btn>
    <table-btn class="bttn" ng-click="other()">辅修该专业</table-btn>
    <div class="tips">
        <ul>
            <li><span>选修时间：</span><span ng-bind="startTime"></span>—<span ng-bind="endTime"></span></li>
        </ul>
        <ul>
            <li><span>辅修时间：</span><span ng-bind="startT"></span>—<span ng-bind="endT"></span></li>
        </ul>
    </div>
</div>
<%-- 查看自己获得的学分--%>
<div id="getScore" class="table-show">
    <div class="show">
        <img style="float: right; position:absolute; top:15px;right:15px"
             src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
        <ul ng-repeat="data in datasssss ">
            <li><span>专业名称：</span><span ng-bind="copyValue">计算机院</span></li>
            <li><span>平台名称：</span><span ng-bind="data.rterraceName">10</span></li>
            <li>
                <span>已修总学分：</span><span ng-bind="data.totalscore">10</span>
            </li>
            <li>
                <table-btn class="bttn" ng-click="getSCoreDetails(data)" style="margin-left: 0%">查看详细</table-btn>
            </li>
        </ul>

    </div>
</div>
<%-- 查看其它同学获得的学分弹出框--%>
<div ng-if="show=='4'" id="getother" class="tablebox">
    <table class="table">
        <thead>
        <th>同学名称：</th>
        <th>修得总学分：</th>
        </thead>
        <tbody>
        <tr ng-repeat="data in otherStu">
            <td ng-bind="data.stuName"></td>
            <td ng-bind="data.totalscore"></td>
        </tr>
        </tbody>
    </table>
</div>
<%-- 查看自己获得的学分详细页面--%>
<div id="getScoreDetail" class="table-show">
    <div class="show">
        <img style="float: right; position:absolute; top:25px;right:15px"
             src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="closeSele()">
        <div id="detailTotal"></div>
        <ul ng-repeat="data in majorDatasss ">
            <li><span>课程名称：</span><span ng-bind="data.chineseName">计算机院</span></li>
            <li><span>学分：</span><span ng-bind="data.totalCredit">10</span></li>
            <li><span>学期：</span><span ng-bind="data.term">10</span></li>
        </ul>

    </div>
</div>
<div class="pagingbox">
    <paging></paging>
</div>
<div class="black"></div>
</body>
</html>
<script>
    var oldPageNum = 1;
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        $scope.show = 1;
        $scope.filter = 0;
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
            pageNum = 1;
            $scope.loadData();
        }

        //加载数据
        $scope.loadData = function () {
            $scope.show = 1;
            loading();//加载
            remotecall("teacher_majorList_load", {
                pageNum: pageNum,
                pageSize: pageSize,
                majorCollege: $scope.college,
                majorName: $scope.majorName,
                subject: $scope.subjectOne,
                majorStatus: $scope.majorStatus
            }, function (data) {
                closeLoading();
                $scope.datas = data.rows;
                for (var i = 0; i < $scope.datas.length; i++) {
                    if ($scope.datas[i].introduction == "" || $scope.datas[i].introduction == null || $scope.datas[i].introduction == undefined) {
                        $scope.datas[i].introduction = "暂无简介";
                    }
                    if ($scope.datas[i].trainingobjects == "" || $scope.datas[i].trainingobjects == null || $scope.datas[i].trainingobjects == undefined) {
                        $scope.datas[i].trainingobjects = "培养对象暂无";
                    }
                }
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
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("专业列表加载失败");
                console.log(data);
            });
            //选修、辅修时间
            remotecall("teacher_selectMajorTime_start1", '', function (data) {
                closeLoading();
                $scope.startTime = data[0].wordbookValue;
            }, function (data) {
                closeLoading();
                parent.pMsg("加载选修开始时间失败");
            });
            remotecall("teacher_selectMajorTime_end1", '', function (data) {
                closeLoading();
                $scope.endTime = data[0].wordbookValue;
            }, function (data) {
                closeLoading();
                parent.pMsg("加载选修结束时间失败");
            });
            remotecall("teacher_selectMajorTime_start2", '', function (data) {
                closeLoading();
                $scope.startT = data[0].wordbookValue;
            }, function (data) {
                closeLoading();
                parent.pMsg("加载辅修开始时间失败");
            });
            remotecall("teacher_selectMajorTime_end2", '', function (data) {
                $scope.endT = data[0].wordbookValue;
                closeLoading();//关闭加载层
            }, function (data) {
                parent.pMsg("加载辅修结束时间失败");
                closeLoading();//关闭加载层
            });
            $scope.datalist = [];
            $scope.dataitem = {};
        };

        $scope.datalist = [];
        $scope.dataitem = {};
        $scope.item = {};
        $scope.loadData();
        //选修
        $scope.modify = function () {
            var startTime = ConvertDateFromString($scope.startTime);
            var endTime = ConvertDateFromString($scope.endTime);
            var checknum = $scope.datalist.length;
            if (checknum != 1) {
                parent.pMsg("请选择一条记录");
                return;
            } else if (startTime > nowTime() || endTime < nowTime()) {
                parent.pMsg("请注意选修时间");
                return;
            } else if ($scope.dataitem.majorStatus == "停用") {
                parent.pMsg("该专业已停用");
                return;
            } else {
                $scope.dataitem = $scope.datalist[0];
                parent.pConfirm("确认更换自己的主专业吗？", function () {
                    loading();
                    remotecall("teacher_majorList_modify", $scope.dataitem, function (data) {
                        closeLoading();//关闭加载层
                        if (data) {
                            if (!data.message) {
                                parent.pMsg("选修该专业成功");
                            } else {
                                parent.pMsg(data.message);
                            }
                        } else {
                            parent.pMsg("选修该专业失败");
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                }, function () {
                });
            }
        }
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
                //重新加载用户信息
                if ($scope.show == 1) {
                    $scope.loadData();
                } else if ($scope.show == 4) {
                    $scope.getOther($scope.getOtheritem);
                } else {
                    $scope.educatePlan($scope.item);
                }
            }
        };
        //辅修
        $scope.other = function () {
            var startT = ConvertDateFromString($scope.startT);
            var endT = ConvertDateFromString($scope.endT);
            var checknum = $scope.datalist.length;
            if (checknum != 1) {
                parent.pMsg("请选择一条记录");
                return;
            } else if (startT > nowTime() || endT < nowTime()) {
                parent.pMsg("请注意辅修时间");
                return;
            } else if ($scope.dataitem.majorStatus == "停用") {
                parent.pMsg("该专业已停用");
                return;
            } else {
                $scope.dataitem = $scope.datalist[0];
                parent.pConfirm("确认辅修该专业吗？", function () {
                    loading();
                    remotecall("teacher_majorList_other", $scope.dataitem, function (data) {
                        closeLoading();//关闭加载层
                        if (data) {
                            if (!data.message) {
                                parent.pMsg("辅修该专业成功");
                            } else {
                                parent.pMsg(data.message);
                            }
                        } else {
                            parent.pMsg("辅修该专业失败");
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                }, function () {
                });
            }
        }
        //查看详情
        $scope.detail = function (tr) {
            $scope.datalist = [];
            $scope.dataitem = {};
            $scope.datalist.push(tr);
            $scope.dataitem = $scope.datalist[0];
            $("#detail,.black").show();
        }
        //培养计划
        $scope.educatePlan = function (tr, isfirst) {
            if (isfirst) {
                oldPageNum = pageNum;
                pageNum = 1;
            }
            $scope.show = 2;
            $scope.datalist = [];
            $scope.dataitem = {};
            $scope.datalist.push(tr);
            $scope.dataitem = $scope.datalist[0];
            $scope.item = {};
            $scope.item = $scope.dataitem;
            loading();
            remotecall("teacher_majorList_loadeducatePlan", {
                ep_college: $scope.dataitem.majorCollege,
                ep_major: $scope.dataitem.majorName,
                pageNum: pageNum,
                pageSize: pageSize
            }, function (data) {
                closeLoading();
                $scope.allInfo = data.rows;
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
                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
        }
        //关闭
        $scope.close = function () {
            $('.table-show,.black').hide();
            $scope.datalist = [];
            $scope.dataitem = {};
        }
        //返回
        $scope.previous = function () {
//            searchStr="";
            pageNum = oldPageNum;
            $scope.loadData();
            $scope.datalist = [];
            $scope.dataitem = {};
        }
        $scope.previous1 = function () {
            $(".pagingbox").show();
            $scope.loadData();
            $scope.datalist = [];
            $scope.dataitem = {};
        }
        // 查询获得的学分
        $scope.getScore = function (data) {
            $.ajax({
                url: baseurl + "stu_getscore.form",
                type: "POST",
                data: {"majorId": data.majorId},
                success: function (datas) {
                    if (datas.length >= 1) {
                        $scope.datasssss = datas;
                        $scope.copyValue = data.majorName;
                        $scope.$apply();
                        $("#getScore,.black").show();
                    } else {
                        layer.msg("该专业没有获得学分");
                    }
                },
                dataType: 'json'
            });
        }
        $scope.getSCoreDetails = function (data) {
            //debugger;
            $.ajax({
                url: baseurl + "stu_getscoredetail.form",
                type: "POST",
                data: {"majorId": data.majorId, "terraceId": data.terraceId},
                success: function (datas) {
                    $scope.majorDatasss = datas;
                    $scope.$apply();
                    $("#getScoreDetail,.black").show();
                    $("#getScore").hide();
                    $("#detailTotal").html("共修学分：" + data.totalscore);

                },
                dataType: 'json'
            });
        }
        $scope.closeSele = function () {
            $("#getScoreDetail").css("display", "none");
            $('#getScoreDetail,.black').hide();
        }
        // 查看其它学生
        $scope.getOther = function (datas) {
            /*$.ajax({
             url:baseurl+"getotherscore.form",
             type:"POST",
             data:{majorId:datas.majorId},
             success: function (data){
             if(data.length == 0 ){
             layer.msg("没有其它学生修该专业");
             }else{
             $scope.otherStu = data ;
             $scope.$apply();
             $("#getother,.black").show();
             }
             },
             dataType:'json'
             });*/
            oldPageNum = pageNum;
            pagenum = 1;
            remotecall("getotherscore", {
                majorId: datas.majorId,
                pageNum: pageNum,
                pageSize: pageSize
            }, function (data) {
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                } else {
                    $scope.getOtheritem = datas;
                    $scope.show = 4;
                    $scope.otherStu = data.rows;

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

                }
            }, function (data) {
                parent.pMsg("查询数据库失败");
                console.log(data);
            });
        }
        $scope.getfinish = function (data) {
            $scope.show = 3;
            $(".pagingbox").hide();
            loading();
            remotecall("basic_majorscore_load", {
                ep_college: data.majorCollege,
                ep_major: data.majorName
            }, function (data) {
                closeLoading();
                $scope.majorscores = data[0];
                /* $scope.$apply();*/
                if (data.length == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
            loading();
            remotecall("basic_classmajor_load", {
                ep_college: data.majorCollege,
                ep_major: data.majorName
            }, function (data) {
                closeLoading();
                $scope.majorclasss = data;
                if (data.length == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
            //$scope.$apply();
        }
        $scope.dofilter = function (str) {
            $scope.filter = str;
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>