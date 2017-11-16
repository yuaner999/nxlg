/**
 * Created by NEU on 2017/5/20.
 */
function main(context){
   // console(context.studentId);
    var r=query(function () {/*
     SELECT
     `stuchoosecourse`.*
     , `course`.`courseCategory_3`
     , `terrace`.*
     , `course`.`courseCategory_4`
     , `course`.`courseCategory_5`
     , `student`.`studentName`
     FROM
     `nxlg`.`stuchoosecourse`
     LEFT JOIN `nxlg`.`course`
     ON (`stuchoosecourse`.`courseId` = `course`.`courseId`)
     LEFT JOIN `nxlg`.`terrace`
     ON (`stuchoosecourse`.`terraceId` = `terrace`.`terraceId`)
     LEFT JOIN `nxlg`.`student`
     ON (`stuchoosecourse`.`studentId` = `student`.`studentId`)
     WHERE `stuchoosecourse`.`iscomfirm` = "1" and `stuchoosecourse`.`studentId`=${studentId}
     */},context,"");
    return r;
}
