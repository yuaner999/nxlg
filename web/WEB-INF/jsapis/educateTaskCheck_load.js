/**
 * Created by NEU on 2017/5/16.
 */
// 加载教学任务信息
function main(context) {
    var result = querypagedata(function () {/*
     SELECT
     `teachtask`.* ,CONCAT(`teachtask`.`tc_thweek_start`,"至",`teachtask`.`tc_thweek_end`) AS tc_teachweek
     , `course`.*
     , `teacher`.*
     , `teacher_1`.*
     , `teacher`.`teacherName` AS teacherName,`teacher_1`.`teacherName` AS teacherName1
     FROM
     `nxlg`.`teachtask`
     LEFT JOIN `nxlg`.`course` 
     ON (`teachtask`.`tc_courseid` = `course`.`courseId`)
     LEFT JOIN `nxlg`.`teacher` 
     ON (`teachtask`.`tc_mainteacherid` = `teacher`.`teacherId`)
     LEFT JOIN `nxlg`.`teacher` AS `teacher_1`
     ON (`teachtask`.`tc_classteacherid` = `teacher_1`.`teacherId`)
     WHERE (`teachtask`.`tc_isDelete` is null or `teachtask`.`tc_isDelete`="否")
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="0") then (`teachtask`.tc_checkStatus="待审核") else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then (`teachtask`.tc_checkStatus="已通过") else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="2" then (`teachtask`.tc_checkStatus="未通过") else 1=1 end
     AND CASE WHEN ${checkType} IS NOT NULL AND ${checkType}<>""  THEN tc_checkType = ${checkType} ELSE 1=1 END
     and case when ${chineseName} is not null and ${chineseName}<>""  then `course`.chineseName LIKE CONCAT('%',${chineseName},'%') else 1=1 end
     and case when ${teacherName} is not null and ${teacherName}<>""  then `teacher`.`teacherName` LIKE CONCAT('%',${teacherName},'%') else 1=1 end
     and case when ${tc_class} is not null and ${tc_class}<>""  then `teachtask`.tc_class LIKE CONCAT('%',${tc_class},'%') else 1=1 end
     and case when ${teacherName1} is not null and ${teacherName1}<>""  then `teacher_1`.teacherName LIKE CONCAT('%',${teacherName1},'%') else 1=1 end
     and case when ${college} is not null and ${college}<>""  then `teacher`.teachCollege LIKE CONCAT('',${college},'') else 1=1 end

     */},context,"",context.pageNum,context.pageSize);
    return result;
}
