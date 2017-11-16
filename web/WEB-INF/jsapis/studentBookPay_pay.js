/**
 * Created by NEU on 2017/5/19.
 * 学生教材缴费
 */
function main(context) {
    //基础数据非空判断
    if(context.studentId == null||context.semester == null||context.payNum == null||context.shouldPay == null){
        return false;
    }
    var r=query(function () {/*
        SELECT SUM(price) AS totalprice
        FROM teachingmaterials
        WHERE booknumber IN(
            SELECT DISTINCT teachingmaterials.booknumber
        FROM stuchoosecourse
        LEFT JOIN course
        ON(stuchoosecourse.courseId=course.courseId)
        LEFT JOIN teachingmaterials
        ON(teachingmaterials.tmId=course.coursebookid )
        LEFT JOIN student
        ON(student.studentId=stuchoosecourse.studentId)
        WHERE stuchoosecourse.studentId=${studentId}
        AND stuchoosecourse.term=${semester}
        AND course.checkStatus='已通过'
        AND course.courseStatus='启用'
        AND course.issparecourse='0'
        AND stuchoosecourse.iscomfirm='1'
        UNION
        SELECT DISTINCT teachingmaterials.booknumber
        FROM stuchoosecourse
        LEFT JOIN course
        ON(stuchoosecourse.courseId=course.courseId)
        LEFT JOIN teachingmaterials
        ON(teachingmaterials.tmId=course.sparecoursebookid )
        LEFT JOIN student
        ON(student.studentId=stuchoosecourse.studentId)
        WHERE stuchoosecourse.studentId=${studentId}
        AND stuchoosecourse.term=${semester}
        AND course.checkStatus='已通过'
        AND course.courseStatus='启用'
        AND course.issparecourse='1'
        AND stuchoosecourse.iscomfirm='1')
     */},context,"");
    if(r[0].totalprice==context.payNum){
        var result=exec(function () {/*
         update paymentstatus
         set
         `realPay`=${payNum},
         `status`="已缴费",
         `is_auto`="1"
         where studentId= ${studentId} and `semester`=${semester}
         */},context);
        return result;
    }else{
        return 1;
    }
}

var inputsamples=[
    {
        studentId:"123",
        semester:"2016/2017第二学期",
        payNum:"50",
        shouldPay:"50"
    }
]