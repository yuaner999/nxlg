/**
 * Created by NEU on 2017/5/31.
 * 本学期所有开课课程汇总起来,分发给对应的承担单位(学院),
 *
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
    var term=query(function () {/*
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    context.term=term[0].semester;
    var rr =querypagedata(function () {/*
     SELECT
     `majorterracecourse`.*,`terrace`.*,`course`.*,`majorterracecourse`.terraceId as ter,`majorterracecourse`.courseId as cour,
     `terrace`.terraceName as terName
     FROM
     `nxlg`.`majorterracecourse`
     LEFT JOIN `terrace`
     ON (`majorterracecourse`.`terraceId` = `terrace`.`terraceId`)
     LEFT JOIN `course`
     ON (`majorterracecourse`.`courseId` = `course`.`courseId`)
     WHERE (`majorterracecourse`.mtc_isDelete is null or `majorterracecourse`.mtc_isDelete="否") and `majorterracecourse`.mtc_checkStatus="已通过"
     and `course`.checkStatus="已通过" and `course`.courseStatus="启用"
     and majorterracecourse.mtc_courseTerm=${term}
     and case when ${type}="教师" then `course`.`assumeUnit`=${teachCollege} else 1=1 end
     GROUP BY `majorterracecourse`.courseId
     order by convert(`terrace`.terraceName USING gbk) COLLATE gbk_chinese_ci,
     convert(`course`.chineseName USING gbk) COLLATE gbk_chinese_ci,convert(`majorterracecourse`.mtc_courseTerm USING gbk) COLLATE gbk_chinese_ci

      */}, context, "",context.pageNum,context.pageSize);
    return rr;
}