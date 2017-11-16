/**
 * Created by NEUNB_Lisy on 2017/6/28.
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
    //专业平台课程设置
    var rr =querypagedata(function () {/*
     SELECT
     `majorterracecourse`.*,`major`.*,`terrace`.*,`course`.*
     FROM
     `nxlg`.`majorterracecourse`
     LEFT JOIN `major`
     ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
     LEFT JOIN `terrace`
     ON (`majorterracecourse`.`terraceId` = `terrace`.`terraceId`)
     LEFT JOIN `course`
     ON (`majorterracecourse`.`courseId` = `course`.`courseId`)
     WHERE (`majorterracecourse`.mtc_isDelete is null or `majorterracecourse`.mtc_isDelete="否")
     and case when ${type}="教师" then `major`.`majorCollege`=${teachCollege} else 1=1 end
     and case when ${collegeName} is not null and ${collegeName}<>""  then majorCollege=${collegeName} else 1=1 end
     and case when ${majorName} is not null and ${majorName}<>""  then major.majorId=${majorName} else 1=1 end
     and case when ${terraceName} is not null and ${terraceName}<>""  then terrace.terraceId=${terraceName} else 1=1 end
     and case when ${termName} is not null and ${termName}<>""  then mtc_courseTerm like concat('%',${termName},'%') else 1=1 end
     and case when ${termName} is null or ${termName} =""  then mtc_courseTerm IN ( SELECT semester FROM arrangecourse WHERE is_now=1 ) else 1=1 end
     */}, context, "",context.pageNum,context.pageSize);
    return rr;
}