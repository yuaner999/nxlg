/**
 * Created by NEUNB_Lisy on 2017/6/6.
 */
function main(context) {
    var result=querypagedata(function () {/*
        SELECT
        `student`.*
        FROM `nxlg`.`student`
        LEFT JOIN `nxlg`.`stuchoosecourse`
        ON (`stuchoosecourse`.`studentId`=`student`.`studentId`)
        LEFT JOIN `nxlg`.`teachtask`
        ON (`teachtask`.`tc_id`=`stuchoosecourse`.`tc_id`)
        WHERE
        (`student`.`isDelete` IS NULL OR `student`.`isDelete`='否')
        AND `teachtask`.`tc_id`=${tc_id}
        AND
         (
             `student`.`studentNum` LIKE CONCAT('%',${searchStr},'%')
             OR `student`.`studentName` LIKE CONCAT('%',${searchStr},'%')
             OR `student`.`studentGrade` LIKE CONCAT('%',${searchStr},'%')
             OR `student`.`studentCollege` LIKE CONCAT('%',${searchStr},'%')
             OR `student`.`studentMajor` LIKE CONCAT('%',${searchStr},'%')
         )
    */},context,"",context.pageNum,context.pageSize);
    return result;
}