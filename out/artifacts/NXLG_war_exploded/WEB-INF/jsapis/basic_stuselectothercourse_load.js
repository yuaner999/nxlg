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
    context.studentId=t[0].studentId;
    var semester=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=semester[0].semester;
    //总专业课程
    var result = querypagedata(function () {/*
         SELECT `arrangelesson`.`al_timepitch` , `arrangelesson`.`al_timeweek` , `arrangelesson`.`classroomId` , `arrangelesson`.`classroomName`
         , `stuchoosecourse`.`chineseName` , `stuchoosecourse`.`class`  , `stuchoosecourse`.`courseCode` , `stuchoosecourse`.`courseId` , `course`.`totalCredit`
         , `stuchoosecourse`.`scc`  , `stuchoosecourse`.`teacherName`  , `stuchoosecourse`.`terraceId`  , `majorterracecourse`.`majorId` , `teachtask`.`tc_numrange`
         , `teachtask`.`tc_teachweek` , `teachtask`.`tc_teachodd` , `majorterracecourse`.`majorId` , `major`.`majorName` , `course`.`assumeUnit`, `course`.`totalTime`
         FROM  `nxlg`.`stuchoosecourse`
         LEFT JOIN `nxlg`.`teachtask`
         ON (`stuchoosecourse`.`courseId` = `teachtask`.`tc_courseid`) AND (`stuchoosecourse`.`class` = `teachtask`.`tc_class`)
         LEFT JOIN `nxlg`.`majorterracecourse`
         ON (`stuchoosecourse`.`terraceId` = `majorterracecourse`.`terraceId`) AND (`stuchoosecourse`.`courseId` = `majorterracecourse`.`courseId`)
         LEFT JOIN `nxlg`.`course`
         ON (`stuchoosecourse`.`courseId` = `course`.`courseId`)
         LEFT JOIN `nxlg`.`arrangelesson`
         ON (`teachtask`.`tc_id` = `arrangelesson`.`tc_id`)
         LEFT JOIN `nxlg`.`major`
         ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
         where studentId=${studentId} and term=${term} and majorName<>${studentMajor} and majorName<>${otherMajor} and stuchoosecourse.terraceId=${terraceId}
         */},context, "totalTime,totalCredit,tc_numrange,chineseName,class,terraceId,courseCode,courseId,scc,teacherName,terraceId,majorId,tc_teachweek,tc_teachodd,majorId,majorName,assumeUnit,times:[al_timeweek,jie:[al_timepitch,classroomId,classroomName]]"
        ,context.pageNum,context.pageSize);
    return result;
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa',
    studentMajor:'no',
    otherMajor:'no',
    terraceId:'f2be64fb-24c4-11e7-942b-00ac9c2c0afa'
    // keytime:'7'
}]
