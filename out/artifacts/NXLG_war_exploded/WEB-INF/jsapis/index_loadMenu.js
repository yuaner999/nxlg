/**
 * Created by NEU on 2017/3/14.
 */
function main(context) {
    var r=query(function (){/*
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
     , CONCAT('/images/leftnav',`menu`.`menuName`,'.png') iconurl
     FROM
     `menu` AS `menu_1`
     RIGHT JOIN `menu`
     ON (`menu_1`.`menuParent` = `menu`.`menuId`)
     WHERE `menu`.`menuParent`=''
     AND menu_1.`menuId` IN (SELECT menu.`menuId` FROM `user` LEFT JOIN  role_menu ON(`user`.`roleId`=role_menu.`roleId`)
     LEFT JOIN menu ON(role_menu.`menuId`=menu.`menuId`) WHERE userId=${sessionUserID})
     ORDER BY `menu`.`menuSort`,`menu_1`.`menuSort`
    */},context,"menuId,menuName,menuParent,menuSort,menuUrl,iconurl,menus:[menuId1,menuName1,menuParent1,menuSort1,menuUrl1]");
    return r;
}
