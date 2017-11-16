/**
 * Created by NEU on 2017/5/18.
 */
function main(context) {
    var result = querypagedata(function () {/*
     SELECT
     `user`.*
     , `course`.*
     , `teacher`.*
     , `teachingmaterials`.*
     FROM
     `nxlg`.`user`
     LEFT JOIN `nxlg`.`course` 
     ON (`user`.`typeId` = `course`.`mainteacherid`)
     LEFT JOIN `nxlg`.`teacher` 
     ON (`course`.`mainteacherid` = `teacher`.`teacherId`)
     LEFT JOIN `nxlg`.`teachingmaterials` 
     ON (`course`.`coursebookid` = `teachingmaterials`.`tmId`)
     WHERE (courseCode LIKE CONCAT('%',${searchStr},'%') OR chineseName LIKE CONCAT('%',${searchStr},'%'))
     and `course`.checkStatus="待写教材" and `user`.userId=${sessionUserID}
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
