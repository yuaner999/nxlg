/**
 * Created by NEUNB_Lisy on 2017/6/6.
 */
function  main(context) {
    var result=querypagedata(function () {/*
        SELECT
        `teachtask`.`tc_id`,
        `teachtask`.`tc_grade`,
        `teachtask`.`tc_teachway`,
        `teachtask`.`tc_thweek_start`,
        `teachtask`.`tc_thweek_end`,
        `teachtask`.`tc_teachodd`,
        `teachtask`.`tc_class`,
        `arrangelesson`.`al_timeweek` ,
        `arrangelesson`.`al_timepitch` ,
        `arrangelesson`.`classroomName` ,
        `teacher`.`teacherName`,
        `course`.`chineseName`
        FROM `nxlg`.`teachtask`
        LEFT JOIN `nxlg`.`arrangelesson`
        ON (`arrangelesson`.`tc_id`=`teachtask`.`tc_id`)
        LEFT JOIN `nxlg`.`teacher`
        ON (`teacher`.`teacherId`=`teachtask`.`tc_classteacherid`)
        LEFT JOIN `nxlg`.`course`
        ON (`course`.`courseId`=`teachtask`.`tc_courseid`)
        LEFT JOIN `nxlg`.`majorterracecourse`
        ON (`majorterracecourse`.`courseId`=`course`.`courseId`)
        WHERE `majorterracecourse`.`majorId`=${majorId} AND `teachtask`.`tc_id` IN
        (
             SELECT `teachtask`.`tc_id`
             FROM `teachtask`
             LEFT JOIN `nxlg`.`course`
             ON (`course`.`courseId`=`teachtask`.`tc_courseid`)
             LEFT JOIN `nxlg`.`arrangecourse`
             ON (`arrangecourse`.`semester`=`teachtask`.`tc_semester`)
             WHERE
             `arrangecourse`.`is_now`=1
             AND `teachtask`.`tc_checkStatus`='已通过'
             AND (`teachtask`.`tc_isDelete` IS NULL OR `teachtask`.`tc_isDelete`='否')
             AND
             (
                `course`.`chineseName` LIKE CONCAT('%',${searchStr},'%')
                OR `teachtask`.`tc_class` LIKE CONCAT('%',${searchStr},'%')
                OR `teacher`.`teacherName` LIKE CONCAT('%',${searchStr},'%')
                OR `teacher`.`teacherNumber` LIKE CONCAT('%',${searchStr},'%')
                OR `arrangelesson`.`classroomName` LIKE CONCAT('%',${searchStr},'%')
             )
        )
        ORDER BY `course`.`chineseName`
     */},context,"tc_id,tc_class,tc_grade,tc_teachway,tc_thweek_start,tc_thweek_end,tc_teachodd,teacherName,chineseName,times:[al_timeweek,al_timepitch,classroomName]",context.pageNum,context.pageSize);
    return result;
}