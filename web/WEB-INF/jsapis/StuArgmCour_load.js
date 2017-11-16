/**
 * Created by NEUNB_Lisy on 2017/5/19.
 */
//查询学生本人的课表，只能查看本学期的
function main(context) {
    var result = querypagedata(function () {/*
     SELECT
     `user`.`userId`,
     `user`.`typeId`,
     `arrangelesson`.*,
     `arrangecourse`.*,
     `teacher`.`teacherName`,
     `stuchoosecourse`.`chineseName`,
     `teachtask`.`tc_thweek_start`,
     `teachtask`.`tc_thweek_end`,
     `teachtask`.`tc_class`,
     `teachtask`.`tc_teachodd`,
     `student`.`studentName`
     FROM
     `user`
     LEFT JOIN `student`
     ON (`student`.`studentId`=`user`.`typeId`)
     LEFT JOIN `stuchoosecourse`
     ON (`stuchoosecourse`.`studentId`=`user`.`typeId`)
     LEFT JOIN `teachtask`
     ON (`stuchoosecourse`.`tc_id`=`teachtask`.`tc_id`)
     LEFT JOIN `arrangelesson`
     ON (`teachtask`.`tc_id`=`arrangelesson`.`tc_id`)
     LEFT JOIN `arrangecourse`
     ON (`arrangelesson`.`acId`=`arrangecourse`.`acId`)
     LEFT JOIN `nxlg`.`teacher`
     ON (`teacher`.`teacherId`=`teachtask`.`tc_classteacherid`)
     WHERE
     userId=${sessionUserID} AND is_now=1 AND iscomfirm=1 AND (scc_status!='退课通过' OR scc_status IS NULL OR scc_status ='') AND (${thweekday}=0 OR tc_teachodd='无' OR tc_teachodd=${teachodd}) AND (${thweekday}=0 OR (tc_thweek_start<=${thweekday} AND ${thweekday}<=tc_thweek_end))
     */},context,"");
    return result;
}