/**
 * Created by gq on 2017/6/3.
 */
function main(context) {
    var result=query(function () {/*
     SELECT * FROM paymentstatus
     LEFT JOIN student
     ON(paymentstatus.studentId=student.studentId)
     where semester=${semester} and studentClass=${studentClass}
     order by status
     */},context,"");

    return result;
}