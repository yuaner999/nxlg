<%--
  Created by IntelliJ IDEA.
  User: shizy
  Date: 2017/02/26
  Time: 9:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%
    HttpSession s = request.getSession();
    if (s.getAttribute("sessionUserID") == null||s.getAttribute("sessionUserID")=="") {
                response.sendRedirect(request.getContextPath()+"/views/login.form");
                response.getWriter().close();
    }
%>--%>
<script>
    var a = '<%=request.getParameter("menuErr")==null?null:"您没有该页面的权限!"%>';
    console.log(a);
    /*if(a!=""){
        showmsgpc(a);
    }*/
</script>
<%--判断当前用户是否有当前菜单权限--%>
<%--
<script language='javascript' type='text/javascript'>
    var url = location.href;
    url=url.substr(url.lastIndexOf('/', url.lastIndexOf('/') - 1) + 1);
    remotecallasync("index_checkMenuPermission",{url:url},function (data){
        if(!data.result) 	showmsgpc(data.errormessage);
    },function (data) {
    });
    &lt;%&ndash;if(window.parent==window){//不存在父页面&ndash;%&gt;

    &lt;%&ndash;}else {//存在父页面&ndash;%&gt;
        &lt;%&ndash;parent.gotoLogin();&ndash;%&gt;
    &lt;%&ndash;}&ndash;%&gt;
</script>
--%>
