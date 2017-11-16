/**
 * Created by NEU on 2017/5/16.
 */
// 加载教学任务信息
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
    if(context.college==null){
        context.college="";
    }
    if(context.teachCollege==null){
        context.teachCollege="";
    }
    var result = querypagedata(function () {/*
     select M.collegename majorCollege,(case when N.hascount is null then 0 else N.hascount end) hascount
     ,(case when P.checkcount is null then 0 else P.checkcount end) checkcount
     ,(case when Q.uncheckcount is null then 0 else Q.uncheckcount end) uncheckcount
     from (SELECT wordbookValue as collegename FROM `wordbook`
     WHERE wordbookKey ="学院"
     and case when ${college} is not null and ${college}<>""  then  wordbookValue like ${college} else 1=1 end
     and case when ${type}="教师" then wordbookValue=${teachCollege} else 1=1 end
     order by wordbookValue)M
     left join
     (SELECT `teacher`.`teachCollege`,COUNT(*) AS hascount FROM `nxlg`.`teachtask`
     LEFT JOIN `nxlg`.`teacher`      ON (`teachtask`.`tc_mainteacherid` = `teacher`.`teacherId`)
     WHERE (`teachtask`.tc_isDelete IS NULL OR `teachtask`.tc_isDelete="否") AND `teachtask`.tc_checkStatus="已通过"
     and `teacher`.teachCollege LIKE CONCAT('%',${college},'%')
     and case when ${type}="教师" then `teacher`.`teachCollege`=${teachCollege} else 1=1 end
     GROUP BY `teacher`.`teachCollege`
     )N on M.collegename=N.teachCollege
     left join
     (SELECT `teacher`.`teachCollege`,COUNT(*) AS checkcount FROM `nxlg`.`teachtask`
     LEFT JOIN `nxlg`.`teacher`      ON (`teachtask`.`tc_mainteacherid` = `teacher`.`teacherId`)
     WHERE (`teachtask`.tc_isDelete IS NULL OR `teachtask`.tc_isDelete="否") AND `teachtask`.tc_checkStatus="待审核"
     and `teacher`.teachCollege LIKE CONCAT('%',${college},'%')
     and case when ${type}="教师" then `teacher`.`teachCollege`=${teachCollege} else 1=1 end
     GROUP BY `teacher`.`teachCollege`
     )P on M.collegename=P.teachCollege
     left join
     (SELECT `teacher`.`teachCollege`,COUNT(*) AS uncheckcount FROM `nxlg`.`teachtask`
     LEFT JOIN `nxlg`.`teacher`      ON (`teachtask`.`tc_mainteacherid` = `teacher`.`teacherId`)
     WHERE (`teachtask`.tc_isDelete IS NULL OR `teachtask`.tc_isDelete="否") AND `teachtask`.tc_checkStatus="未通过"
     and `teacher`.teachCollege LIKE CONCAT('%',${college},'%')
     and case when ${type}="教师" then `teacher`.`teachCollege`=${teachCollege} else 1=1 end
     GROUP BY `teacher`.`teachCollege`
     )Q on M.collegename=Q.teachCollege order by checkcount desc,collegename
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
