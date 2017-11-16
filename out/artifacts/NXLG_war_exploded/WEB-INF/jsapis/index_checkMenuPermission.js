/**
 * Created by gq on 2017/5/31.
 * 判断当前用户是否有当前菜单权限
 * 参数 url
 */
function main(context) {
    if(context.url===null) return {result:false,errormessage:"获取路径失败"};
    var r1 = query(function () {/*
     SELECT menuUrl FROM menu WHERE menuUrl !=''
     */},context,"");
    var flag=false;
    if(!r1) r1=[];
    for (var i = 0; i < r1.length; i++) {
        var obj = r1[i];
        if(obj.menuUrl===context.url){
            flag=true;
            break;
        }
    }
    if(flag){
        var r2=query(function (){/*
         SELECT
         `menu`.`menuId`
         , `menu`.`menuName`
         , `menu`.`menuParent`
         , `menu`.`menuSort`
         , `menu`.`menuUrl`
         , `menu_1`.`menuId` menuId1
         , `menu_1`.`menuName` menuName1
         , `menu_1`.`menuParent` menuParent1
         , `menu_1`.`menuSort` menuSort1
         , `menu_1`.`menuUrl` menuUrl1
         FROM
         `menu` AS `menu_1`
         RIGHT JOIN `menu`
         ON (`menu_1`.`menuParent` = `menu`.`menuId`)
         WHERE `menu`.`menuParent`=''
         AND menu_1.`menuId` IN (SELECT menu.`menuId` FROM `user` LEFT JOIN  role_menu ON(`user`.`roleId`=role_menu.`roleId`)
         LEFT JOIN menu ON(role_menu.`menuId`=menu.`menuId`) WHERE userId=${sessionUserID} and menu_1.menuUrl=${url})
         ORDER BY `menu`.`menuSort`,`menu_1`.`menuSort`
         */},context,"menuId,menuName,menuParent,menuSort,menuUrl,menus:[menuId1,menuName1,menuParent1,menuSort1,menuUrl1]");
        if(!r2 || r2.length===0) return {result:false,errormessage:"您没有该页面的权限"};
    }
    return {result:true,errormessage:""};
}
var inputsamples=[{
    url:"basic/studentManage.form",
    sessionUserID:'fca3b7d9-0921-11e7-8be9-00ac2794c53f'
}]