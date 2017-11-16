/**
 * Created by NEUNB_Lisy on 2017/6/2.
 */
//查询该教师需要上课的班级
function main(context){
    var result=querypagedata(function(){/*
        SELECT
            `course`.`chineseName`,
            `course`.`courseCode`,
            `teacher`.`teacherName`,
            `teachtask`.`tc_id`,
            `teachtask`.`tc_class`,
            `teachtask`.`tc_teachway`,
            `teachtask`.`tc_grade`,
            `teachtask`.`tc_studentnum`,
            `teachtask`.`tc_thweek_start`,
            `teachtask`.`tc_thweek_end`,
            `teachtask`.`tc_teachodd`
        FROM `teachtask`
        LEFT JOIN `nxlg`.`user`
        ON `user`.`typeId`=`teachtask`.`tc_classteacherid`
        LEFT JOIN `nxlg`.`arrangecourse`
        ON `arrangecourse`.`semester`=`teachtask`.`tc_semester`
        LEFT JOIN `nxlg`.`course`
        ON `course`.`courseId`=`teachtask`.`tc_courseid`
        LEFT JOIN `nxlg`.`teacher`
        ON `teacher`.`teacherId`=`teachtask`.`tc_mainteacherid`
        WHERE
        `is_now`=1
        AND `userId`=${sessionUserID}
        AND
            (
            (${chineseName}='' OR `chineseName` LIKE CONCAT ('%',${chineseName},'%'))
            AND (${courseCode}='' OR `courseCode` LIKE CONCAT('%',${courseCode},'%'))
            AND (${teacherName}='' OR `teacherName` LIKE CONCAT ('%',${teacherName},'%'))
            AND (${tc_class}='' OR `tc_class` LIKE CONCAT ('%',${tc_class},'%'))
            AND (${tc_teachway}='' OR `tc_teachway` LIKE CONCAT ('%',${tc_teachway},'%'))
            AND (${tc_grade}='' OR `tc_grade` LIKE CONCAT ('%',${tc_grade},'%'))
            )
    */},context,"",context.pageNum,context.pageSize);
    return result;
}
