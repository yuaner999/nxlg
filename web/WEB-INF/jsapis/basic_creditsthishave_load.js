/**
 * Created by NEU on 2017/5/16.
 * 已选分数,本學期不限平台
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
    var term=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=term[0].semester;
    var r= query(function () {/*
     SELECT SUM(`course`.`totalCredit`) as totalthisfenshu
     FROM `nxlg`.`stuchoosecourse`
     LEFT JOIN `nxlg`.`course` 
     ON (`stuchoosecourse`.`courseId` = `course`.`courseId`)
     WHERE studentId=${studentId} AND term=${term}
     */},context,"");
    return r;
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa'
}]