/**
 * Created by NEU on 2017/6/22.
 * 加载专业，
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT
     `majorterracecourse`.*
     , `major`.*
     , `terrace`.*
     FROM
     `nxlg`.`majorterracecourse`
     LEFT JOIN `nxlg`.`terrace`
     ON (`majorterracecourse`.`terraceId` = `terrace`.`terraceId`)
     LEFT JOIN `nxlg`.`major`
     ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
     WHERE (majorterracecourse.mtc_isDelete IS NULL OR majorterracecourse.mtc_isDelete="否") AND `majorterracecourse`.mtc_checkStatus="已通过"
     AND (major.isDelete IS NULL OR major.isDelete="否") AND `major`.checkStatus="已通过" AND `major`.majorStatus="启用"
     AND majorterracecourse.courseId=${cour}
     order by convert(major.majorCollege USING gbk) COLLATE gbk_chinese_ci,convert(major.majorName USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return result;
}