/**
 * Created by NEU on 2017/5/26.
 * 加载该专业对应的培养计划
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT
     `educateplane`.*
     , `course`.`chineseName`
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`
     ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     where (`educateplane`.ep_isDelete is null or `educateplane`.ep_isDelete="否")
     and `educateplane`.ep_checkStatus="已通过" and `educateplane`.ep_college=${ep_college} and `educateplane`.ep_major=${ep_major}
     order by `educateplane`.ep_grade,convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci,convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return result;
}