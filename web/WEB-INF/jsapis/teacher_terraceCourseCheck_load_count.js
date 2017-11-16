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
     (SELECT majorName,majorCollege,mtc_grade,COUNT(*) AS hascount FROM `nxlg`.`majorterracecourse`
     LEFT JOIN `major`
     ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
     WHERE (`majorterracecourse`.mtc_isDelete IS NULL OR `majorterracecourse`.mtc_isDelete="否") AND `majorterracecourse`.mtc_checkStatus="已通过"
     and `majorterracecourse`.mtc_grade LIKE CONCAT('%',${grade},'%') and `major`.majorCollege LIKE CONCAT('%',${college},'%') and `major`.majorName LIKE CONCAT('%',${major},'%')
     and case when ${type}="教师" then `major`.majorCollege=${teachCollege} else 1=1 end
     GROUP BY `major`.majorCollege,`major`.majorName,mtc_grade
     )N on M.majorCollege=N.majorCollege and M.majorName=N.majorName and M.gradeName=N.mtc_grade
     left join
     (SELECT majorCollege,majorName,mtc_grade,COUNT(*) AS checkcount FROM `nxlg`.`majorterracecourse`
     LEFT JOIN `major`
     ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
     WHERE (`majorterracecourse`.mtc_isDelete IS NULL OR `majorterracecourse`.mtc_isDelete="否") AND `majorterracecourse`.mtc_checkStatus="待审核"
     and `majorterracecourse`.mtc_grade LIKE CONCAT('%',${grade},'%') and `major`.majorCollege LIKE CONCAT('%',${college},'%') and `major`.majorName LIKE CONCAT('%',${major},'%')
     and case when ${type}="教师" then `major`.majorCollege=${teachCollege} else 1=1 end
     GROUP BY `major`.majorCollege,`major`.majorName,mtc_grade
     )P on M.majorCollege=P.majorCollege and M.majorName=P.majorName and M.gradeName=P.mtc_grade
     left join
     (SELECT majorName,majorCollege,mtc_grade,COUNT(*) AS uncheckcount FROM `nxlg`.`majorterracecourse`
     LEFT JOIN `major`
     ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
     WHERE (`majorterracecourse`.mtc_isDelete IS NULL OR `majorterracecourse`.mtc_isDelete="否") AND `majorterracecourse`.mtc_checkStatus="未通过"
     and `majorterracecourse`.mtc_grade LIKE CONCAT('%',${grade},'%') and `major`.majorCollege LIKE CONCAT('%',${college},'%') and `major`.majorName LIKE CONCAT('%',${major},'%')
     and case when ${type}="教师" then `major`.majorCollege=${teachCollege} else 1=1 end
     GROUP BY `major`.majorCollege,`major`.majorName,mtc_grade
     )Q on M.majorCollege=Q.majorCollege and M.majorName=Q.majorName and M.gradeName=Q.mtc_grade order by checkcount desc,M.majorCollege,M.majorName,M.gradeName
     */}, context, "",context.pageNum,context.pageSize);
    return rr;
}
