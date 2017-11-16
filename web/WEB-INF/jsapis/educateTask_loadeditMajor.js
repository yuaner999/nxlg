/**
 * Created by NEU on 2017/6/22.
 * 加载专业，
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT
     `educateplane`.*
     , `major`.*
     , `terrace`.*
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`terrace`
     ON (`educateplane`.`ep_terrace` = `terrace`.`terraceName`)
     LEFT JOIN `nxlg`.`major`
     ON (`educateplane`.`ep_major` = `major`.`majorName`)
     WHERE (educateplane.ep_isDelete is null or educateplane.ep_isDelete="否") and `educateplane`.ep_checkStatus="已通过"
     and (major.isDelete is null or major.isDelete="否") and `major`.checkStatus="已通过" and `major`.majorStatus="启用"
     AND `educateplane`.ep_courseid=${cour}
     GROUP BY `major`.majorId
     order by convert(major.majorCollege USING gbk) COLLATE gbk_chinese_ci,convert(major.majorName USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return result;
}