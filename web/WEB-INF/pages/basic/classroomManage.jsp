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
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <style>
        .queryinput {
            border: 1px solid #c5add7;
            margin-right: 10px;
            height: 26px;
            width: 158px;
            padding: 0 5px;
        }

        .title .tablesearchbtn {
            width: 210px;
            margin-left: 0px;
            margin-right: 10px;
        }

    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<!--筛选条件按钮组-->
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：教室管理
<hr>
<div class="title">
    <span class="span_width">校区：</span>
    <select type="text" ng-model="campus" name="campus" class="queryinput" id="campusOne"
            ng-change="loadStudentClass()">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="grade in campusList" value="{{grade.wordbookValue}}">{{grade.wordbookValue}}</option>
    </select>

    <span class="span_width">教室类型：</span>
    <select type="text" ng-model="classRoomType" name="classRoomType" class="queryinput"
            id="classRoomTypeOne">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="option in classroomtypeList" value="{{option.crt_type}}"
                ng-bind="option.crt_type"></option>
    </select>

    <span class="span_width">教学楼：</span>
    <select type="text" ng-model="building" name="building" class="queryinput"
            id="buildingOne">
        <option value="" selected="selected">--请选择--</option>
        <option ng-repeat="option in buildingList" value="{{option.wordbookValue}}"
                ng-bind="option.wordbookValue"></option>
    </select>

</div>

<div class="title">
    <input class="tablesearchbtn" ng-model="classroomName" type="text" placeholder="请输入教室名称"/>
    <table-btn id="search" ng-click="loadDataFirst()">搜索</table-btn>
    <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png"/> 新建
    </table-btn>
    <table-btn class="top" ng-click="delete()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png"/>批量删除
    </table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-model="all"/>
        </th>
        <th>校区</th>
        <th>教学楼</th>
        <th>楼层</th>
        <th>教室号</th>
        <th>教室名称</th>
        <th>教室类型</th>
        <th>教室容量</th>
        <th>教室最小容积率</th>
        <th>教室面积</th>
        <th>使用状态</th>
        <th>使用单位</th>
        <th style="width: 160px;"></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input type="checkbox" ng-model="data.td0" name="classroomId" value="{{data.classroomId}}"/>
            </td>
            <td ng-bind="data.campus"></td>
            <td ng-bind="data.building"></td>
            <td ng-bind="data.floor"></td>
            <td ng-bind="data.classroomNum"></td>
            <td ng-bind="data.classroomName"></td>
            <td ng-bind="data.classroomType"></td>
            <td ng-bind="data.classroomCapacity"></td>
            <td ng-bind="data.minCapacityRate"></td>
            <td ng-bind="data.classroomArea"></td>
            <td ng-bind="data.classroomStatus"></td>
            <td ng-bind="data.classroomUnit"></td>
            <td>
                <table-btn ng-click="edit(data)">修改</table-btn>
                <b style="margin-right: 10px"></b>
                <table-btn ng-click="del(data)">删除</table-btn>
            </td>
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
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;"/>当前位置：教室管理 >
    新增/修改
    <hr>
    <form id="AddForm">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li>
                    <span>校区：</span>
                    <select ng-model="dataitem.campus" name="campus" class="forminput" id="campus">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options_campus" value="{{option.wordbookValue}}"
                                ng-bind="option.wordbookValue"></option>
                    </select>
                </li>
                <li>
                    <span>教学楼：</span>
                    <select ng-model="dataitem.building" name="building" class="forminput" id="building">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options_building" value="{{option.wordbookValue}}"
                                ng-bind="option.wordbookValue"></option>
                    </select>
                </li>
                <li><span>楼层：</span><input type="text" ng-model="dataitem.floor" name="floor" class="forminput"
                                           id="floor"/></li>
                <li><span>教室号：</span><input type="text" ng-model="dataitem.classroomNum" name="classroomNum"
                                            class="forminput" id="classroomNum"/></li>
                <li><span>教室名称：</span><input type="text" ng-model="dataitem.classroomName" name="classroomName"
                                             class="forminput" id="classroomName"/></li>
            </ul>
            <ul class="col-sm-3 col-xs-3">
                <li>
                    <span>教室类型：</span>
                    <select ng-model="dataitem.classroomType" name="classroomType" class="forminput" id="classroomType">
                        <option value="">--请选择--</option>
                        <option ng-repeat="option in options_classroomtype" value="{{option.crt_type}}"
                                ng-bind="option.crt_type"></option>
                    </select>
                </li>
                <li><span>教室容量：</span><input type="text" ng-model="dataitem.classroomCapacity" name="classroomCapacity"
                                             class="forminput" id="classroomCapacity"/></li>
                <li><span>最小容积率：</span><input type="text" placeholder="请输入0-1之间2位小数"
                                              ng-blur="validate(dataitem.minCapacityRate)"
                                              ng-model="dataitem.minCapacityRate" name="minCapacityRate"
                                              class="forminput" id="minCapacityRate"/></li>
                <li><span>教室面积：</span><input type="text" ng-model="dataitem.classroomArea" name="classroomArea"
                                             class="forminput" id="classroomArea"/></li>
                <li>
                    <span>使用状态：</span>
                    <select ng-model="dataitem.classroomStatus" name="classroomStatus" class="forminput"
                            id="classroomStatus">
                        <option value="">--请选择--</option>
                        <option value="使用">使用</option>
                        <option value="停用">停用</option>
                    </select>
                </li>
                <li><span>使用单位：</span><input type="text" ng-model="dataitem.classroomUnit" name="classroomUnit"
                                             class="forminput" id="classroomUnit"/></li>
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
    var app = angular.module('app', []).controller('ctrl', function ($scope) {
        var num = 0;
        $scope.all = false;
        $scope.datalist = [];
        $scope.dataitem = {};
        var loadcampus = false;
        var loadbuilding = false;
        var loadclassroom = false;
        //加载校区下拉
        remotecall("basic_classroom_loadwordbook_campus", '', function (data) {
            closeLoading();
            $scope.campusList = data;
            loadcampus = true;
        }, function (data) {
            closeLoading();
            parent.pMsg("加载校区失败");
        });
        //加载教学楼
        remotecall("basic_classroom_loadwordbook_building", '', function (data) {
            closeLoading();
            $scope.buildingList = data;
            loadbuilding = true;
        }, function (data) {
            closeLoading();
            parent.pMsg("加载教学楼失败");
        });
        //加载教师类型
        remotecall("basic_classroom_loadwordbook_classroomtype", '', function (data) {
            closeLoading();
            $scope.classroomtypeList = data;
            loadclassroom = true
        }, function (data) {
            closeLoading();//关闭加载层
            parent.pMsg("加载教室类型失败");
        });

        $scope.init = function () {
            if (loadcampus && loadbuilding && loadclassroom) {
                $scope.loadData();
            }
        }
        //点击搜索查询数据
        $scope.loadDataFirst = function () {
            pageNum=1;
            $scope.loadData();
        }

        //加载数据字典
        $scope.loadData = function () {
            loading();//加载
            remotecall("basic_classroom_load", {
                pageNum: pageNum,
                pageSize: pageSize,
                campus: $scope.campus,
                classroomType: $scope.classRoomType,
                building: $scope.building,
                classroomName: $scope.classroomName
            }, function (data) {
                closeLoading();
                $scope.datas = data.rows;
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

                for (i = 0; i < $scope.datas.length; i++) {
                    $scope.datas[i].td0 = false;
                }
                $scope.all = false;
                num = 0;
                //数据为0时提示
                if (data.total == 0) {
                    parent.pMsg("暂无数据");
                }
            }, function (data) {
                closeLoading();
                parent.pMsg("加载数据失败");
            });
            remotecall("basic_classroom_loadwordbook_campus", '', function (data) {
                closeLoading();
                $scope.options_campus = data;
            }, function (data) {
                closeLoading();
                parent.pMsg("加载校区失败");
            });
            remotecall("basic_classroom_loadwordbook_building", '', function (data) {
                closeLoading();
                $scope.options_building = data;
            }, function (data) {
                closeLoading();
                parent.pMsg("加载教学楼失败");
            });
            remotecall("basic_classroom_loadwordbook_classroomtype", '', function (data) {
                closeLoading();
                $scope.options_classroomtype = data;
            }, function (data) {
                closeLoading();//关闭加载层
                parent.pMsg("加载教室类型失败");
            });
            $scope.datalist = [];
            $scope.dataitem = {};
        };
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
        //首先加载
        $scope.init();
        //验证小数
        $scope.validate = function (val) {
            var pattern = /^0\.(0[1-9]|[0-9]{1,2})$/;
            if (!pattern.test(val)) {
                parent.pMsg("请输入0-1之间的2位小数");
                return false;
            }
            return true;
        }
        //批量删除功能
        $scope.delete = function () {
            //获取所选择的行
            loading();
            if ($("input[name='classroomId']:checked").length < 1) {
                closeLoading();//关闭加载层
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='classroomId']:checked").map(function (index, elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的所有内容吗？", function () {
                remotecall("basic_classroom_search", {deleteIds: deleteIds}, function (data) {
                    if (data.length > 0) {
                        closeLoading();//关闭加载层
                        parent.pConfirm("存在教室当前学期有排课信息，确认仍删除选中的教室吗", function () {
                            loading();
                            remotecall("basic_classroom_delete", {deleteIds: deleteIds}, function (data) {
                                if (data) {
                                    closeLoading();//关闭加载层
                                    parent.pMsg("批量删除成功");
                                    //重新加载菜单
                                    $scope.loadData();
                                    $scope.$apply();
                                } else {
                                    closeLoading();//关闭加载层
                                    parent.pMsg("批量删除失败");
                                }
                            }, function (data) {
                                closeLoading();//关闭加载层
                                parent.pMsg("批量删除请求失败");
                                console.log(data);
                            });
                        }, function () {
                            closeLoading();//关闭加载层
                        });
                        //重新加载菜单
                        $scope.loadData();
                        $scope.$apply();
                    } else {
                        remotecall("basic_classroom_delete", {deleteIds: deleteIds}, function (data) {
                            if (data) {
                                closeLoading();//关闭加载层
                                parent.pMsg("批量删除成功");
                                //重新加载菜单
                                $scope.loadData();
                                $scope.$apply();
                            } else {
                                closeLoading();//关闭加载层
                                parent.pMsg("批量删除失败");
                            }
                        }, function (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("批量删除请求失败");
                            console.log(data);
                        });
                    }
                }, function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("批量删除请求失败");
                    console.log(data);
                });

            }, function () {
                closeLoading();//关闭加载层
            });
        };
        //删除一个
        $scope.del = function (tr) {
            loading();
            var deleteIds = new Array();
            deleteIds[0] = tr.classroomId;
            var classroomId = tr.classroomId;
            parent.pConfirm("确认删除该条数据吗？", function () {
                remotecall("basic_classroom_search", {deleteIds: deleteIds}, function (data) {
                    if (data.length > 0) {
                        closeLoading();//关闭加载层
                        parent.pConfirm("该教室当前学期有排课信息，确认仍删除选中的教室吗", function () {
                            loading();
                            remotecall("basic_classroom_del", {classroomId: classroomId}, function (data) {
                                if (data) {
                                    closeLoading();//关闭加载层
                                    parent.pMsg("删除成功");
                                    //重新加载菜单
                                    $scope.loadData();
                                    $scope.$apply();
                                } else {
                                    closeLoading();//关闭加载层
                                    parent.pMsg("删除失败");
                                }
                            }, function (data) {
                                closeLoading();//关闭加载层
                                parent.pMsg("删除失败");
                                console.log(data);
                            });
                        }, function () {
                            $scope.loadData();
                            closeLoading();//关闭加载层
                        });
                        //重新加载菜单
                        $scope.loadData();
                        $scope.$apply();
                    } else {
                        remotecall("basic_classroom_del", {classroomId: classroomId}, function (data) {
                            if (data) {
                                closeLoading();//关闭加载层
                                parent.pMsg("删除成功");
                                //重新加载菜单
                                $scope.loadData();
                                $scope.$apply();
                            } else {
                                closeLoading();//关闭加载层
                                parent.pMsg("删除失败");
                            }
                        }, function (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("删除失败");
                            console.log(data);
                        });
                    }
                }, function (data) {
                    closeLoading();//关闭加载层
                    parent.pMsg("删除失败");
                    console.log(data);
                });
            }, function () {
                closeLoading();//关闭加载层
            });
        }
        //新建
        $scope.add = function () {
            add_edit = true;
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
            $scope.datalist = [];
            $scope.dataitem = {};
        };
        //修改
        $scope.edit = function (tr) {
            add_edit = false;
            $scope.datalist.push(tr);
            $scope.dataitem = $scope.datalist[0];
            $('.table-addform').addClass('a-show');
            $('.table-addform').removeClass('a-hide');
            $('table,.title,.pagingbox').hide();
            $('.table-addform').show();
        };
        //隐藏
        $scope.cancel = function () {
            $('.table-addform').addClass('a-hide');
            $('.table-addform').removeClass('a-show');
            setTimeout(function () {
                $('.table-addform').hide();
            }, 200);
            $('table,.title,.pagingbox').show();
            $scope.loadData();
            //清空选中
            $scope.datalist = [];
            $scope.datakitem = {};
            $scope.all = false;
            num = 0;
            for (i = 0; i < $scope.datas.length; i++) {
                $scope.datas[i].td0 = false
            }
        };
        //全选
        $scope.allfn = function () {
            if ($scope.all == false) {
                for (i = 0; i < $scope.datas.length; i++) {
                    $scope.datas[i].td0 = false
                }
                num = 0;
            } else {
                for (i = 0; i < $scope.datas.length; i++) {
                    $scope.datas[i].td0 = true
                }
                num = $scope.datas.length;
            }
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
                $scope.all = false;
                var index = $scope.datalist.indexOf(tr);
                if (index > -1) {
                    $scope.datalist.splice(index, 1);
                }
            }
            if (num == $scope.datas.length) {
                $scope.all = true;
            } else {
                $scope.all = false;
            }
        };
        //新建和修改，验证+保存
        $("#AddForm").validate({
            submitHandler: function (form) {
                var pattern = /^0\.(0[1-9]|[0-9]{1,2})$/;
                if (!pattern.test($scope.dataitem.minCapacityRate)) {
                    parent.pMsg("请输入0-1之间的2位小数");
                    return false;
                }
                loading();
                //验证通过,然后就保存
                if (add_edit) {
                    var parames = $("#AddForm").serializeObject();//参数
                    remotecallasync("basic_classroom_add", parames, function (data) {
                        if (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("添加成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $('#AddForm input').text("");
                            $scope.loadData();
                            $scope.$apply();
                        } else {
                            closeLoading();//关闭加载层
                            parent.pMsg("添加失败，可能原因:教室信息已存在(请确保校区、教学楼、楼层、教室号唯一)");
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层
                        parent.pMsg("数据库请求失败");
                    });
                } else {
                    remotecallasync("basic_classroom_edit", $scope.dataitem, function (data) {
                        if (data) {
                            closeLoading();//关闭加载层
                            parent.pMsg("修改成功");
                            //重新加载菜单
                            $('.table-addform').hide();
                            $('table,.title,.pagingbox').show();
                            $scope.loadData();
                            $scope.$apply();
                        } else {
                            closeLoading();//关闭加载层
                            parent.pMsg("修改失败，可能原因:教室信息已存在(请确保校区、教学楼、楼层、教室号唯一)");
                        }
                    }, function (data) {
                        closeLoading();//关闭加载层0
                        parent.pMsg("数据库请求失败");
                        console.log(data);
                    });
                }
            },
            rules: {
                campus: {
                    required: true
                },
                building: {
                    required: true
                },
                floor: {
                    required: true,
                    digits: true,
                    maxlength: 5
                },
                classroomNum: {
                    required: true,
                    maxlength: 20
                },
                classroomName: {
                    required: true,
                    maxlength: 20
                },
                classroomType: {
                    required: true
                },
                classroomCapacity: {
                    required: true,
                    digits: true,
                    maxlength: 5
                },
                classroomStatus: {
                    required: true
                },
                classroomUnit: {
                    required: true,
                    maxlength: 5
                },
                classroomArea: {
                    required: true,
                    max: 1000,
                    min: 0,
                    number: true
                },
                minCapacityRate: {
                    required: true
                }
            },
            messages: {
                campus: {
                    required: "请输入校区"
                },
                building: {
                    required: "请输入教学楼"
                },
                floor: {
                    required: "请输入教室楼层",
                    maxlength: "长度不超过5个字符",
                    digits: "输入值必须为整数"
                },
                classroomNum: {
                    required: "请输入教室号",
                    maxlength: "长度不超过20个字符"
                },
                classroomName: {
                    required: "请输入教室名称",
                    maxlength: "长度不超过20个字符"
                },
                classroomType: {
                    required: "请输入教室类型"
                },
                classroomCapacity: {
                    required: "请输入教室容量",
                    maxlength: "长度不超过5个字符",
                    digits: "输入值必须为整数"
                },
                classroomStatus: {
                    required: "请输入使用状态"
                },
                classroomUnit: {
                    required: "请输入使用单位",
                    maxlength: "长度不超过5个字符"
                },
                classroomArea: {
                    required: "请输入教室面积",
                    max: "请输入0--1000之间的整数",
                    min: "请输入0--1000之间的整数",
                    number: "请输入合法数字"
                },
                minCapacityRate: {
                    required: "请输入教室最小容积率"
                }
            },
            //重写showErrors
            showErrors: function (errorMap, errorList) {
                var msg = "";
                $.each(errorList, function (i, v) {
                    //msg += (v.message + "\r\n");
                    //在此处用了layer的方法,显示效果更美观
                    layer.tips(v.message, v.element, {time: 2000});
                    return false;
                });
            },
            /* 失去焦点时不验证 */
            onfocusout: false
        });
    });

</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript"
        charset="utf-8"></script>