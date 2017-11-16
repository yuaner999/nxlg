/**
 * Created by liulei on 2017-03-04.
 */
function main(context) {
    //加载菜单
    var result = querypagedata(function () {/*
     SELECT
     `menu`.*
     , `menu_1`.`menuName` menuParentName
     FROM
     `nxlg`.`menu`
     LEFT JOIN `nxlg`.`menu` AS `menu_1`
     ON (`menu`.`menuParent` = `menu_1`.`menuId`)
     ORDER BY
     CASE WHEN ${orderkey}='menuName' AND ${ordervalue}='0' THEN convert(`menu`.`menuName` USING gbk) COLLATE gbk_chinese_ci END ASC,
     CASE WHEN ${orderkey}='menuName' AND ${ordervalue}='1' THEN convert(`menu`.`menuName` USING gbk) COLLATE gbk_chinese_ci END DESC,
     CASE WHEN ${orderkey}='menuSort' AND ${ordervalue}='0' THEN `menu`.`menuSort` END ASC,
     CASE WHEN ${orderkey}='menuSort' AND ${ordervalue}='1' THEN `menu`.`menuSort` END DESC;
    */},context,"",context.pageNum,context.pageSize);
    return result;
}