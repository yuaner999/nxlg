/**
 * Created by zcy on 2017/5/23.
 * 加载学生缴费信息
 */
function main(context) {
    var result=querypagedata(function () {/*
         SELECT paymentstatus.studentId,paymentstatus.semester,paymentstatus.status,student.studentNum,studentName,student.studentCollege,
         student.studentClass,studentPhone,studentEmail,shouldPay
         FROM paymentstatus
         LEFT JOIN student
         ON(paymentstatus.studentId=student.studentId)
         where (student.studentNum LIKE concat('%',${searchStr},'%') or studentName LIKE concat('%',${searchStr},'%'))
         and case when ${college} is not null and ${college} <>'' then studentCollege=${college} else 1=1 end
         and case when ${studentClass} is not null and ${studentClass} <>'' then studentClass=${studentClass} else 1=1 end
         and case when ${semester} is not null and ${semester} <>'' then semester=${semester} else 1=1 end
         order by paymentstatus.status DESC,student.studentNum
    */},context,"",context.pageNum,context.pageSize);
    return result;
}