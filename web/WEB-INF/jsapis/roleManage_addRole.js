/**
 * Created by NEU on 2017/3/14.
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.roleName == null||context.isSystem == null){
        return false;
    }
    // 新建角色
    var result = exec(function () {/*
     INSERT INTO `role` (
     `roleId`,
     `roleName`,
     `isNeuNb`,
     `isSystem`,
     `createMan`,
     `createDate`
     )
     VALUES(UUID(),${roleName},'否',${isSystem},${sessionUserName},NOW())
     */},context);
    return result;
}