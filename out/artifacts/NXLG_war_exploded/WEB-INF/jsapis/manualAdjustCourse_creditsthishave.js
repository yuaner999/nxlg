/**
 * Created by NEU on 2017/5/24
 */
function main(context) {
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