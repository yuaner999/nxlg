/**
 * Created by NEU on 2017/3/21.
 * 新建管理员+用户（包含管理员姓名和用户名唯一性验证）
 */  
function main(context) {
    //基础数据非空判断
    if(context.adminName == null||context.userName == null||context.adminPhone == null||context.adminEmail == null){
        return false;
    }
    //基础数据数值型判断
    if(isNaN(context.adminPhone)){
        return false;
    }
    var r = query(function () {/*
     select userName from user
     where userName=${userName}
     */},context,"");
    if(r.length==0){   //如果用户名在数据库中不存在
        var r1 = query(function () {/*
         SELECT * FROM  admin
         WHERE
         adminName = ${adminName}
         */},context,"");
         if(r1.length==0){   //如果管理员名在数据库中不存在
                var con = createconnection();
                var admin_Id=uuid();
                context.adminId=admin_Id;
                var result = multiexec(con,"INSERT INTO admin(adminId,adminName,adminIcon,adminPhone,adminEmail,createMan,createDate) VALUES(${adminId},${adminName},${adminIcon},${adminPhone},${adminEmail},${sessionUserName},NOW())",context);
                if(!result){
                    rollback(con);
                    closeconnection(con);
                    return false;
                    }else {
                    var result1 = multiexec(con,"INSERT INTO user(userId,userName,password,userEmail,typeName,isNeuNb,typeId,roleId,userStatus) VALUES(UUID(),${userName},ENCODE('e10adc3949ba59abbe56e057f20f883e','371df050-00b3-11e7-829b-00ac2794c53f'),${adminEmail},'管理员','否',${adminId},'fe4a185d-0d4a-11e7-b2fe-00ac9c2c0afa','启用')",context);
                    if (!result1) {
                        rollback(con);
                        closeconnection(con);
                        return false;
                    }
                }
            commit(con);
            closeconnection(con);
            return 2;  //新增数据成功
    }else{
        return 0;//管理员名已存在
    }
    }else{
        return 1;//用户名已存在
    }
}
