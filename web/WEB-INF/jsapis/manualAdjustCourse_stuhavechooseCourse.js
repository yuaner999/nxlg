/**
 * Created by NEU on 2017/5/24.
 * 总学分:两个平台的总学分
 */
function main(context) {
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
