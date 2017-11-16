/**
 * Created by NEU on 2017/6/7.
 */
function main(context) {
    var r =querypagedata(function () {/*
     SELECT `majorterracecourse`.*,`major`.*,`terrace`.*,`course`.*
     FROM
     `nxlg`.`majorterracecourse`
     LEFT JOIN `major`
     ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
     LEFT JOIN `terrace`
     ON (`majorterracecourse`.`terraceId` = `terrace`.`terraceId`)
     LEFT JOIN `course`
     ON (`majorterracecourse`.`courseId` = `course`.`courseId`) 
     WHERE (`majorterracecourse`.mtc_isDelete is null or `majorterracecourse`.mtc_isDelete="否")
     and `major`.majorCollege=${college} and `majorterracecourse`.mtc_checkStatus="待审核"
     order by convert(`major`.majorCollege USING gbk) COLLATE gbk_chinese_ci asc,
     convert(`major`.majorName USING gbk) COLLATE gbk_chinese_ci asc
     */}, context, "",context.pageNum,context.pageSize);
    return r;
}
