/**
 * Created by NEU on 2017/6/6.
 */
function main(context) {
    //找这一级的学生
    var n= query(function () {/*
     SELECT `user`.*, `student`.*   FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */},context,"");
    context.studentGrade=n[0].studentGrade;
    //找这个专业的这一级学生
    var t= query(function () {/*
     select studentId from student
     where studentMajor=${ep_major} and studentGrade=${studentGrade}
     */},context,"");
    //找这个专业这一级培养计划必修课的总学分
    var total= query(function () {/*
     SELECT   `educateplane`.`ep_major` , `educateplane`.`ep_college` ,`educateplane`.`ep_grade`,SUM(totalCredit) as totalCredit
     FROM `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`  ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     WHERE courseCategory_1 LIKE '%必修%'
     AND ep_college=${ep_college} AND ep_major=${ep_major}
     AND (`educateplane`.ep_isDelete IS NULL OR `educateplane`.ep_isDelete="否" )AND `educateplane`.ep_checkStatus="已通过"
     AND ep_grade=${studentGrade};
     */},context,"");
    context.totalCredit=total[0].totalCredit;
    //查某一级专业学生选择的某一级专业课程
    var r1= query(function () {/*
     SELECT COUNT(IF(a.fenshu<0.1,TRUE,NULL)) AS sum1 ,COUNT(IF(0.59>=a.fenshu>=0.1,TRUE,NULL)) AS sum2,
     COUNT(IF(1>a.fenshu>0.59,TRUE,NULL)) AS sum3,COUNT(IF(a.fenshu=1,TRUE,NULL)) AS sum4,a.studentGrade,a.`studentMajor`
     FROM 
     (SELECT SUM(course.`totalCredit`)/${totalCredit} AS fenshu,student.`studentName`,student.`studentId`,student.studentGrade,student.studentMajor
     FROM student
     LEFT JOIN stuchoosecourse ON student.`studentId`=stuchoosecourse.`studentId` AND stuchoosecourse.`pass`='已通过'
     LEFT JOIN course ON stuchoosecourse.`courseId`=course.`courseId`
     LEFT JOIN educateplane ON ( educateplane.`ep_courseid`=course.`courseId` AND educateplane.`ep_grade`=${studentGrade} AND educateplane.`ep_major`=${ep_major} AND educateplane.`courseCategory_1` LIKE '%必修%'
     AND educateplane.`ep_college`=${ep_college} AND (`educateplane`.ep_isDelete IS NULL OR `educateplane`.ep_isDelete="否" )AND `educateplane`.ep_checkStatus="已通过")
     WHERE student.`studentGrade`=${studentGrade} AND studentMajor=${ep_major}
     GROUP BY student.studentId 
     )a 
     */},context,"");
    for (var i=0;i<r1.length;i++){
        r1[i].studentGrade=context.studentGrade;
    }
    return r1;
}
var inputsamples=[{
    sessionUserID:'95f8987f-392a-11e7-9e12-00ac9c2c0afa',
    ep_major:'1101111',
    ep_college:'计算机'
}]
