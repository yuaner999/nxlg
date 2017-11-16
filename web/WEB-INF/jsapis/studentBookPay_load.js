/**
 * Created by NEU on 2017/5/19.
 * 获取当前学生的当前学期的教材信息+缴费信息
 */
function main(context){
    //根据登录用户Id查找该学生在学生表ID
    var rs=query(function () {/*
     select typeId from user where userId=${sessionUserID} and typeName='学生'
     */},context,"");
    if(rs.length==0){//学生表中没有该用户信息
        context.error=false;
        return 1;
    }
    context.studentId=rs[0].typeId;
    //获取当前学期
    var result=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */},context,"");
    context.semester=result[0].semester;
    //获取学生选课的教材信息
    var r=querypagedata(function () {/*
     SELECT DISTINCT(course.courseCode),student.studentNum,student.studentName,paymentstatus.realPay,course.sparecoursebookid,course.issparecourse,course.chineseName,teachingmaterials.name,teachingmaterials.press,teachingmaterials.edition,teachingmaterials.booknumber,teachingmaterials.price
     FROM stuchoosecourse
     LEFT JOIN course
     ON(stuchoosecourse.courseId=course.courseId)
     LEFT JOIN teachingmaterials
     ON(teachingmaterials.tmId=course.coursebookid )
     LEFT JOIN paymentstatus
     ON(paymentstatus.studentId=stuchoosecourse.studentId)
     LEFT JOIN student
     ON(student.studentId=stuchoosecourse.studentId)
     WHERE stuchoosecourse.studentId=${studentId}
     AND stuchoosecourse.term=${semester}
     AND CASE WHEN (paymentstatus.semester='' OR paymentstatus.semester=NULL) THEN 1=1 ELSE paymentstatus.semester=${semester} END
     AND course.checkStatus='已通过'
     AND course.courseStatus='启用'
     AND course.issparecourse='0'
     AND stuchoosecourse.iscomfirm='1'
     UNION
     SELECT DISTINCT(course.courseCode),student.studentNum,student.studentName,paymentstatus.realPay,course.sparecoursebookid,course.issparecourse,course.chineseName,teachingmaterials.name,teachingmaterials.press,teachingmaterials.edition,teachingmaterials.booknumber,teachingmaterials.price
     FROM stuchoosecourse
     LEFT JOIN course
     ON(stuchoosecourse.courseId=course.courseId)
     LEFT JOIN teachingmaterials
     ON(teachingmaterials.tmId=course.sparecoursebookid )
     LEFT JOIN paymentstatus
     ON(paymentstatus.studentId=stuchoosecourse.studentId)
     LEFT JOIN student
     ON(student.studentId=stuchoosecourse.studentId)
     WHERE stuchoosecourse.studentId=${studentId}
     AND stuchoosecourse.term=${semester}
     AND CASE WHEN (paymentstatus.semester='' OR paymentstatus.semester=NULL) THEN 1=1 ELSE paymentstatus.semester=${semester} END
     AND course.checkStatus='已通过'
     AND course.courseStatus='启用'
     AND course.issparecourse='1'
     AND stuchoosecourse.iscomfirm='1'
     */},context,"",context.pageNum,context.pageSize);
    var r1=query(function () {/*
     select shouldPay,status from paymentstatus where studentId= ${studentId} and `semester`=${semester}
     */},context,"");
    if(r1.length>0){
        r.status=r1[0].status;
        r.shouldPay=r1[0].shouldPay;
        r.semester=context.semester;
        r.studentId=context.studentId;
    }
    return r;
}

var inputsamples=[{
    sessionUserID:"2f9f7ca0-45a2-11e7-a0d1-00ac9c2c0afa"
}]