/**
 * Created by NEU on 2017/5/2.
 */
function main(context) {
    //培养计划审核
    var r =querypagedata(function () {/*
     SELECT
     `educateplane`.*
     , `course`.*
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`
     ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     WHERE (`educateplane`.ep_isDelete is null or `educateplane`.ep_isDelete="否") 
     and (`educateplane`.ep_grade LIKE CONCAT('%',${searchStr},'%') OR `educateplane`.ep_college LIKE CONCAT('%',${searchStr},'%') OR `educateplane`.ep_major LIKE CONCAT('%',${searchStr},'%')
     OR `educateplane`.ep_term LIKE CONCAT('%',${searchStr},'%') OR `course`.chineseName LIKE CONCAT('%',${searchStr},'%') OR `educateplane`.ep_terrace LIKE CONCAT('%',${searchStr},'%'))
     and (`educateplane`.ep_checkStatus="已通过" or `educateplane`.ep_checkStatus="未通过") 
     order by convert(`educateplane`.ep_college USING gbk) COLLATE gbk_chinese_ci asc,convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,
     `educateplane`.ep_grade,convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci asc
     */}, context, "",context.pageNum,context.pageSize);
    return r;
}

    var inputsamples=[{
    }]
