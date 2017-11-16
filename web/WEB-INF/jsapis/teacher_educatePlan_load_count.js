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
    if(context.grade==null){
        context.grade="";
    }
    if(context.college==null){
        context.college="";
    }
    if(context.major==null){
        context.major="";
    }
    if(context.teachCollege==null){
        context.teachCollege="";
    }
    var rr =querypagedata(function () {/*
     select M.*,(case when N.hascount is null then 0 else N.hascount end) hascount
     ,(case when P.checkcount is null then 0 else P.checkcount end) checkcount
     ,(case when Q.uncheckcount is null then 0 else Q.uncheckcount end) uncheckcount
     from (select A.majorId,A.majorCollege,A.majorName,B.wordbookValue gradeName from major A , wordbook B
     where B.wordbookKey='年级' and (isDelete is null or isDelete="否") and checkStatus="已通过"
     and B.wordbookValue LIKE CONCAT('%',${grade},'%') and A.majorCollege LIKE CONCAT('%',${college},'%') and A.majorName LIKE CONCAT('%',${major},'%')
     and case when ${type}="教师" then A.`majorCollege`=${teachCollege} else 1=1 end
     order by A.majorCollege,A.majorName,B.wordbookValue)M
     left join
     (SELECT ep_college,ep_major,ep_grade,COUNT(*) AS hascount FROM `nxlg`.`educateplane`
     WHERE (`educateplane`.ep_isDelete IS NULL OR `educateplane`.ep_isDelete="否") AND `educateplane`.ep_checkStatus="已通过"
     and `educateplane`.ep_grade LIKE CONCAT('%',${grade},'%') and `educateplane`.ep_college LIKE CONCAT('%',${college},'%') and `educateplane`.ep_major LIKE CONCAT('%',${major},'%')
     and case when ${type}="教师" then `educateplane`.`ep_college`=${teachCollege} else 1=1 end
     GROUP BY ep_college,ep_major,ep_grade
     )N on M.majorCollege=N.ep_college and M.majorName=N.ep_major and M.gradeName=N.ep_grade
     left join
     (SELECT ep_college,ep_major,ep_grade,COUNT(*) AS checkcount FROM `nxlg`.`educateplane`
     WHERE (`educateplane`.ep_isDelete IS NULL OR `educateplane`.ep_isDelete="否") AND `educateplane`.ep_checkStatus="待审核"
     and `educateplane`.ep_grade LIKE CONCAT('%',${grade},'%') and `educateplane`.ep_college LIKE CONCAT('%',${college},'%') and `educateplane`.ep_major LIKE CONCAT('%',${major},'%')
     and case when ${type}="教师" then `educateplane`.`ep_college`=${teachCollege} else 1=1 end
     GROUP BY ep_college,ep_major,ep_grade
     )P on M.majorCollege=P.ep_college and M.majorName=P.ep_major and M.gradeName=P.ep_grade
     left join
     (SELECT ep_college,ep_major,ep_grade,COUNT(*) AS uncheckcount FROM `nxlg`.`educateplane`
     WHERE (`educateplane`.ep_isDelete IS NULL OR `educateplane`.ep_isDelete="否") AND `educateplane`.ep_checkStatus="未通过"
     and `educateplane`.ep_grade LIKE CONCAT('%',${grade},'%') and `educateplane`.ep_college LIKE CONCAT('%',${college},'%') and `educateplane`.ep_major LIKE CONCAT('%',${major},'%')
     and case when ${type}="教师" then `educateplane`.`ep_college`=${teachCollege} else 1=1 end
     GROUP BY ep_college,ep_major,ep_grade
     )Q on M.majorCollege=Q.ep_college and M.majorName=Q.ep_major and M.gradeName=Q.ep_grade order by checkcount desc,majorCollege,majorName,gradeName
     */}, context, "",context.pageNum,context.pageSize);
    return rr;
}
