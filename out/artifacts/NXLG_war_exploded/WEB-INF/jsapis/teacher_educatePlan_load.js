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
    var rr =querypagedata(function () {/*
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
     and case when ${type}="教师" then `educateplane`.`ep_college`=${teachCollege} else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then `educateplane`.ep_checkStatus="已通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then (`educateplane`.ep_checkStatus="待审核" or `educateplane`.ep_checkStatus="未通过") else 1=1 end
     order by convert(`educateplane`.ep_college USING gbk) COLLATE gbk_chinese_ci asc,convert(`educateplane`.ep_major USING gbk) COLLATE gbk_chinese_ci asc,
     `educateplane`.ep_grade,
     convert(`educateplane`.ep_term USING gbk) COLLATE gbk_chinese_ci asc
     */}, context, "",context.pageNum,context.pageSize);
    return rr;
}
