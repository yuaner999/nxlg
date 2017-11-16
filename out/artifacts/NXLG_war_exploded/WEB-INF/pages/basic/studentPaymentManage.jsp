<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--
  Created by IntelliJ IDEA.
  User: zcy
  Date: 2017/5/23
  Time: 14:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../commons/common.jsp"%><!--单引js-->
    <script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
    <style>
        #modal .mask {
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            background-color: #000;
            opacity: 0.5;
        }
        #modal {
            position: fixed;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            z-index: 999;
            display:none
        }
        #insert-form {
            z-index: 9999;
        }
    </style>
</head>
<body class="scope" ng-app="app" ng-controller="ctrl">
<img src="<%=request.getContextPath()%>/images/location.jpg" style="width:24px; margin-right: 8px;" />当前位置：学生缴费管理
<hr>
<div class="title">
    <span >学院名称：</span>
    <select  ng-model="para.collegeName" name="collegeName" class="forminput" id="collegeName" >
        <option value=" " >--请选择--</option>
        <option ng-repeat="college in colleges" value="{{college.wordbookValue}}">{{college.wordbookValue}}</option>
    </select>
    <span >班级名称：</span>
    <select  ng-model="para.studentClass" name="studentClass" class="forminput" id="studentClass"  >
        <option value=" " >--请选择--</option>
        <option ng-repeat="class in classes" value="{{class.className}}">{{class.className}}</option>
    </select>
    <span >学期名称：</span>
    <select  ng-model="para.semester" name="semester" class="forminput" id="semester"  >
        <option value=" " >--请选择--</option>
        <option ng-repeat="semester in semesters" value="{{semester.semester}}">{{semester.semester}}</option>
    </select>
    <input style="height:26px;margin-top: -3px" class="tablesearchbtn" type="text" ng-model="input.keyword" placeholder="请输入关键字进行查询..." onkeyup="getSearchStr(this)"/>
    <table-btn style="height:26px;margin-top: -3px" id="search" ng-click="loadStudent()">搜索</table-btn>
    <table-btn style="height:26px;margin-top: -3px" ng-click="insert()"><img src="<%=request.getContextPath()%>/images/icon_import.png" />导入学生缴费信息</table-btn>
    <table-btn style="height:26px;margin-top: -3px" ng-click="getModel()"><img src="<%=request.getContextPath()%>/images/icon_download.jpg" />下载模板</table-btn>
</div>
<!--表格-->
<div class="tablebox">
    <table class="table">
        <thead>
        <th>学号</th>
        <th>姓名</th>
        <th>班级</th>
        <th>学院</th>
        <th>学期</th>
        <th>缴费情况</th>
        </thead>
        <tbody>
        <tr ng-repeat="student in students">
            <td ng-bind="student.studentNum"></td>
            <td ng-bind="student.studentName"></td>
            <td ng-bind="student.studentClass"></td>
            <td ng-bind="student.studentCollege"></td>
            <td ng-bind="student.semester"></td>
            <td ng-bind="student.status"></td>
        </tr>
        </tbody>
    </table>
</div>
<%--遮罩层--%>
<div id="modal">
    <div class="mask"></div>
</div>
<!--分页-->
<div class="pagingbox">
    <paging></paging>
</div>
<!--导入学生缴费信息-->
<div id="insert-form"  title="批量导入" style="display:none;width:400px;height:410px;padding:10px;position:absolute;border:3px #c5add7 solid; left:35%;top:15%;background-color:#ffffff">
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
    <p style="color:#ff0000;">（导入学生缴费信息时请选用给定的模板）</p>
    <%--批量导入对话框的按钮--%>
    <div>
        <a href="javascript:void(0)" style="margin-left: 335px;color: white;background: #c5add7;position: absolute;
        padding-left: 5px;padding-top: 1;width: 40px;height: 22px;text-decoration: none;" ng-click="close()">关闭</a>
    </div>
</div>
</body>
</html>
<script>
    var app = angular.module('app',[]).controller('ctrl',function  ($scope) {
        var num=0;
        $scope.para={
            "collegeName":" ",
            "studentClass":" ",
            "semester":" "
        };
//        加载筛选条件下拉选
        remotecall("teacher_loadCoMaGrInfo",{},function (data) {
            $scope.classes = data.class;
            $scope.semesters = data.newsemester;
            $scope.colleges = data.college;
        },function (data) {
        });
        //加载数据
        $scope.loadStudent = function () {
            loading();//加载层
            $('#insert-form').hide();
            //以下内容中的请求地址根据不同的页面而改变，加载的数据对象名称修改一下，其余不需要
            remotecall("studentPaymentManage_load",{pageNum:pageNum,pageSize:pageSize,searchStr:searchStr,
                college:$scope.para.collegeName,studentClass:$scope.para.studentClass,semester:$scope.para.semester
            },function (data) {
                closeLoading();
                $scope.students = data.rows;//加载的数据对象，‘students’根据不同需求而变

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

                num=0;
                //数据为0时提示
                if(data.total==0){
                    parent.pMsg("暂无数据");
                }
            },function (data) {
                parent.pMsg("加载数据失败");
                console.log(data);
            });
            $scope.checkitem={};
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
                //重新加载用户信息
                if($scope.show==1){
                    $scope.loadData();
                }else if($scope.show==2){
                    $scope.detail();
                }
            }
        };
        $scope.insert=function () {
            $("#modal").show();
            $('#insert-form').show();

        };
        $scope.close=function () {
            $('#insert-form').hide();
            $("#modal").hide();
            $("#valid_result,#file").empty();

        };
        //首次加载
        $scope.loadStudent();
        $scope.checkitem={};

        //     验证文件
        $scope.validFile=function () {
            if(!$("#upfile").val()){
                layer.msg("请选择文件！");
                return;

            }
            $.ajaxFileUpload({
                url: "<%=request.getContextPath()%>/StudentPayment/validate.form", //用于文件上传的服务器端请求地址
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
                url: "<%=request.getContextPath()%>/StudentPayment/StudentPayment_info.form", //用于文件上传的服务器端请求地址
                secureuri: false, //一般设置为false
                fileElementId: "upfile", //文件上传空间的id属性
                dataType: 'String', //返回值类型 一般设置为String
                success: function (data, status)  //服务器成功响应处理函数
                {
                    //console.log(data);
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
                elemIF.src = "../../files/studentsPayment.xls";
                elemIF.style.display = "none";
                document.body.appendChild(elemIF);
            }catch(e){
            }
        }
    });
    //绑定回车事件
    $('.tablesearchbtn').bind('keypress', function (event) {
        if (event.keyCode == "13") {
            $("#searchkey").click();
        }
    });
</script>
<!--自定义组件-->
<script src="<%=request.getContextPath()%>/js/font/angular-directive.js" type="text/javascript" charset="utf-8"></script>
