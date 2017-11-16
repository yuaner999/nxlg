/**
 * Created by NEU on 2017/5/15.
 */
// 加载课程信息
function main(context) {
   // context.type = getsession(context,"sessionUserType");
    context.type = "管理员";
    if(context.type=="学生"){return {result:false,errormessage:"学生用户没有权限"};}
    else if(context.type=="教师"){
        var r =query(function () {/*
         SELECT * FROM `teacher` WHERE teacherNumber=${sessionUserName}
         */}, context, "");
        if(r.length<1||r==null){
            return {result:false,errormessage:"该教师没有权限"};
        }
    }else{}
    var n=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=n[0].semester;
    var result = querypagedata(function () {/*
         SELECT
         `teachtask`.tc_id,tc_courseid ,tc_class,`teacher`.`teacherName`,`tc_thweek_start`,tc_teachodd,`tc_thweek_end`,tc_teachodd
         , `course`.chineseName,assumeUnit,al_timeweek,al_timepitch,classroomName,`teachtask`.`tc_classteacherid` 
         FROM  `nxlg`.`teachtask`
         LEFT JOIN `nxlg`.`course`
         ON (`teachtask`.`tc_courseid` = `course`.`courseId`)
         LEFT JOIN `nxlg`.`teacher`
         ON (`teachtask`.`tc_classteacherid` = `teacher`.`teacherId`)
         LEFT JOIN `nxlg`.`arrangelesson`
         ON arrangelesson.`tc_id`=teachtask.`tc_id`
         WHERE (`teachtask`.`tc_isDelete` IS NULL OR `teachtask`.`tc_isDelete`="否")  AND  `teachtask`.tc_checkStatus="已通过"  and tc_semester=${term}
         and case when ${tc_class} is not null and ${tc_class}<>""  then tc_class LIKE CONCAT('%',${tc_class},'%') else 1=1 end
         and case when ${teacherName} is not null and ${teacherName}<>""  then teacherName LIKE CONCAT('%',${teacherName},'%') else 1=1 end
         and case when ${chineseName} is not null and ${chineseName}<>""  then chineseName LIKE CONCAT('%',${chineseName},'%') else 1=1 end
         and ((${week1} is null or ${week1}='') or (${week1}>= tc_thweek_start AND ${week1}<=tc_thweek_end))
         and al_timeweek LIKE CONCAT('%',${week2},'%')
         and al_timepitch LIKE CONCAT('%',${week3},'%')
         ORDER BY al_timeweek,al_timepitch 
        */},context,"tc_classteacherid,tc_id,tc_courseid,tc_class,teacherName,tc_thweek_start,tc_teachodd,tc_thweek_end,tc_teachodd,chineseName,assumeUnit,times:[al_timeweek,jie:[al_timepitch,classroomName]]"
        ,context.pageNum,context.pageSize);
    return result;
}
var inputsamples=[{
    
}]