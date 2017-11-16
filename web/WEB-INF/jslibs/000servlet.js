/**
 * Created by liuzg on 2016/12/21.
 */
//设置http状态 404 400 500 等
function httpstatus(context,status){
    servlet.httpstatus(context,status);
}

//设置http头的内容类型
function contenttype(context,contenttype0){
    servlet.contenttype(context,contenttype0);
}

//设置session值
function setsession(context,key,value) {
    servlet.setsession(context,key,value);
}

//获取sesion值
function getsession(context, key) {
    return servlet.getsession(context,key);
}

function setheader(context, key, value) {
    return servlet.setheader(context,key,value);
}

function setview(context, viewname) {
    context.__modelandview_view = viewname;
}