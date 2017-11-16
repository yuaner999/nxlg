/**
 * Created by liulei on 2017-03-04.
 */
function main(context) {
    //验证用户名密码
    var result = query(function () {/*
        select * from user where userName = ${userName} and
            password = ENCODE(${password},'371df050-00b3-11e7-829b-00ac2794c53f') and userStatus='启用'
    */},context,"");
    //登录成功写入Session
    if(result.length>0){
        setsession(context,"sessionUserName",result[0].userName);
        setsession(context,"sessionUserID",result[0].userId);
        setsession(context,"sessionUserType",result[0].typeName);
        //关联退出登录
        return true;
    }else {
        return false;
    }
}