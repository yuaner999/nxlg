/**
 * Created by NEUNB_Lisy on 2017/7/11.
 */
function main(context) {
    var result = query(function () {/*
     SELECT
     `menu_jsapi`.*,
     `menu`.*
     FROM
     `nxlg`.`menu`
     LEFT JOIN
     `nxlg`.`menu_jsapi`
     ON (`menu_jsapi`.`menuId` = `menu`.`menuId`)
     WHERE
     `menu`.`menuId` = ${menuId}
     order by `menu_jsapi`.`jsapis_name`
     */},context,"");
    return result;
}