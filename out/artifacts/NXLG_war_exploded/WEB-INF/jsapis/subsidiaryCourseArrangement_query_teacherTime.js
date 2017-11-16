/**
 * Created by NEUNB_Lisy on 2017/5/20.
 */
//查询教师上课信息
function main(context) {
    var result=query(function () {/*
     SELECT
     `arrangelesson`.*
     FROM
     `teachtask`
     LEFT JOIN `nxlg`.`arrangelesson`
     ON (`teachtask`.`tc_id`=`arrangelesson`.`tc_id`)
     WHERE
     tc_classteacherid=${tc_classteacherid}
     */},context,"");
    return result;
}