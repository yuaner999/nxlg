/**
 * Created by NEU on 2017/6/7.
 */
function main(context) {
    var r =query(function () {/*
     SELECT
     `major`.majorId as majorId,`major`.majorCollege as college,COUNT(*) AS checkall
     FROM
     `nxlg`.`majorterracecourse`
     LEFT JOIN `major`
     ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
     LEFT JOIN `terrace`
     ON (`majorterracecourse`.`terraceId` = `terrace`.`terraceId`)
     LEFT JOIN `course`
     ON (`majorterracecourse`.`courseId` = `course`.`courseId`)
     WHERE (`majorterracecourse`.mtc_isDelete is null or `majorterracecourse`.mtc_isDelete="否")
     and `majorterracecourse`.mtc_checkStatus="待审核"
     GROUP BY `major`.majorCollege
     */}, context, "");
    return r;
}
