/**
 * Created by NEU on 2017/4/27.
 */
function main(context) {
    context.type = getsession(context,"sessionUserType");
    if(context.type=="学生"){return {result:false,errormessage:"学生用户没有权限"};}
    else if(context.type=="教师"){
        var r=query(function () {/*
         SELECT
         `user`.*, `teacher`.*
         FROM `user`
         LEFT JOIN `teacher` ON (`user`.`typeId` = `teacher`.`teacherId`)
         WHERE `user`.`typeName`="教师" AND `user`.`userId`=${sessionUserID}
         */}, context, "");
        if(r.length<1||r==null){
            return {result:false,errormessage:"该教师没有权限"};
        }else{context.teachCollege=r[0].teachCollege;}
    }
    var semester=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=semester[0].semester;
    //专业平台课程设置
    var rr =querypagedata(function () {/*
     SELECT teacher.`teacherName`,`course`.courseId,courseCode,chineseName,assumeUnit,totalCredit,totalTime,mtc_courseTerm
     FROM
     `nxlg`.`majorterracecourse`
     LEFT JOIN `course`
     ON (`majorterracecourse`.`courseId` = `course`.`courseId`)
     LEFT JOIN  teacher ON teacher.`teacherId`=course.`mainteacherid`
     WHERE (`majorterracecourse`.mtc_isDelete IS NULL OR `majorterracecourse`.mtc_isDelete="否") AND majorterracecourse.`mtc_checkStatus`='已通过'
     AND mtc_courseTerm=${term}
     and case when ${type}="教师" then assumeUnit=${teachCollege} else 1=1 end
     GROUP BY courseId
     */}, context, "",context.pageNum,context.pageSize);
    return rr;
}

var inputsamples=[{
}]
