/**
 * Created by NEU on 2017/5/3.
 */
function main(context) {
    context.type = getsession(context,"sessionUserType");
    if(context.type=="学生"){return {result:false,errormessage:"学生用户没有权限"};}
    else if(context.type=="教师"){
        var r =query(function () {/*
         SELECT * FROM `teacher` WHERE teacherNumber=${sessionUserName}
         */}, context, "");
        if(r.length<1||r==null){
            return {result:false,errormessage:"该教师没有权限"};
        }else{context.teachCollege=r[0].teachCollege;}
    }
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
     and case when ${checkType} is not null and ${checkType}<>""  then `educateplane`.ep_checkType = ${checkType} else 1=1 end
     and case when ${checkStatus} is not null and ${checkStatus}<>""  then `educateplane`.ep_checkStatus = ${checkStatus} else 1=1 end
     and (`course`.`chineseName` LIKE CONCAT('%',${searchStr},'%'))
     and `educateplane`.ep_term LIKE CONCAT('%',${ep_term},'%')
     and `educateplane`.ep_terrace like CONCAT('%',${terraceName},'%')
     and case when ${type}="教师" then `educateplane`.`ep_college`=${teachCollege} else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then `educateplane`.ep_checkStatus="已通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="2" then `educateplane`.ep_checkStatus="未通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then (`educateplane`.ep_checkStatus="待审核") else 1=1 end
     order by convert(`educateplane`.ep_college USING gbk) COLLATE gbk_chinese_ci asc,convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,
     `educateplane`.ep_grade,
     convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci asc
     */}, context,"");

    var rr =querypagedata(function () {/*
     SELECT
     `educateplane`.*
     , `course`.*
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`
     ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     WHERE (`educateplane`.ep_isDelete is null or `educateplane`.ep_isDelete="否")
     and `educateplane`.ep_grade LIKE ${grade} and `educateplane`.ep_college LIKE ${college} and `educateplane`.ep_major LIKE ${major}
     and case when ${checkType} is not null and ${checkType}<>""  then `educateplane`.ep_checkType = ${checkType} else 1=1 end
     and case when ${checkStatus} is not null and ${checkStatus}<>""  then `educateplane`.ep_checkStatus = ${checkStatus} else 1=1 end
     and (`course`.`chineseName` LIKE CONCAT('%',${searchStr},'%'))
     and `educateplane`.ep_term LIKE CONCAT('%',${ep_term},'%')
     and `educateplane`.ep_terrace like CONCAT('%',${terraceName},'%')
     and case when ${type}="教师" then `educateplane`.`ep_college`=${teachCollege} else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then `educateplane`.ep_checkStatus="已通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="2" then `educateplane`.ep_checkStatus="未通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then (`educateplane`.ep_checkStatus="待审核") else 1=1 end
     order by convert(`educateplane`.ep_college USING gbk) COLLATE gbk_chinese_ci asc,convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,
     `educateplane`.ep_grade,
     convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci asc
     */}, context, "",context.pageNum,context.pageSize);
    return  {result:rr,totalCredit:totalCredit};
}
