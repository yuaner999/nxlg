/**
 * Created by NEU on 2017/5/31.
 * 当前学期的培养计划
 */
function main(context) {
    var term=query(function () {/*
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    context.term=term[0].semester.substring(9,13);
    console(context.term);

    var r=query(function () {/*
     SELECT
     COUNT(DISTINCT `student`.studentId) AS snum
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`student`
     ON (`educateplane`.`ep_college` = `student`.`studentCollege`) AND (`educateplane`.`ep_major` = `student`.`studentMajor`) AND (`educateplane`.`ep_grade` = `student`.`studentGrade`)
     WHERE (`educateplane`.ep_isDelete IS NULL OR `educateplane`.ep_isDelete="否") AND `educateplane`.ep_checkStatus="已通过"
     AND `educateplane`.ep_terrace=${terName} AND `educateplane`.ep_courseid=${cour}
     AND `educateplane`.ep_grade=`student`.studentGrade
     AND `educateplane`.ep_college=`student`.studentCollege
     AND `educateplane`.ep_major=`student`.studentMajor
     AND  educateplane.ep_term=${term}
     */},context, "");

    /*查看一个开课课程的详情——培养计划*/
    var rr =query(function () {/*
     SELECT
     `educateplane`.*
     , `course`.*
     , `terrace`.*
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`terrace`
     ON (`educateplane`.`ep_terrace` = `terrace`.`terraceName`)
     LEFT JOIN `nxlg`.`course`
     ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     WHERE (educateplane.ep_isDelete is null or educateplane.ep_isDelete="否") and `educateplane`.ep_checkStatus="已通过"
     and `terrace`.terraceId=${ter} AND `educateplane`.ep_courseid=${cour} and educateplane.ep_term=${term}
     order by convert(`educateplane`.ep_college USING gbk) COLLATE gbk_chinese_ci asc,convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,
     `educateplane`.ep_grade asc
      */},context, "");

    return {r:r,rr:rr};
}