/**
 * Created by gq on 2017/6/3.
 */
function main(context) {

    var className=query(function () {/*
     SELECT studentClass FROM paymentstatus
     LEFT JOIN student
     ON(paymentstatus.studentId=student.studentId)
     GROUP BY studentClass
     */},context,"");

    var semester=query(function () {/*
     SELECT semester FROM paymentstatus
     LEFT JOIN student
     ON(paymentstatus.studentId=student.studentId)
     GROUP BY semester
     */},context,"");

    return {className:className,semester:semester};
}