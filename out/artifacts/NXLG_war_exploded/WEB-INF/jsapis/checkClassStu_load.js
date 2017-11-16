/**
 * Created by NEUNB_Lisy on 2017/6/2.
 */
//查询该教师需要上课的班级
function main(context){
    var result=querypagedata(function(){/*
        SELECT
            `student`.`studentNum`,
            `student`.`studentName`,
            `student`.`studentGender`,
            `student`.`studentPhone`,
            `student`.`studentEmail`,
            `student`.`studentGrade`,
            `student`.`studentCollege`,
            `student`.`studentMajor`,
            `student`.`studentClass`,
            `student`.`studentLevel`,
            `student`.`studentForm`,
            `student`.`studentSchoolAddress`
        FROM `student`
        WHERE
        `student`.`studentId` IN
        (
            SELECT `stuchoosecourse`.`studentId`
            FROM `nxlg`.`stuchoosecourse`
            LEFT JOIN `nxlg`.`teachtask`
            ON `teachtask`.`tc_id`=`stuchoosecourse`.`tc_id`
            LEFT JOIN `nxlg`.`arrangecourse`
            ON `arrangecourse`.`semester`=`teachtask`.`tc_semester`
            WHERE
            `is_now`=1
            AND ${tc_id}=`teachtask`.`tc_id`
        )
        AND
        (
         (${studentNum}='' OR `student`.`studentNum` LIKE CONCAT ('%',${studentNum},'%'))
         AND (${studentName}='' OR `student`.`studentName` LIKE CONCAT ('%',${studentName},'%'))
         AND (${studentGrade}='' OR `student`.`studentGrade` LIKE CONCAT ('%',${studentGrade},'%'))
         AND (${studentCollege}='' OR `student`.`studentCollege` LIKE CONCAT ('%',${studentCollege},'%'))
         AND (${studentMajor}='' OR `student`.`studentMajor` LIKE CONCAT ('%',${studentMajor},'%'))
         AND (${studentClass}='' OR `student`.`studentClass` LIKE CONCAT ('%',${studentClass},'%'))
         AND (${studentSchoolAddress}='' OR `student`.`studentSchoolAddress` LIKE CONCAT ('%',${studentSchoolAddress},'%'))
        )
    */},context,"",context.pageNum,context.pageSize);
    return result;
}