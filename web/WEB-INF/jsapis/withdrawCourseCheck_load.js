
/**
 * Created by NEU on 2017/5/23.
 */
function main(context){
    if(getsession(context,"sessionUserType")=="学生"){
        return 0;
    }
    var rr= querypagedata(function () {/*
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
     WHERE (`student`.`studentName` LIKE CONCAT('%',${searchStr},'%')
     ) and 
     `stuchoosecourse`.`iscomfirm` = "1" and `stuchoosecourse`.`scc_status` = "退课申请" 
     */},context,"",context.pageNum,context.pageSize);
    return rr;
}
