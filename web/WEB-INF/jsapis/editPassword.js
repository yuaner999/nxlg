/**
 * Created by liulei on 2017-03-04.
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName")==null){
        return false;
    }
    //验证用户名密码
    var result = query(function () {/*
        select * from user where userName = ${sessionUserName} and password = ENCODE(${oldPassword},'371df050-00b3-11e7-829b-00ac2794c53f')
    */},context,"");
    if(result.length==0){//原密码不正确
        return 0;
    }
    result = exec(function () {/*
        update user set password=ENCODE(${newPassword},'371df050-00b3-11e7-829b-00ac2794c53f') where userName=${sessionUserName}
    */},context);
    if(result){//修改成功
        return 1;
    }else {
        return -1;
    }
}