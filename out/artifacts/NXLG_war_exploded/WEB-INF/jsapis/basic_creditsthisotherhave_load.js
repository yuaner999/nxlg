/**
 * Created by NEU on 2017/5/16.
 * 已选分数（本学期本阶段（其他专业）,不限平台
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
     LEFT JOIN `nxlg`.`majorterracecourse` 
     ON (`stuchoosecourse`.`terraceId` = `majorterracecourse`.`terraceId`) AND (`stuchoosecourse`.`courseId` = `majorterracecourse`.`courseId`)
     LEFT JOIN `nxlg`.`course` 
     ON (`stuchoosecourse`.`courseId` = `course`.`courseId`)
     LEFT JOIN `nxlg`.`major` 
     ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
     WHERE studentId=${studentId} AND term=${term} and majorName<>${studentMajor} and majorName<>${otherMajor} 
     */},context,"");
    return r;
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa'
}]