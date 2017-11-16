/**
 * Created by NEU on 2017/6/7.
 */
function main(context) {
    var r =querypagedata(function () {/*
     SELECT
     `educateplane`.*
     , `course`.*
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`
     ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     WHERE (`educateplane`.ep_isDelete is null or `educateplane`.ep_isDelete="否")
     and `educateplane`.ep_college=${ep_college} and `educateplane`.ep_checkStatus="待审核"
     order by convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,`educateplane`.ep_grade,
     convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci asc
     */}, context, "",context.pageNum,context.pageSize);
    return r;
}
