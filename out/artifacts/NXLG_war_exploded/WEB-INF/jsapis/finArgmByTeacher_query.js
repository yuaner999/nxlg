/**
 * Created by NEUNB_Lisy on 2017/5/19.
 */
//查询该教师的课程表
function main(context) {
    var result = querypagedata(function () {/*
     SELECT
     `arrangelesson`.*,
     `course`.*,
     `teachtask`.*,
     `teacher`.*
     FROM
     `nxlg`.`arrangelesson`
     LEFT JOIN `nxlg`.`course`
     ON (`arrangelesson`.`courseId`=`course`.`courseId`)
     LEFT JOIN `nxlg`.`teachtask`
     ON (`teachtask`.`tc_id`=`arrangelesson`.`tc_id`)
     LEFT JOIN `nxlg`.`teacher`
     ON (`teacher`.`teacherId`=`teachtask`.`tc_classteacherid`)
     LEFT JOIN `nxlg`.`arrangecourse`
     ON (`arrangelesson`.`acId`=`arrangecourse`.`acId`)
     WHERE
     `is_now`=1 AND `teacherId`=${teacherId} AND (tc_teachodd='无' OR ${thweekday}=0  OR tc_teachodd=${teachodd}) AND (${thweekday}=0 OR (tc_thweek_start<=${thweekday} AND ${thweekday}<=tc_thweek_end))
     */},context,"");
    return result;
}