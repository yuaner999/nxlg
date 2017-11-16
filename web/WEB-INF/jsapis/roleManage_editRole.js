/**
 * Created by NEU on 2017/3/14.
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.roleName == null||context.isSystem == null||context.roleId == null){
        return false;
    }
    // 修改角色
    var result = exec(function () {/*
     UPDATE `role`
     SET
     `roleName` = ${roleName},
     `isSystem` = ${isSystem},
     `updateMan` = ${sessionUserName},
     `updateDate` = NOW()
     WHERE `roleId` = ${roleId}
     */},context);
    return result;
}
