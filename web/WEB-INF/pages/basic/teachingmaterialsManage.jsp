<%--
  Created by IntelliJ IDEA.
  User: NEU
  Date: 2017/4/21
  Time: 16:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
    <style>
        #MenuForm span{ width:135px;}
        .table>tbody>tr>td{max-width: 200px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis}
        .table_detail{height: 410px;width:506px;position: absolute;border: 3px solid #c5add7;}
        .span_detail{font-weight: bold;line-height: 3em;width:75px!important;margin-left: 69px;display: inline-block;}
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
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教材管理
<hr>
<!--筛选条件按钮组-->
<div class="title">
    <table-btn class="top" ng-click="add()"><img src="<%=request.getContextPath()%>/images/tableadd_07.png" /> 新建</table-btn>
    <table-btn class="top" ng-click="deletes()"><img src="<%=request.getContextPath()%>/images/tabledelete_07.png" />批量删除</table-btn>
    <input class="tablesearchbtn" type="text" placeholder="请输入教材名称进行搜索..." onkeyup="getSearchStr(this)" />
    <table-btn id="search" ng-click="search()">搜索</table-btn>
    <table-btn ng-click="insert()"><img src="<%=request.getContextPath()%>/images/icon_import.png" />导入教材信息</table-btn>
    <table-btn ng-click="getModel()"><img src="<%=request.getContextPath()%>/images/icon_download.jpg" />下载模板</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th class="checked"><input ng-click="allfn()" id="all" style="width: 100%;" type="checkbox" ng-checked="all"/></th>
        <th>教材名称</th>
        <th>出版社</th>
        <th>版次</th>
        <th>书号</th>
        <th>价格</th>
        <th></th>
        </thead>
        <tbody>
        <tr ng-repeat="data in datas">
            <td class="thischecked" ng-click="thischecked(data)">
                <input id="tchecked" type="checkbox" ng-model="data.td0" name="tmId" value="{{data.tmId}}" ng-checked="all"/>
            </td>
            <td><img src="<%=request.getContextPath()%>/images/details.png" style="cursor: pointer" ng-click="checked(data);checkdetail()"/>
                {{data.name}}
            </td>
            <%--<td ng-bind="data.name"></td>--%>
            <td ng-bind="data.press"></td>
            <td ng-bind="data.edition"></td>
            <td ng-bind="data.booknumber"></td>
            <td ng-bind="data.price"></td>
            <td><table-btn ng-click="edit(data)">修改</table-btn>&nbsp&nbsp<table-btn ng-click="delete(data)">删除</table-btn></td>
        </tr>
        </tbody>
    </table>
</div>
<!--导入教材信息-->
<div id="insert-form"  title="批量导入" style="z-index:99999;display:none;width:400px;height:410px;padding:10px;position:absolute;border:3px #c5add7 solid; left:35%;top:15%;background-color:#ffffff">
    <div id="file_box" style="margin-bottom: 10px;margin-top: 10px;">
        <label>选择文件:</label>
        <input id="upfile" style="display: inline-block;width: 200px;" name="fileup" type="file"/>
        <img style="float: right; position:absolute; top:15px;right:15px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    </div>
    <div id="btn_box" style="margin-bottom: 10px;margin-top: 10px;">
        <a href="javascript:void(0)"  ng-click="validFile()">验证文件</a>&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="javascript:void(0)"  ng-click="uploadFile()">上传并导入</a>
    </div>
    <div id="result_box" style="margin-bottom: 10px;margin-top: 10px;">
        <label>操作结果:</label>
        <br>
        <div id="valid_result"  style="display: inline-block;width: 375px;height: 235px;border: 2px solid #c5add7;overflow: auto"></div>
    </div>
    <p style="color:#ff0000;">（导入教材信息时请选用给定的模板）</p>
    <%--批量导入对话框的按钮--%>
    <div>
        <a href="javascript:void(0)" style="margin-left: 335px;color: white;background: #c5add7;position: absolute;
        padding-left: 5px;padding-top: 1;width: 40px;height: 22px;text-decoration: none;" ng-click="close()">关闭</a>
    </div>
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
    <img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：教材管理 > 新增/修改
    <hr>
    <form id="MenuForm">
        <div class="row">
            <ul class="col-sm-3 col-xs-3">
                <li style="display: none"><span>教材Id：</span><input type="text"  ng-model="item.tmId" name="tmId" class="forminput" id="tmId"/></li>
                <li><span>教材名称：</span><input type="text"  ng-model="item.name" name="name" class="forminput" id="name"/></li>
                <li><span>出版社：</span><input type="text" ng-model="item.press" name="press" class="forminput" id="press"/></li>
                <li><span>版次：</span><input type="text"  ng-model="item.edition" name="edition" class="forminput" id="edition"/></li>
                <li><span>书号：</span><input type="text" ng-model="item.booknumber" name="booknumber" class="forminput" id="booknumber"/></li>
                <li><span>价格：</span><input type="text" ng-model="item.price" name="price" class="forminput" id="price"/></li>
            </ul>
        </div>
        <div class="text-center" style="margin-top: 30px;">
            <table-btn class="confirm" id="confirm">确定</table-btn>
            <span class="tablebtn confirm" ng-click="cancel()">取消</span>
        </div>
    </form>
</div>
<%--查看详情--%>
<div id="table_detail"  title="查看详情" style="display:none;width:540px;height:350px;padding:10px;position:absolute;border:2px #c5add7 solid; left:35%;top:15%;background-color:#ffffff">
    <div id="table_box1" style="margin-bottom: 10px;margin-top: 10px;">
        <label style="color: rgb(197, 173, 215);">查看详情</label>
        <img style="float: right; position:absolute; top:15px;right:14px" src="<%=request.getContextPath()%>/images/windowclose_03.jpg" ng-click="close()">
    </div>
    <div id="table_box" style="margin-bottom: 10px;margin-top: 10px;">
        <div id="valid_results"  style="display: inline-block;width: 513px;height: 0px;border: 2px solid #c5add7;overflow: auto"></div>
    </div>
    <div id="table_det" style="margin-top: 20px">
        <ul>
            <li><span class="span_detail">教材名称：</span><span style="width: 333px;display: inline-flex;" ng-bind="dataitem.name"/></li>
            <li><span class="span_detail">出版社：</span><span type="text"  style="width: 333px;display: inline-flex;" ng-bind="dataitem.press"/></li>
            <li><span class="span_detail">版次：</span><span type="text"   style="width: 333px;display: inline-flex;" ng-bind="dataitem.edition"/></li>
            <li><span class="span_detail">书号：</span><span type="text"  style="width: 333px;display: inline-flex;" ng-bind="dataitem.booknumber"/></li>
            <li><span class="span_detail">价格：</span><span type="text" style="width: 333px;display: inline-flex;"  ng-bind="dataitem.price"/></li>
        </ul>
    </div>
</div>
</body>
</html>
<script>
    var add_edit = true;//true为新建，false为修改
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        //加载教材信息
        $scope.search = function () {
            loading();//加载
            remotecall("teachingmaterialsManage_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr},function (data) {
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
        $scope.insert=function () {
            $("#modal").show();
            $('#insert-form').show();
        };
        $scope.close=function () {
            $("#insert-form").hide();
            $("#modal").hide();
            $("#valid_result,#file").empty();
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

        //查看详情
        $scope.checkdetail=function () {
            $("#modal").show();
            $scope.dataitem={};
            $("#table_detail").show();
            $scope.dataitem=$scope.list[0];
        };
        $scope.close=function () {
            $("#modal").hide();
            $('#insert-form').hide();
            $("#table_detail").hide();
        };
        //删除功能
        $scope.delete=function (tr) {
            loading();
            var deleteIds=new Array(tr.tmId);
            parent.pConfirm("确认删除该条数据吗？",function () {
                remotecall("teachingmaterialsManage_delete",{deleteIds:deleteIds},function (data) {
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
            if($("input[name='tmId']:checked").length<1){
                parent.pMsg("请选择一条记录");
                return;
            }
            var deleteIds = $("input[name='tmId']:checked").map(function(index,elem) {
                return $(elem).val();
            }).get();//需要删除的Id
            parent.pConfirm("确认删除选中的"+$("input[name='tmId']:checked").length+"条内容吗？",function () {
                loading();
                remotecall("teachingmaterialsManage_delete",{deleteIds:deleteIds},function (data) {
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
                tr.td0 = true;
                $scope.list.push(tr);
                if($scope.list.length==$scope.datas.length){
                    $scope.all =true;
                    document.getElementById("all").checked=true;
//                    $('#all').attr("checked",true);
                }
            }else{
                tr.td0 = false;
                $('#all').attr("checked",false);
                var index = $scope.list.indexOf(tr);
                if (index > -1) {
                    $scope.list.splice(index, 1);
                }
            }
        };
        //全选
        $scope.allfn = function  () {
            if ($scope.all == false) {
                $scope.all =true;
                for (i = 0; i < $scope.datas.length; i++) {
                    $scope.datas[i].td0 = true
                    $scope.list.push($scope.datas[i]);
                }
            } else {
                $scope.all =false;
                for (i = 0; i < $scope.datas.length; i++) {
                    $scope.datas[i].td0 = false;
                    $scope.list = [];
                }
            }
        };
        //查看详情check事件
        $scope.checked = function  (tr) {
            $scope.all =true;
            $scope.allfn();
            tr.td0 = true;
            $scope.list.splice(0, 1,tr);
        };
        //修改
        $scope.edit= function (tr) {
            add_edit=false;

                $scope.item=tr;
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

        };
        //新建和修改，验证+保存
        $("#MenuForm").validate({
            submitHandler:function(form){
                loading();
                //验证通过,然后就保存
                if(add_edit){
                    var parames = $("#MenuForm").serializeObject();//参数
                    remotecall("teachingmaterialsManage_add",parames,function (data) {
                       if(data===1){
                           closeLoading();
                           parent.pMsg("添加失败：该教材信息已存在");
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
                    remotecallasync("teachingmaterialsManage_edit",parames,function (data) {
                        if(data===1){
                            closeLoading();
                            parent.pMsg("修改失败：教材信息和其它教材信息重复");
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
                name:{
                    required:true
                },
                press:{
                    required:true
                },
                edition:{
                    required:true
                },
                booknumber:{
                    required:true
                },
                price:{
                    required:true,
                    number:true,
                    min:0
                }
            },
            messages:{
                name:{
                    required:"请输入教材名称"
                },
                press:{
                    required:"请输入出版社"
                },
                edition:{
                    required:"请输入版次"
                },
                booknumber:{
                    required:"请输入书号"
                },
                price:{
                    required:"请输入价格",
                    number:"请输入正确的价格格式",
                    min:"请输入正确的价格"
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

        //     验证文件
        $scope.validFile=function () {
            if(!$("#upfile").val()){
                layer.msg("请选择文件！");
                return;

            }
            $.ajaxFileUpload({
                url: "<%=request.getContextPath()%>/TeachingMaterials/validate.form", //用于文件上传的服务器端请求地址
                secureuri: false, //一般设置为false
                fileElementId: "upfile", //文件上传空间的id属性
                dataType: 'String', //返回值类型 一般设置为String
                success: function (data, status)  //服务器成功响应处理函数
                {
                    $scope.showResult(data);
                    console.log(data.errormessage);
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    layer.msg("上传文件失败，请重新上传");
                }
            });
        }
        /**
         * 上传文件
         */
        $scope.uploadFile=function () {
            if(!$("#upfile").val()){
                layer.msg("请选择文件！");
                return;
            }
            loading();
            $.ajaxFileUpload({
                url: "<%=request.getContextPath()%>/TeachingMaterials/TeachingMaterials_info.form", //用于文件上传的服务器端请求地址
                secureuri: false, //一般设置为false
                fileElementId: "upfile", //文件上传空间的id属性
                dataType: 'String', //返回值类型 一般设置为String
                success: function (data, status)  //服务器成功响应处理函数
                {
                    //console.log(data);
                    closeLoading();//关闭加载层
                    $scope.showResult(data);
                    $scope.search();
                },
                error: function (data, status, e)//服务器响应失败处理函数
                {
                    closeLoading();//关闭加载层
                    layer.msg("上传文件失败，请重新上传");
                }
            });
        }

        /*
         * 上传文件后显示服务器返回的信息
         * @param data
         */
        $scope.showResult=function (data){
            $("#valid_result").html("");
            //去除返回字符串的  <pre style="word-wrap: break-word; white-space: pre-wrap;"> 标签
            var str=data.substring(data.indexOf('>')+1,data.lastIndexOf('<'));
            var s= eval("("+str+")");
            var str=s.msg+"<br>";
            if(s.data){
                $.each(s.data,function(){
                    if(this.data){
                        str+="&nbsp;&nbsp;"+this.msg+"<br>";
                        $.each(this.data,function(){
                            str+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+this+"<br>";
                        })
                    }else{
                        str+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+this+"<br>";
                    }
                });
            }
            $("#valid_result").html(str);
        }

        //下载模版文件
        $scope.getModel=function () {
            try{
                var elemIF = document.createElement("iframe");
                elemIF.src = "../../files/TeachingMaterials.xls";
                elemIF.style.display = "none";
                document.body.appendChild(elemIF);
            }catch(e){
            }
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
