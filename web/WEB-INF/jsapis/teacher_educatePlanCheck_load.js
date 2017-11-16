/**
 * Created by NEU on 2017/5/2.
 */
function main(context) {
    if(context.ep_term==null){
        context.ep_term="";
    }
    if(context.terraceName==null){
        context.terraceName="";
    }

    var totalCredit = query(function () {/*
     SELECT
     SUM(course.`totalCredit`) AS totalCredit
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`
     ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     WHERE (`educateplane`.ep_isDelete is null or `educateplane`.ep_isDelete="否")
     and `educateplane`.ep_grade LIKE ${grade} and `educateplane`.ep_college LIKE ${college} and `educateplane`.ep_major LIKE ${major}
     and `educateplane`.ep_term LIKE CONCAT('%',${ep_term},'%') and `course`.chineseName LIKE CONCAT('%',${searchStr},'%') and `educateplane`.ep_terrace like CONCAT('%',${terraceName},'%')
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then `educateplane`.ep_checkStatus="待审核" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="2" then `educateplane`.ep_checkStatus="未通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then (`educateplane`.ep_checkStatus="已通过" ) else 1=1 end
     order by convert(`educateplane`.ep_college USING gbk) COLLATE gbk_chinese_ci asc,convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,
     `educateplane`.ep_grade,convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci asc
     */}, context,"");

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
     and `educateplane`.ep_grade LIKE ${grade} and `educateplane`.ep_college LIKE ${college} and `educateplane`.ep_major LIKE ${major}
     and `educateplane`.ep_term LIKE CONCAT('%',${ep_term},'%') and `course`.chineseName LIKE CONCAT('%',${searchStr},'%') and `educateplane`.ep_terrace like CONCAT('%',${terraceName},'%')
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then `educateplane`.ep_checkStatus="待审核" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="2" then `educateplane`.ep_checkStatus="未通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then (`educateplane`.ep_checkStatus="已通过" ) else 1=1 end
     order by convert(`educateplane`.ep_college USING gbk) COLLATE gbk_chinese_ci asc,convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,
     `educateplane`.ep_grade,convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci asc
     */}, context, "",context.pageNum,context.pageSize);

    return {result:r,totalCredit:totalCredit};
}

    var inputsamples=[{
    }]
