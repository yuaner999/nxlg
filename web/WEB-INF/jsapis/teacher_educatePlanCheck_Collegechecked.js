/**
 * Created by NEU on 2017/6/7.
 */
function main(context) {
    var totalCredit = query(function () {/*
     SELECT
     SUM(course.`totalCredit`) AS totalCredit
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`
     ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     WHERE (`educateplane`.ep_isDelete is null or `educateplane`.ep_isDelete="否")
     and `educateplane`.ep_grade LIKE ${grade} and `educateplane`.ep_college LIKE ${college} and `educateplane`.ep_major LIKE ${major}
     and case when ${checkType} is not null and ${checkType}<>""  then ep_checkType = ${checkType} else 1=1 end
     and `educateplane`.ep_checkStatus="待审核"
     order by convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,`educateplane`.ep_grade,
     convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci asc
     */}, context,"");

    var r =querypagedata(function () {/*
     SELECT
     `educateplane`.*
     , `course`.*
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`
     ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     WHERE (`educateplane`.ep_isDelete is null or `educateplane`.ep_isDelete="否")
     and `educateplane`.ep_grade LIKE ${grade} and `educateplane`.ep_college LIKE ${college} and `educateplane`.ep_major LIKE ${major}
     and case when ${checkType} is not null and ${checkType}<>""  then ep_checkType = ${checkType} else 1=1 end
     and `educateplane`.ep_checkStatus="待审核"
     order by convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,`educateplane`.ep_grade,
     convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci asc
     */}, context, "",context.pageNum,context.pageSize);
    return {result:r,totalCredit:totalCredit};
}
