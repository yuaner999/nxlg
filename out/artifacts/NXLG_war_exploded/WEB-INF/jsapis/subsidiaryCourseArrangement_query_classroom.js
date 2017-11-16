/**
 * Created by NEUNB_Lisy on 2017/5/19.
 */
//查询排课信息
function main(context) {
    var result = query(function () {/*
     SELECT
     `arrangelesson`.* ,
     `teachtask`.`tc_thweek_start` ,
     `teachtask`.`tc_thweek_end` ,
     `teachtask`.`tc_teachodd`
     FROM
     `nxlg`.`arrangelesson`
     LEFT JOIN `nxlg`.`course`
     ON ( `course`.`courseId`= `arrangelesson`.`courseId`)
     LEFT JOIN `nxlg`.`teachtask`
     ON(`teachtask`.`tc_courseid`=`course`.`courseId`)
     WHERE
     `classroomId`=${classroomId}
     */},context,"");
    return result;
}