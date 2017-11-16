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
     courseId,courseCode,chineseName,assumeUnit,totalCredit,totalTime,course.scheduleTime,course.nonscheduleTime,course.checkStatus
     FROM
     `nxlg`.`course`
     LEFT JOIN `nxlg`.`teacher`
     ON (`course`.`mainteacherid` = `teacher`.`teacherId`)
     LEFT JOIN `nxlg`.`teachingmaterials` 
     ON (`course`.`coursebookid` = `teachingmaterials`.`tmId`)
     WHERE (courseCode LIKE CONCAT('%',${searchStr},'%') OR chineseName LIKE CONCAT('%',${searchStr},'%'))
     and case when ${type}="教师" then `course`.`assumeUnit`=${teachCollege} else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="1") then (checkStatus="已通过") else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="2") then (checkStatus="未通过" OR checkStatus="待写教材") else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="0") then (checkStatus="待审核") else 1=1 end
     order by convert(chineseName USING gbk) COLLATE gbk_chinese_ci asc,convert(checkStatus USING gbk) COLLATE gbk_chinese_ci desc
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
