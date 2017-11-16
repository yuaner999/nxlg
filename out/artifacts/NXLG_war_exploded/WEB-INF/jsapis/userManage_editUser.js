/**
 * Created by NEU on 2017/3/14.
 */
function main(context) {
    //数据非空判断
    if(context.userId == null){
        return false;
    }
    var rr = query(function () {/*
     SELECT * FROM USER WHERE userId=${userId}
     */},context,"");
    if(!rr) return {result:false,errormessage:"错误的用户id"}
    if(rr[0].typeName==='学生' && context.typeName!=='学生'){
        return {result:false,errormessage:"学生角色不允许修改为其它角色"}
    }
    if((rr[0].typeName==='教师' || rr[0].typeName==='管理员') && context.typeName==='学生'){
        return {result:false,errormessage:"教师或管理员角色不允许修改为学生角色"}
    }
    //修改用户信息 
    var result = exec(function () {/*
     UPDATE user
     SET 
     userName = ${userName},
     roleId = ${roleId}
     WHERE userId = ${userId}
     */},context);
    return  {result:true,errormessage:""};
}
