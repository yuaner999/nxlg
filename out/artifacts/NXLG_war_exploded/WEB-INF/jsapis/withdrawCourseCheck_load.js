
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
     or `stuchoosecourse`.`studentId` LIKE CONCAT('%',${searchStr},'%')
     or `stuchoosecourse`.studentNum LIKE CONCAT('%',${searchStr},'%')
     or `stuchoosecourse`.courseCode LIKE CONCAT('%',${searchStr},'%')
     or `stuchoosecourse`.chineseName LIKE CONCAT('%',${searchStr},'%')
     or `terrace`.terraceName LIKE CONCAT('%',${searchStr},'%')
     or `stuchoosecourse`.class LIKE CONCAT('%',${searchStr},'%')
     or `stuchoosecourse`.teacherName LIKE CONCAT('%',${searchStr},'%')
     or `stuchoosecourse`.scc_status LIKE CONCAT('%',${searchStr},'%')
     or `stuchoosecourse`.term LIKE CONCAT('%',${searchStr},'%')
     ) and 
     `stuchoosecourse`.`iscomfirm` = "1" and `stuchoosecourse`.`scc_status` = "退课申请" 
     */},context,"",context.pageNum,context.pageSize);
    return rr;
}
