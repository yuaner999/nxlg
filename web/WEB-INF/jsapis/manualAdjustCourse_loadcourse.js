/**
 * Created by NEU on 2017/5/20.
 */
function main(context) {
    //总专业课程
    //加载每个专业的平台课程(学生的年级)
    //学生的年级
    var r=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=r[0].semester;
    context.term1=context.term.substring(context.term.length-4,context.term.length);
    //总专业课程
    var result = querypagedata(function () {/*
         SELECT  mtc_id,majorId,terraceId,courseId,mtc_courseTerm,mtc_majorWay,mtc_note,mtc_checkStatus,mtc_isDelete,tmId,
         name,press,edition,booknumber,price,tc_id,tc_courseid,tc_mainteacherid,tc_class,tc_classteacherid,tc_numrange,tc_teachway,
         tc_thweek_start,tc_thweek_end,tc_teachodd,tc_teachmore,tc_checkType,tc_checkStatus,teacherId,teacherNumber,teacherName,department,administrative,
         teachUnit,duty,dutyDate,dutyLevel,education,educationMajor,educationSchool,educationStructure,degree,certificate,teachDate,teachMajor,teachSection,
         teachStatus,teachArea,certificateLevel,courseCode,assumeUnit,chineseName,coursebookid,totalCredit,totalTime,courseCategory_3,
         courseCategory_4,courseCategory_5,majorName,al_timeweek,al_timepitch,classroomId,classroomName,tc_studentnum,tcm_majorid,tcm_id,tcm_grade
         FROM `courseload`
         WHERE terraceId=${terraceId}  AND tcm_grade =${studentGrade}
         and majorId=${majorId}
         and ((${keytname} is null or ${keytname}='') or(teacherName like concat('%',${keytname},'%')))
         and ((${keyroom} is null or ${keyroom}='') or (classroomName like concat('%',${keyroom},'%')))
         and ((${keyunit} is null or ${keyunit}='') or (assumeUnit like concat('%',${keyunit},'%')))
         and ((${keytime} is null or ${keytime}='') or (${keytime}>= tc_thweek_start AND ${keytime}<=tc_thweek_end))
         and mtc_courseTerm=${term} ORDER BY tcm_id
         */},context, "tc_studentnum,mtc_id,majorId,terraceId,courseId,mtc_courseTerm,mtc_majorWay,mtc_note,mtc_checkStatus,mtc_isDelete,tmId,name,press,edition,booknumber,price,tc_id,tc_courseid,tc_mainteacherid,tc_class,tc_classteacherid,tc_numrange,tc_teachway,tc_thweek_start,tc_thweek_end,tc_teachodd,tc_teachmore,tc_checkType,tc_checkStatus,teacherId,teacherNumber,teacherName,department,administrative,teachUnit,duty,dutyDate,dutyLevel,education,educationMajor,educationSchool,educationStructure,degree,certificate,teachDate,teachMajor,teachSection,teachStatus,teachArea,certificateLevel,courseCode,assumeUnit,chineseName,coursebookid,totalCredit,totalTime,courseCategory_3,courseCategory_4,courseCategory_5,majorName,tcm_majorid,tcm_id,tcm_grade,times:[al_timeweek,jie:[al_timepitch,classroomId,classroomName]]"
        ,context.pageNum,context.pageSize);
   // console(result);
    return result;
}
