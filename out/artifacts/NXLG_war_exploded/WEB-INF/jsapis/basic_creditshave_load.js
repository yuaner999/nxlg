/**
 * Created by NEU on 2017/5/16.
 * 总学分:两个平台的总学分
 */
function main(context) {
    var t=query(function () {/*
     SELECT
     `user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */}, context,"");
    context.studentId=t[0].studentId;
    var r= query(function () {/*
     SELECT SUM(totalCredit) as totalfenshu FROM stuchoosecourse
     INNER JOIN course ON course.`courseId`=stuchoosecourse.`courseId`
     WHERE studentId=${studentId}
     */},context,"");
    return r;
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa'
}]