/**
 * Created by NEU on 2017/5/20.
 * 是否这学期这个平台这个时期已经确认选课了
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
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    context.term=term[0].semester;
    var r=query(function () {/*
     SELECT `stuchoosecourse`.`scc` , `stuchoosecourse`.`iscomfirm`
     FROM `nxlg`.`stuchoosecourse`
     LEFT JOIN `nxlg`.`majorterracecourse`
     ON (`stuchoosecourse`.`courseId` = `majorterracecourse`.`courseId`) AND (`stuchoosecourse`.`terraceId` = `majorterracecourse`.`terraceId`)
     where (iscomfirm='1' or iscomfirm='0') and stuchoosecourse.terraceId=${terraceId} and stuchoosecourse.studentId=${studentId} and term=${term}
     */}, context,"");
    return {total:r.length,rows:r};
}
