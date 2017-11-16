/**
 * Created by NEU on 2017/3/17.
 * 新建管理员+用户 （包含管理员和用户名唯一性验证）
 * 参数：adminId
 */
function main(context) {
    //基础数据非空判断
    if(context.adminId == null||context.userId == null||context.adminName == null||context.userName == null||context.adminPhone == null||context.adminEmail == null){
        return false;
    }
    //基础数据数值型判断
    if(isNaN(context.adminPhone)){
        return false;
    }
    var user_Id=context.userId;
    var admin_Id=context.adminId;
    var r = query(function () {/*
     select userId from user
     where userName=${userName}
     */},context,"");
    if(r.length==0||r[0].userId==user_Id){   //如果用户名在数据库中不存在||用户名没有修改
        var r1 = query(function () {/*
         SELECT * FROM  admin
         WHERE
         adminName = ${adminName}
         */},context,"");
        if(r1.length==0||r1[0].adminId==admin_Id){   //如果管理员名正确||管理员名没有修改
            var con = createconnection();
            var result = multiexec(con,"UPDATE admin SET adminName = ${adminName},adminIcon = ${adminIcon},adminPhone = ${adminPhone},adminEmail = ${adminEmail},updateMan = ${sessionUserName},updateDate = NOW() WHERE adminId = ${adminId}",context);
            if(!result){
                rollback(con);
                closeconnection(con);
                return false;
            }else {
                var result1 = multiexec(con,"UPDATE user SET userName = ${userName},userEmail = ${adminEmail} WHERE typeId = ${adminId}",context);
                if (!result1){
                    rollback(con);
                    closeconnection(con);
                    return false;
                }
            }
            commit(con);
            closeconnection(con);
            return 2;  //修改数据成功
        }else{
            return 0;//管理员名已存在
        }
    }else{
        return 1;//用户名已存在
    }
}