/**
 * Created by gq on 2017/6/3.
 * 学生缴费信息统计
 */
function main(context) {
    var statistics=querypagedata(function () {/*
     SELECT semester,studentClass,COUNT(*) as total,SUM(IF(`status`="未缴费", 0, 1)) as noPay,SUM(IF(`status`="已缴费", 0, 1)) as alreadyPayed
     FROM paymentstatus
     LEFT JOIN student
     ON(paymentstatus.studentId=student.studentId)
     where 1=1
     and case when ${className} is not null and ${className}<>'' then studentClass=${className} else 1=1 end
     and case when ${semester} is not null and ${semester}<>'' then semester=${semester} else 1=1 end
     GROUP BY studentClass,semester
     */},context,"",context.pageNum,context.pageSize);

    var className=query(function () {/*
     select * from class
     */},context,"");

    var semester=query(function () {/*
     SELECT semester FROM paymentstatus
     LEFT JOIN student
     ON(paymentstatus.studentId=student.studentId)
     GROUP BY semester
     */},context,"");

    return {statistics:statistics,className:className,semester:semester};
}