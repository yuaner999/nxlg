/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
        //加载每个专业的平台课程(学生的年级)
        //学生的年级
         var t=query(function () {/*
         SELECT  `user`.*, `student`.* FROM `user`
         LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
         WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
         */}, context,"");
         context.studentGrade=t[0].studentGrade;
         var r=query(function () {/*
         select semester from arrangecourse where is_now="1"
         */}, context,"");
         context.term=r[0].semester;
         context.term1=context.term.substring(context.term.length-4,context.term.length);
       //总专业课程
        var result = querypagedata(function () {/*
         SELECT  mtc_id,majorId,terraceId,`courseload`.courseId,mtc_courseTerm,mtc_majorWay,mtc_note,mtc_checkStatus,mtc_isDelete,tmId,
         name,press,edition,booknumber,price,tc_id,tc_courseid,tc_mainteacherid,tc_class,tc_classteacherid,tc_numrange,tc_teachway,
         tc_thweek_start,tc_thweek_end,tc_teachodd,tc_teachmore,tc_checkType,tc_checkStatus,teacherId,teacherNumber,teacherName,department,administrative,
         teachUnit,duty,dutyDate,dutyLevel,education,educationMajor,educationSchool,educationStructure,degree,certificate,teachDate,teachMajor,teachSection,
         teachStatus,teachArea,certificateLevel,courseCode,assumeUnit,chineseName,coursebookid,totalCredit,totalTime,courseCategory_3,
         courseCategory_4,courseCategory_5,majorName,al_timeweek,al_timepitch,classroomId,classroomName,tc_studentnum,tcm_majorid,tcm_id,tcm_grade,sumcourse
         FROM `courseload`
         LEFT JOIN
         (SELECT courseId,COUNT(*) AS sumcourse FROM `stuchoosecourse` WHERE scc_status <> '退课通过' OR scc_status IS NULL GROUP BY courseId ) conutcourse
         ON conutcourse.courseId = `courseload`.`courseId`
         WHERE terraceId=${terraceId}  AND tcm_grade =${studentGrade}
         and ((${keytname} is null or ${keytname}='') or(teacherName like concat('%',${keytname},'%')))
         and ((${keyroom} is null or ${keyroom}='') or (classroomName like concat('%',${keyroom},'%')))
         and ((${keyunit} is null or ${keyunit}='') or (assumeUnit like concat('%',${keyunit},'%')))
         and ((${keyMajor} is null or ${keyMajor}='') or(majorName like concat('%',${keyMajor},'%')))
         and ((${keytime} is null or ${keytime}='') or (${keytime}>= tc_thweek_start AND ${keytime}<=tc_thweek_end))
         AND CASE WHEN ((${studentMajor} IS NULL OR ${studentMajor}='') AND (${otherMajor} IS NULL OR ${otherMajor}='' ))THEN 1=1 ELSE 1=1 END
         AND CASE WHEN ((${studentMajor} IS NOT NULL AND ${studentMajor}!='' )AND (${otherMajor} IS NOT NULL AND ${otherMajor}!=''))THEN (majorName=${studentMajor} OR majorName=${otherMajor})ELSE 1=1 END
         AND CASE WHEN ((${studentMajor} IS NOT NULL AND ${studentMajor}!='') AND (${otherMajor} IS NULL OR ${otherMajor}='' ))  THEN (majorName=${studentMajor})ELSE 1=1 END
         AND CASE WHEN ((${studentMajor} IS NULL OR ${studentMajor}='') AND (${otherMajor} IS NOT NULL AND ${otherMajor}!='' ))THEN (majorName=${otherMajor})ELSE 1=1 END
         and mtc_courseTerm=${term}
         order by convert(majorName USING gbk) COLLATE gbk_chinese_ci,al_timeweek,al_timepitch
         */},context, "tc_studentnum,mtc_id,majorId,terraceId,courseId,mtc_courseTerm,mtc_majorWay,mtc_note,mtc_checkStatus,mtc_isDelete,tmId,name,press,edition,booknumber,price,tc_id,tc_courseid,tc_mainteacherid,tc_class,tc_classteacherid,tc_numrange,tc_teachway,tc_thweek_start,tc_thweek_end,tc_teachodd,tc_teachmore,tc_checkType,tc_checkStatus,teacherId,teacherNumber,teacherName,department,administrative,teachUnit,duty,dutyDate,dutyLevel,education,educationMajor,educationSchool,educationStructure,degree,certificate,teachDate,teachMajor,teachSection,teachStatus,teachArea,certificateLevel,courseCode,assumeUnit,chineseName,coursebookid,totalCredit,totalTime,courseCategory_3,courseCategory_4,courseCategory_5,majorName,tcm_majorid,tcm_id,tcm_grade,sumcourse,times:[al_timeweek,jie:[al_timepitch,classroomId,classroomName]]"
            ,context.pageNum,context.pageSize);
    return result;
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa',
    studentMajor:'',
    otherMajor:'',
    terraceId:'f2be64fb-24c4-11e7-942b-00ac9c2c0afa'
}]