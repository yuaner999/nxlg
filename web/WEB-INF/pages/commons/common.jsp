<script>
    //返回ie版本字符串
    function IETester(userAgent){
        var UA =  userAgent || navigator.userAgent;
        if(/msie/i.test(UA)){
            return UA.match(/msie (\d+\.\d+)/i)[1];
        }else if(~UA.toLowerCase().indexOf('trident') && ~UA.indexOf('rv')){
            return UA.match(/rv:(\d+\.\d+)/)[1];
        }
        return false;
    }
    if(parseInt(IETester())<10){
        alert("您的浏览器为IE内核，且版本过低，这将影响网页效果，请使用高版本IE或其他内核浏览器");
        //强制关闭页面
        window.opener = null;
        window.open('','_self');
        window.close();
    }
</script>
<!--通用css-->
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/common.css"/>
<!--单引css-->
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/table.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/table-addform.css"/>
<!-- Bootstrap部分 -->
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/bootstrap.min.css">
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
<script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
<script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
<script>
    var pagecontextpath="<%=request.getContextPath()%>";
    var pageNum = 1;
    var pageSize =3;
    var pageCount = 1;
    var pageShow=5;  //显示页码数量
</script>
<script src="<%=request.getContextPath()%>/js/jquery-1.11.0.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=request.getContextPath()%>/js/angular1.6.min.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=request.getContextPath()%>/js/remotecall.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=request.getContextPath()%>/js/Validform_v5.3.2_min.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=request.getContextPath()%>/js/layer/layer.js" type="text/javascript" charset="utf-8"></script>
<script src="<%=request.getContextPath()%>/js/layer/layer.ext.js" type="text/javascript" charset="utf-8"></script><%--弹出可输入框，不可删--%>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/font/gVerify.js"></script>
<script src="<%=request.getContextPath()%>/js/font/jedate/jquery.jedate.min.js" type="text/javascript" charset="utf-8"></script><%--日历--%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/js/font/jedate/skin/jedate.css" />
<!--layui部分-->
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/layui/css/layui.css"/>
<script src="<%=request.getContextPath()%>/layui/layui.js" type="text/javascript" charset="utf-8"></script>
<%--文件上传--%>
<script src="<%=request.getContextPath()%>/js/jquery.upload.js" type="text/javascript" charset="utf-8"></script>
<!--通用js-->
<script src="<%=request.getContextPath()%>/js/font/common.js" type="text/javascript" charset="utf-8"></script>
<%--页面蒙板，缓冲加载--%>
<div id="Board" style="position: fixed;z-index: 9999;width: 100%;height: 100%;background: #ffffff;"></div>
<script>
    var loadBoard;//加载层对象
    var searchStr = "";//搜索的字符串
    var searchStr2 = "";//搜索的字符串
    var searchStr3 = "";//搜索的字符串
    $(function () {
        //关闭蒙板，显示画面
        $("#Board").fadeOut("slow");
        //搜索框绑定，回车事件
        $('.tablesearchbtn').bind('keypress', function (event) {
            if (event.keyCode == "13") {
                $("#search").click();
            }
        });
    });
    //加载层
    function loading() {
        loadBoard = layer.load(0, {
            shade: [0.2,'#000'] //0.1透明度的白色背景
        });
    }
    //关闭加载层
    function closeLoading() {
        layer.close(loadBoard);
    }
    //为搜索字符串赋值
    function getSearchStr(obj) {
        pageNum = 1;
        searchStr = $(obj).val();
    }
    //为搜索字符串赋值
    function getSearchStr2(obj) {
        pageNum = 1;
        searchStr2 = $(obj).val();
    }
    //为搜索字符串赋值
    function getSearchStr3(obj) {
        pageNum = 1;
        searchStr3 = $(obj).val();
    }
    //时间：将字符型转为时间型，值为毫秒
    function ConvertDateFromString(dateString) {
        if (dateString) {
            var arr1 = dateString.split(" ");
            var sdate = arr1[0].split('-');
            var mdate = arr1[1].split(':');
            var date = (new Date(sdate[0],sdate[1],sdate[2],mdate[0],mdate[1],mdate[2])).getTime();
            return date;
        }
    }
    //new Date().getTime得到的毫秒值不对
    function nowTime() {
        var now=new Date();//定义当前时间
        var date = (new Date(now.getFullYear(),now.getMonth()+1,now.getDate(),now.getHours(),now.getMinutes(),now.getSeconds())).getTime();
        return date;
    }
</script>
<script src="<%=request.getContextPath()%>/js/font/table.js" type="text/javascript" charset="utf-8"></script>
<%@include file="checklogin.jsp"%>