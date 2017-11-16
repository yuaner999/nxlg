/**
 * Created by NEU on 2017/5/15.
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
        }else{context.teachCollege=r[0].teachCollege;}
    }
    var result = querypagedata(function () {/*
     SELECT
     `teachtask`.*,
     `teacher`.`teacherName`,
     `course`.`chineseName`
     FROM
     `nxlg`.`teachtask`
     LEFT JOIN `nxlg`.`arrangecourse`
     ON `teachtask`.`tc_semester`=`arrangecourse`.`semester`
     LEFT JOIN `nxlg`.`teacher`
     ON `teacher`.`teacherId`=`teachtask`.`tc_classteacherid`
     LEFT JOIN `nxlg`.`course`
     ON `course`.`courseId`=`teachtask`.`tc_courseid`
     WHERE
     (`tc_isDelete` IS NULL OR `tc_isDelete`='否')
     AND `tc_checkStatus`='已通过'
     AND `is_now`=1
     AND
     (
        ${searchStr}=''
        OR `chineseName` LIKE CONCAT ('%',${searchStr},'%')
        OR `tc_class` LIKE CONCAT ('%',${searchStr},'%')
        OR `teacherName` LIKE CONCAT ('%',${searchStr},'%')
        OR `tc_teachway` LIKE CONCAT ('%',${searchStr},'%')
     )
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
