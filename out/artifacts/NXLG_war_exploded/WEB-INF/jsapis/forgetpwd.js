/**
 * Created by NEU on 2017/4/8.
 */
function main(context) {
    //基础数据非空判断
    if(context.usercode == null||context.newpwd_s == null||context.userName == null||context.userEmail == null){
        return false;
    }
    context.usercode ="您的验证码是"+context.usercode;
    var r = query(function () {/*
     SELECT * FROM user WHERE `userName`=${userName} AND userEmail=${userEmail} AND `codeContent`=${usercode}
     */}, context, "");
    if (r==null||r.length == 0) {
        return {result: false, errormessage: "请确定"};
    }else{
        var q=exec(function(){/*
         UPDATE `user`
         SET
         `password` = ENCODE(${newpwd_s},'371df050-00b3-11e7-829b-00ac2794c53f')
         WHERE `userName`=${userName} AND `userEmail`=${userEmail}
         */},context);
        if(q){
            return {result:q,errormessage:"重置密码失败"};
        }else return {result:false,errormessage:"重置密码失败"};
    }
}