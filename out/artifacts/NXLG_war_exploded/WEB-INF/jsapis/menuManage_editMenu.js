/**
 * Created by NEU on 2017/3/13.
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.menuName == null||context.menuSort == null||context.menuId == null){
        return false;
    }
    //修改菜单
    var result = exec(function () {/*
     UPDATE `menu`
     SET
     `menuName` = ${menuName},
     `menuParent` = ${menuParent},
     `menuSort` = ${menuSort},
     `menuUrl` = ${menuUrl},
     `updateMan` = ${sessionUserName},
     `updateDate` = NOW()
     WHERE `menuId` = ${menuId}
     */},context);
    return result;
}