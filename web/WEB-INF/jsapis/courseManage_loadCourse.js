/**
 * Created by NEU on 2017/4/18.
 */
// 加载课程信息
function main(context) {
    context.type = getsession(context,"sessionUserType");
    if(context.type=="学生"){return {result:false,errormessage:"学生用户没有权限"};}
    else if(context.type=="教师"){
        var r =query(function () {/*
         SELECT * FROM `teacher` WHERE teacherNumber=${sessionUserName}
         */}, context, "");
        if(r.length<1||r==null){
            return {result:false,errormessage:"该教师没有权限"};
        }else{
            context.teachCollege=r[0].teachCollege;
        }
    }

    var result = querypagedata(function () {/*
     SELECT
     `course`.`scheduleTime` AS scheduletime,
     `course`.`nonscheduleTime` AS nonscheduletime,
     `course`.*
     , `teacher`.*
     , `teachingmaterials`.*
     FROM
     `nxlg`.`course`
     LEFT JOIN `nxlg`.`teacher`
     ON (`course`.`mainteacherid` = `teacher`.`teacherId`)
     LEFT JOIN `nxlg`.`teachingmaterials`
     ON (`course`.`coursebookid` = `teachingmaterials`.`tmId`)
     WHERE
     case when ${searchStr} is not null and ${searchStr}<>""  then (courseCode LIKE CONCAT('%',${searchStr},'%') OR chineseName LIKE CONCAT('%',${searchStr},'%')) else 1=1 end
     and case when ${courseCode} is not null and ${courseCode}<>""  then courseCode LIKE CONCAT('%',${courseCode},'%') else 1=1 end
     and case when ${chineseName} is not null and ${chineseName}<>""  then chineseName LIKE CONCAT('%',${chineseName},'%') else 1=1 end
     and case when ${collegeName} is not null and ${collegeName}<>""  then teachCollege LIKE CONCAT('',${collegeName},'') else 1=1 end
     and case when ${englishName} is not null and ${englishName}<>""  then englishName LIKE CONCAT('%',${englishName},'%') else 1=1 end
     and case when ${courseCategory_3} is not null and ${courseCategory_3}<>""  then courseCategory_3 LIKE CONCAT('',${courseCategory_3},'') else 1=1 end
     and case when ${courseCategory_4} is not null and ${courseCategory_4}<>""  then courseCategory_4 LIKE CONCAT('',${courseCategory_4},'') else 1=1 end
     and case when ${courseCategory_5} is not null and ${courseCategory_5}<>""  then courseCategory_5 LIKE CONCAT('',${courseCategory_5},'') else 1=1 end
     and case when ${totalCredit} is not null and ${totalCredit}<>""  then totalCredit LIKE CONCAT('',${totalCredit},'') else 1=1 end
     and case when ${totalTime} is not null and ${totalTime}<>""  then totalTime LIKE CONCAT('',${totalTime},'') else 1=1 end
     and case when ${checkType} is not null and ${checkType}<>""  then checkType = ${checkType} else 1=1 end
     and case when ${checkStatus} is not null and ${checkStatus}<>""  then checkStatus = ${checkStatus} else 1=1 end
     and case when ${type}="教师" then `course`.`assumeUnit`=${teachCollege} else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="1") then (checkStatus="已通过") else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="2") then (checkStatus="未通过" OR checkStatus="待写教材") else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="0") then (checkStatus="待审核") else 1=1 end
     order by convert(chineseName USING gbk) COLLATE gbk_chinese_ci asc,convert(checkStatus USING gbk) COLLATE gbk_chinese_ci desc
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
