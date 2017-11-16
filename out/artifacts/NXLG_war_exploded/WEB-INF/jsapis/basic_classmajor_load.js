/**
 * Created by NEU on 2017/6/6.
 */
function main(context) {
    //找学生级
    var n= query(function () {/*
     SELECT `user`.*, `student`.*   FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */},context,"");
    context.studentGrade=n[0].studentGrade;
    //找这个专业的这一级学生
    var t= query(function () {/*
     SELECT COUNT(studentId) AS people FROM student
     where studentMajor=${ep_major} and studentGrade=${studentGrade}
     */},context,"");
    context.people=t[0].people;
    //查某一级专业学生选择的某一级专业课程
    var r1= query(function () {/*
     SELECT   `educateplane`.`ep_major` , `educateplane`.`ep_college` ,`educateplane`.`ep_grade`,educateplane.`ep_courseid`,course.`courseCode`,course.`chineseName`,COUNT(stuchoosecourse.studentId) AS people0
     ,(${people}-COUNT(stuchoosecourse.studentId)) as people1,courseCategory_1
     FROM `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`  ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     LEFT JOIN stuchoosecourse ON (stuchoosecourse.`courseId`=educateplane.`ep_courseid` AND stuchoosecourse.`pass`="已通过") 
     LEFT JOIN student ON (student.`studentId`= stuchoosecourse.`studentId` AND student.`studentGrade`=${studentGrade} AND studentMajor=${ep_major}  AND stuchoosecourse.`pass`="已通过")
     WHERE courseCategory_1 LIKE '%必修%' AND ep_college=${ep_college} AND ep_major=${ep_major}
     AND (`educateplane`.ep_isDelete IS NULL OR `educateplane`.ep_isDelete="否" )AND `educateplane`.ep_checkStatus="已通过"
     AND ep_grade=${studentGrade} AND ((stuchoosecourse.studentId IS NOT NULL AND studentMajor IS NOT NULL) OR (stuchoosecourse.studentId IS NULL AND studentMajor IS NULL))
     GROUP BY educateplane.`ep_courseid`
     */},context,"");
    return r1;
}
var inputsamples=[{
    sessionUserID:'95f8987f-392a-11e7-9e12-00ac9c2c0afa',
    ep_major:'1101111',
    ep_college:'计算机'
}]