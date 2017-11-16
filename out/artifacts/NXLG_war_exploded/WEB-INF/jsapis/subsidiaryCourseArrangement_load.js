/**
 * Created by NEUNB_Lisy on 2017/5/16.
 */
//查询某课程的上课地点和时间
function main(context) {
    var result = querypagedata(function () {/*
     SELECT
     `arrangelesson`.*,
     `arrangecourse`.*
     FROM
     `nxlg`.`arrangelesson`
     LEFT JOIN `nxlg`.`arrangecourse`
     ON (`arrangecourse`.`acId`=`arrangelesson`.`acId`)
     WHERE
     tc_id=${tc_id}
     */},context,"");
    return result;
}