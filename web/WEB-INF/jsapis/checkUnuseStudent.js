/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //空闲学生查询
    var result = querypagedata(function () {/*
     SELECT
     *
     FROM student
     WHERE student.`studentId` NOT IN(
     SELECT
     student.`studentId`
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
     is_now=1 AND iscomfirm=1
     AND (scc_status!='退课通过' OR scc_status IS NULL OR scc_status ='')
     AND (${teachweek}=0 OR tc_teachodd='无' OR tc_teachodd=${teachodd}) AND (${teachweek}=0 OR (tc_thweek_start<=${teachweek} AND ${teachweek}<=tc_thweek_end))
     AND (${timeweek}=0 OR  `al_timeweek`=${timeweek})
     AND (${timepitch}=0 OR  `al_timepitch`=${timepitch})
     GROUP BY student.`studentId`
     )
     AND case when (${studentGrade} is not null AND ${studentGrade}<>"") then (studentGrade = ${studentGrade}) else 1=1 end
     AND case when (${studentCollege} is not null AND ${studentCollege}<>"") then (studentCollege = ${studentCollege}) else 1=1 end
     AND case when (${studentMajor} is not null AND ${studentMajor}<>"") then (studentMajor = ${studentMajor}) else 1=1 end

     ORDER BY studentGrade DESC
     */}, context, "", context.pageNum, context.pageSize);

    return result;
}