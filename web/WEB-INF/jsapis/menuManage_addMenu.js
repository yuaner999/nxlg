/**
 * Created by liulei on 2017-03-04.
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.menuName == null||context.menuSort == null){
        return false;
    }
    //新建菜单
    var result = exec(function () {/*
     INSERT INTO `menu` (
     `menuId`,
     `menuName`,
     `menuParent`,
     `menuSort`,
     `menuUrl`,
     `createMan`,
     `createDate`
     )
     VALUES(UUID(),${menuName},${menuParent},${menuSort},${menuUrl},${sessionUserName},NOW())
    */},context);
    return result;
}


