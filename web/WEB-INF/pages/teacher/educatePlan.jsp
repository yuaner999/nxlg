<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/27
  Time: 8:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
    <style>
        .table-majorshow {
            position: absolute;
            top: 20%;
            left: 20% !important;
            z-index: 100;
            max-width: 1026px;
            min-width: 750px;
            padding: 70px;
            border: 1px solid #c5add7;
            background-color: #edeaf1;
        }

        .black {
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

        .showTitle {
            position: absolute;
            top: 0;
            line-height: 70px;
            left: 2%;
            color: #5c307d;
            font-weight: bold;
        }

        .myTextarea {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：培养计划
<hr>

<!--筛选条件按钮组-->
<div class="title">
    <table-btn ng-click="insert()" ng-if="Var==false"><img src="<%=request.getContextPath()%>/images/icon_import.png"/>上传培养计划
    </table-btn>
    <table-btn ng-click="getModel()" ng-if="Var==false"><img
            src="<%=request.getContextPath()%>/images/icon_download.jpg"/>下载模板
    </table-btn>
    <br/><br/>
    <span class="span_width">学&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;院：</span>
    <select type="text" ng-model="collegeName" name="collegeName" class="forminput"
            ng-change="loadMajorBox(this)">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="college in colleges" value="{{college.wordbookValue}}"
                ng-bind="college.wordbookValue"></option>
    </select>

    <span class="span_width">专&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;业：</span>
    <select type="text" ng-model="majorName" name="majorName" class="forminput">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="major in majors" value="{{major.majorName}}" ng-bind="major.majorName"></option>
    </select>

    <span class="span_width">年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;级：</span>
    <select type="text" ng-model="ep_grade" name="ep_grade" class="forminput"/>
    <option value="">--请选择--</option>
    <option ng-repeat="grade in grades" value="{{grade.wordbookValue}}">{{grade.wordbookValue}}</option>
    </select>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
</div>
<!--培养计划列表-->
<div class="tablebox" id="allInfo">
    <table class="table" style="table-layout:fixed">
        <thead>
        <th>学院</th>
        <th>专业</th>
        <th>年级</th>
        <th>已通过</th>
        <th>待审核</th>
        <th>未通过</th>
        <th style="width: 160px;"></th>
        <th style="width: 160px;"></th>
        </thead>
        <tbody>
        <tr ng-repeat="Info in allInfo">
            <td ng-bind="Info.majorCollege"></td>
            <td ng-bind="Info.majorName"></td>
            <td ng-bind="Info.gradeName"></td>
            <td ng-bind="Info.hascount"></td>
            <td ng-bind="Info.checkcount"></td>
            <td ng-bind="Info.uncheckcount"></td>
            <td>
                <table-btn ng-click="copyDetail(Info)">复制该计划</table-btn>
            </td>
            <td>
                <table-btn ng-click="showDetail(Info)">查看详情</table-btn>
            </td>
        </tr>
        </tbody>
    </table>
    <div class="pagingbox">
        <paging></paging>
    </div>
</div>

<div id="insert-form"
     style="display:none;width:400px;height:410px;padding:10px;position:absolute;border:3px #c5add7 solid; left:35%;top:15%;background-color:#ffffff;z-index: 10;">
    <div id="file_box" style="margin-bottom: 10px;margin-top: 10px;">
        <label>选择文件:</label>
        <input id="upfile" style="display: inline-block;width: 200px;" name="fileup" type="file"/>
        <img style="float: right; position:absolute; top:15px;right:15px"
             src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    </div>
    <div id="btn_box" style="margin-bottom: 10px;margin-top: 10px;">
        <a href="javascript:void(0)" ng-click="validFile()">验证文件</a>&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="javascript:void(0)" ng-click="uploadFile()">上传并导入</a>
    </div>
    <div id="result_box" style="margin-bottom: 10px;margin-top: 10px;">
        <label>操作结果:</label>
        <br>
        <div id="valid_result"
             style="display: inline-block;width: 375px;height: 235px;border: 2px solid #c5add7;overflow: auto"></div>
    </div>
    <p style="color:#ff0000;">（导入培养计划时请选用给定的模板）</p>
</div>
<div class="black"></div>
<%--查看详情--%>
<div class="table-majorshow" ng-show="majorshow" id="tanchuceng">
    <div class="showTitle">
        <span>提示：</span><span style="color: red">此操作请谨慎,确认学院/专业/年级信息的一致性后在进行此操作(此操作无法撤回)！！！</span>
    </div>
    <img style="float: right; position:absolute; top:15px;right:15px"
         src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    <div class="show">
        <!--这个位置显示学院信息-->
        <select style="margin-left: 10px; width: 150px" ng-model="selectedCollege" name="selectedCollege" id="selectedCollege" ng-change="change(this)">
            <option value="">请选择学院</option>
            <option ng-repeat="x in _sel_college" value="{{x.wordbookValue}}">{{x.wordbookValue}}</option>
        </select>
        <!--这个位置显示专业信息-->
        <select style="width: 150px" id="selectedMajor">
            <option value="">请选择专业</option>
            <option ng-repeat="y in _sel_major1" value="{{y.majorName}}">{{y.majorName}}</option>
        </select>
        <!--这个位置显示年级信息-->
        <select style="width: 150px" id="selectedGrade">
            <option value="">请选择学期</option>
            <option ng-repeat="z in _sel_grade1" value="{{z.wordbookValue}}">{{z.wordbookValue}}</option>
        </select>
    </div>
    <div style="float: right;">
        <button class="tablebtn" ng-click="copyCultivateInf()">确认</button>
    </div>
</div>
</body>
</html>
<script>
    var filter = 1;
    var add_edit = true;
    var now = (new Date()).getFullYear();
    var _copy_college_information = "";
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        $scope.Var = false;
        $scope.show = 2;
        $scope.teacher = false;
        $scope.checklist = [];
        $scope.checkitem = {};
        //加载学院
        remotecall("studentManage_loadCollege", '', function (data) {
            $scope.colleges = data;
            loadCollege = true;
        }, function (data) {
            parent.pMsg("加载学院失败,或连接数据库失败！");
        });
        //加载专业
        remotecall("studentManage_loadMajor", {}, function (data) {
            $scope.majors = data;
            loadMajor = true;
        }, function (data) {
            parent.pMsg("加载专业失败,或连接数据库失败！");
        });
        remotecall("teacher_educatePlan_loadgrade",'',function (data) {
            $scope.grades = data;
        },function (data) {
            parent.pMsg("加载年级失败,或连接数据库失败！");
        });

        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum = 1;
            $scope.loadData();
        }
        //加载数据
        $scope.loadData = function () {
            $scope.show = 2;
            $scope.checklist = [];
            $scope.checkitem = {};
            $("#allInfo,.title,.pagingbox,.table-nav").show();
            $("#course,.table-addform,#insert-form").hide();
            if (!$scope.Var) {
                $(".table-nav li:first").addClass("sele");
                $(".table-nav li:last").removeClass("sele");
            } else {
                $(".table-nav li:last").addClass("sele");
                $(".table-nav li:first").removeClass("sele");
            }
            loading();//加载
            remotecallasync("teacher_educatePlan_load_count", {
                filter: filter,
                pageNum: pageNum,
                pageSize: pageSize,
                college: $scope.collegeName,
                major: $scope.majorName,
                grade: $scope.ep_grade
            }, function (data) {
                closeLoading();
                if (data.result == false) {
                    showmsgpc(data.errormessage);
                    return;
                }
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
                $scope.$apply();

                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });

            remotecall("isteacher", '', function (data) {
                closeLoading();//关闭加载层
                if (data == "管理员") {
                    $scope.teacher = true;
                }
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("暂无数据");
            });

            //调用新接口，查询学院信息
            remotecallasync("teacher_educatePlan_college_major_grade", {"v": "_college"}, function (data) {
                if (data.result) {
                    $scope._sel_college = data._select_college1;
                } else {
                    layer.msg(data.errormessage)
                }
            }, function (data) {
            });

            $scope.change = function(col){
                loading();
                var selcol = $scope.selectedCollege;
                remotecall("teacher_educatePlan_college_major", {selcol: selcol}, function (data) {
                    closeLoading();//关闭加载层
                    $scope._sel_major1 = data._sel_major;
                }, function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("加载专业失败,或连接数据库失败！");
                });
            }

            //查询年级信息
            remotecallasync("teacher_educatePlan_college_grade", {"v": "_grade"}, function (data) {
                if (data.result) {
                    $scope._sel_grade1 = data._sel_grade;
                } else {
                    layer.msg(data.errormessage)
                }
            }, function (data) {
            });

        }
        $scope.loadData();
        //根据选择的学院加载相应学院下的专业
        $scope.loadMajorBox = function (obj) {
            loading();
            var majorCollege = $scope.collegeName;
            remotecall("studentManage_loadMajor", {majorCollege: majorCollege}, function (data) {
                closeLoading();//关闭加载层
                $scope.majors = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载专业失败,或连接数据库失败！");
            });
        };
        //右侧菜单栏
        $scope.showDetail = function (Info) {
            location.href = 'educatePlanMajor.form?college=' + encodeURI(Info.majorCollege) + "&major=" + encodeURI(Info.majorName) + "&grade=" + encodeURI(Info.gradeName);
        }
        //右侧菜单栏
        $scope.dofilter = function (str) {
            pageNum = 1;
            if (str == 0) {//审核列表
                $scope.Var = true;
            } else if (str == 1) {
                $scope.Var = false;
            }
            filter = str;
            $scope.loadData();
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
                    $scope.loadData();

            }
        }

        //导入
        $scope.insert = function () {
            $('#insert-form,.black').show();
        }
        $scope.close = function () {
            $('#insert-form,.black').hide();
            $("#valid_result,#file").empty();

        }
        //     验证文件
        $scope.validFile = function () {
            if (!$("#upfile").val()) {
                layer.msg("请选择文件！");
                return;
            }
            loading();
            $.ajaxFileUpload({
                url: "<%=request.getContextPath()%>/EducatePlanupload/validate.form", //用于文件上传的服务器端请求地址
                secureuri: false, //一般设置为false
                fileElementId: "upfile", //文件上传空间的id属性
                dataType: 'String', //返回值类型 一般设置为String
                success: function (data, status)  //服务器成功响应处理函数
                {
                    closeLoading();//关闭加载层
                    $scope.showResult(data);
                    console.log(data.errormessage);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    closeLoading();//关闭加载层
                    layer.msg("上传文件失败，请重新上传");
                }
            });
        }
        /**
         * 上传文件
         */
        $scope.uploadFile = function () {
            if (!$("#upfile").val()) {
                layer.msg("请选择文件！");
                return;
            }
            loading();
            $.ajaxFileUpload({
                url: "<%=request.getContextPath()%>/EducatePlanupload/EducatePlan.form", //用于文件上传的服务器端请求地址
                secureuri: false, //一般设置为false
                fileElementId: "upfile", //文件上传空间的id属性
                dataType: 'String', //返回值类型 一般设置为String
                success: function (data, status)  //服务器成功响应处理函数
                {
                    closeLoading();//关闭加载层
                    $scope.showResult(data);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    closeLoading();//关闭加载层
                    layer.msg("上传文件失败，请重新上传");
                }
            });
        }
        /*
         * user ：songjian
         * time ：2017/9/14
         * newFeatures : 显示一个新的弹出层，加载（多选按钮的形式）当前学院已通过审核的培养计划。
         */
        $scope.copyDetail = function (copyPlan) {
//            $("#tanchuceng").show();
            var majorCollege = copyPlan.majorCollege;
            var majorName = copyPlan.majorName;
            var gradeName = copyPlan.gradeName;
            loading();
            $scope.majorshow = true;

            remotecallasync("teacher_educatePlan_load_count_copy", {
                "v": "_copy",
                "majorCollege": majorCollege,
                "majorName": majorName,
                "gradeName": gradeName
            }, function (data) {
                //如果有返回信息，则执行后面的操作
                if (data.result) {
                    //如果返回真,取得要被复制的值
                    _copy_college_information = data._copyInf;
                    $("#tanchuceng").show();
                } else {
                    //如果返回假
                    layer.msg(data.errormessage);
                    $("#tanchuceng").hide();
                    $(".black").hide();
                    $scope.majorshow = false;
                }
            }, function (data) {
            });

            $(".black,table").show();
            closeLoading();//关闭加载层
        };

        //确认按钮点击事件，点击后批量更新培养数据
        $scope.copyCultivateInf = function () {

            //获取三个文本框的值a=学院，b=专业，c=年级
            var a = $("#selectedCollege option:selected").text();
            var b = $("#selectedMajor option:selected").text();
            var c = $("#selectedGrade option:selected").text();

            if (a == "请选择学院" || a == "" || a == undefined) {
                layer.msg("学院信息不能为空！");
                return;
            }
            if (b == "请选择专业" || b == "" || b == undefined) {
                layer.msg("专业信息不能为空！");
                return;
            }
            if (c == "请选择学期" || c == "" || c == undefined) {
                layer.msg("年级信息不能为空！");
                return;
            }
            //调用接口，进行批量更新，更新前判断一下
            parent.pConfirm("要覆盖重复的内容吗？", function () {
                loading();
                $("#tanchuceng").hide();
                $(".black").hide();
                remotecallasync("teacher_educatePlan_load_count_copy_finally", {
                    "a": a,
                    "b": b,
                    "c": c,
                    "_copy_college_information": _copy_college_information
                }, function (data) {

                    setTimeout(layer.msg("数据过多,请耐心等候..."), 10000);

                    if (data.errormessage == "success") {
                        closeLoading();
                        layer.msg("刷新页面后查看效果")
                    } else {
                        layer.msg("出错了！");
                        closeLoading();
                    }
                }, function (data) {
                    closeLoading();
                });
            }, function (data) {
            });
        }
        //关闭加载层
        $scope.close = function () {
            $("#insert-form").hide();
            $(".pagingbox").show();
            $(".black").hide();
            $scope.majorshow = false;
        }
        /*
         * 上传文件后显示服务器返回的信息
         * @param data
         */
        $scope.showResult = function (data) {
            $("#valid_result").html("");
            //去除返回字符串的  <pre style="word-wrap: break-word; white-space: pre-wrap;"> 标签
            var str = data.substring(data.indexOf('>') + 1, data.lastIndexOf('<'));
            var s = eval("(" + str + ")");
            var str = s.msg + "<br>";
            if (s.data) {
                $.each(s.data, function () {
                    if (this.data) {
                        str += "&nbsp;&nbsp;" + this.msg + "<br>";
                        $.each(this.data, function () {
                            str += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + this + "<br>";
                        })
                    } else {
                        str += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + this + "<br>";
                    }
                });
            }
            $("#valid_result").html(str);
        }
        //下载模版文件
        $scope.getModel = function () {
            try {

                var elemIF = document.createElement("iframe");
                elemIF.src = "../../files/educatePlan.xls";
                elemIF.style.display = "none";
                document.body.appendChild(elemIF);
            } catch (e) {
            }
        }

    });
    function getSearchStr2(obj) {
        pageNum = 1;
        searchStr = $(obj).val();
    }
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchCourse").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>