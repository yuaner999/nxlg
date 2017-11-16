/**
 * Created by NEUNB_Lisy on 2017/5/19.
 */
//查询学生本人的课表，只能查看本学期的
function main(context) {
    var result = query(function () {/*
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
     ON (`stuchoosecourse`.`studentId`=`student`.`studentId`)
     LEFT JOIN `teachtask`
     ON (`stuchoosecourse`.`class`=`teachtask`.`tc_class`)
     LEFT JOIN `arrangelesson`
     ON (`teachtask`.`tc_id`=`arrangelesson`.`tc_id`)
     LEFT JOIN `arrangecourse`
     ON (`arrangelesson`.`acId`=`arrangecourse`.`acId`)
     LEFT JOIN `nxlg`.`teacher`
     ON (`teacher`.`teacherId`=`teachtask`.`tc_classteacherid`)
     WHERE  userId=${sessionUserID} AND is_now=1
     */},context,"");
    return result;
}