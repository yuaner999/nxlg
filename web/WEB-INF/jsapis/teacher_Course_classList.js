/**
 * Created by NEU on 2017/4/27.
 */
function main(context) {
    var semester=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=semester[0].semester;
    //专业平台课程设置
    var rr =querypagedata(function () {/*
     SELECT teachtask.`tc_class`,course.`courseId`,course.`chineseName`,teachtask.`tc_id`,tc_semester,tc_teachway,a.teacherName as ateacherName,b.teacherName as bteacherName FROM `nxlg`.`teachtask`
     LEFT JOIN course ON course.`courseId`=teachtask.`tc_courseid`
     left join teacher  a on a.teacherId=teachtask.tc_classteacherid
     left join teacher  b on b.teacherId=teachtask.tc_mainteacherid
     WHERE  tc_courseid=${courseId}
     AND (`teachtask`.`tc_isDelete` IS NULL OR `teachtask`.`tc_isDelete` ="否") AND `tc_checkStatus`='已通过'
     AND tc_semester=${term}
     */}, context,"",context.pageNum,context.pageSize);
    return rr;
}

var inputsamples=[{
}]
