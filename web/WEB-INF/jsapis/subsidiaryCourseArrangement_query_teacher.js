/**
 * Created by NEUNB_Lisy on 2017/5/20.
 */
//查询教师上课信息
function main(context) {
    var result = query(function () {/*
     SELECT
     `teachtask`.`tc_classteacherid` ,
     `arrangelesson`.*
     FROM
     `teachtask`
     LEFT JOIN `nxlg`.`arrangelesson`
     ON (`arrangelesson`.`tc_id`=`teachtask`.`tc_id`)
     WHERE
     `teachtask`.`tc_id`=${tc_id}
     */},context,"");
    return result;
}