/**
 * Created by NEUNB_Lisy on 2017/5/17.
 * 根据ID值查找空余教室
 */

function main(context) {
    context.userId = getsession(context,"sessionUserID");
    var r=query(function () {/*
     SELECT * FROM `user` WHERE userId=${userId}
     */},context,"");
    context.Id=r[0].typeId;
    var result = querypagedata(function () {/*
     SELECT
     stuName,
     SUM(stuscore) AS totalscore
     FROM
     (SELECT
     scc.courseId,
     scc.studentId,
     (SELECT
     studentname
     FROM
     student s
     WHERE s.studentId = scc.studentId) AS stuname,
     (SELECT
     c.totalCredit
     FROM
     course c
     WHERE c.courseId = scc.courseId) AS stuscore
     FROM
     stuchoosecourse scc
     WHERE iscomfirm = 1
     AND majorId = ${majorId}
     AND studentId != ${Id}
     AND (
     scc.scc_status != '退课通过'
     OR scc.scc_status IS NULL OR scc_status =''
     ))AS a
     GROUP BY studentId
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
