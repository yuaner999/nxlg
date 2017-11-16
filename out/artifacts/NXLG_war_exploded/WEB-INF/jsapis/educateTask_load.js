/**
 * Created by NEU on 2017/5/15.
 */
// 加载课程信息
function main(context) {
    context.type = getsession(context,"sessionUserType");
    if(context.type=="学生"){return {result:false,errormessage:"学生用户没有权限"};}
    else if(context.type=="教师"){
        var r =query(function () {/*
         SELECT * FROM `teacher` WHERE teacherNumber=${sessionUserName}
         */}, context, "");
        if(r.length<1||r==null){
            return {result:false,errormessage:"该教师没有权限"};
        }else{context.teachCollege=r[0].teachCollege;}
    }
    var result = querypagedata(function () {/*
     SELECT
     `teachtask`.tc_class ,CONCAT(`teachtask`.`tc_thweek_start`,"至",`teachtask`.`tc_thweek_end`) AS tc_teachweek,tc_thweek_start,tc_thweek_end,tc_teachmore
     , `course`.chineseName,`teachtask`.tc_studentnum,`teachtask`.tc_numrange,tc_teachway,tc_teachodd,tc_teachmore,tc_checkType,tc_checkStatus,tc_refuseReason,tc_id
     , tc_mainteacherid,courseId ,course.assumeUnit,tc_courseid
     , tc_classteacherid,`a`.`teacherName` AS teacherName,`teacher_1`.`teacherName` AS teacherName1
     ,b.teacherId as bteacherId,b.teacherName as bteacherName
     FROM
     `nxlg`.`teachtask`
     LEFT JOIN `nxlg`.`course`
     ON (`teachtask`.`tc_courseid` = `course`.`courseId`)
     LEFT JOIN `nxlg`.`teacher` as a
     ON (`teachtask`.`tc_mainteacherid` = a.`teacherId`)
     LEFT JOIN `nxlg`.`teacher` AS `teacher_1`
     ON (`teachtask`.`tc_classteacherid` = `teacher_1`.`teacherId`)
     left join  `nxlg`.`teacher`  b  on  b.teachCollege=`course`.`assumeUnit`
     WHERE (`teachtask`.`tc_isDelete` is null or `teachtask`.`tc_isDelete`="否")
     and (`course`.chineseName LIKE CONCAT('%',${searchStr},'%')
     OR `a`.`teacherName` LIKE CONCAT('%',${searchStr},'%')
     OR `teacher_1`.`teacherName` LIKE CONCAT('%',${searchStr},'%')
     OR `teachtask`.tc_class LIKE CONCAT('%',${searchStr},'%'))
     and case when ${type}="教师" then `course`.`assumeUnit`=${teachCollege} else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="0") then (`teachtask`.tc_checkStatus="待审核" or `teachtask`.tc_checkStatus="未通过") else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then (`teachtask`.tc_checkStatus="已通过" ) else 1=1 end
     */},context,"tc_id,tc_courseid,courseId,tc_class,assumeUnit,tc_teachweek,chineseName,tc_studentnum,tc_numrange,tc_thweek_start,tc_thweek_end,tc_teachmore,tc_teachway,tc_teachodd,tc_teachmore,tc_checkType,tc_checkStatus,tc_refuseReason,tc_mainteacherid,tc_classteacherid,teacherName,teacherName1,b:[bteacherId,bteacherName]",context.pageNum,context.pageSize);
    return result;
}
