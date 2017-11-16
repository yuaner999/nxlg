/**
 * Created by NEU on 2017/3/18.
 * 废弃
 */
function main(context) {
    //加载每个专业的平台课程(学生的年级)
    //学生的年级
    var t=query(function () {/*
     SELECT  `user`.*, `student`.* FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */}, context,"");
    context.studentGrade=t[0].studentGrade;
    //总专业课程
    var result = querypagedata(function () {/*
         SELECT  mtc_id,majorId,terraceId,courseId,mtc_courseTerm,mtc_majorWay,mtc_note,mtc_checkStatus,mtc_isDelete,tmId,
         name,press,edition,booknumber,price,tc_id,tc_courseid,tc_mainteacherid,tc_class,tc_classteacherid,tc_numrange,tc_teachway,
         tc_teachweek,tc_teachodd,tc_teachmore,tc_checkType,tc_checkStatus,teacherId,teacherNumber,teacherName,department,administrative,
         teachUnit,duty,dutyDate,dutyLevel,education,educationMajor,educationSchool,educationStructure,degree,certificate,teachDate,teachMajor,teachSection,
         teachStatus,teachArea,certificateLevel,courseCode,assumeUnit,chineseName,coursebookid,totalCredit,totalTime,courseCategory_3,
         courseCategory_4,courseCategory_5,majorName,al_timeweek,al_timepitch,classroomId,classroomName,tc_grade
         FROM `courseload`
         WHERE  terraceId=${terraceId} and ((${keytname} is null or ${keytname}='') or(teacherName like concat('%',${keytname},'%')))
         and ((${keyroom} is null or ${keyroom}='') or (classroomName like concat('%',${keyroom},'%')))
         and ((${keyunit} is null or ${keyunit}='') or (assumeUnit like concat('%',${keyunit},'%')))
         */},context, "mtc_id,majorId,terraceId,courseId,mtc_courseTerm,mtc_majorWay,mtc_note,mtc_checkStatus,mtc_isDelete,tmId,name,press,edition,booknumber,price,tc_id,tc_courseid,tc_mainteacherid,tc_class,tc_classteacherid,tc_numrange,tc_teachway,tc_teachweek,tc_teachodd,tc_teachmore,tc_checkType,tc_checkStatus,teacherId,teacherNumber,teacherName,department,administrative,teachUnit,duty,dutyDate,dutyLevel,education,educationMajor,educationSchool,educationStructure,degree,certificate,teachDate,teachMajor,teachSection,teachStatus,teachArea,certificateLevel,courseCode,assumeUnit,chineseName,coursebookid,totalCredit,totalTime,courseCategory_3,courseCategory_4,courseCategory_5,majorName,tc_grade,times:[al_timeweek,jie:[al_timepitch,classroomId,classroomName]]"
        ,context.pageNum,context.pageSize);
    //去掉总专业课程里面不是这个年级的课程
    var tc_grade=[];
    //console("studentGrade"+context.studentGrade);
    for(var i=result.total-1;i>=0;) {
        tc_grade[i]=result.rows[i].tc_grade.split("|");
       // console(i+'sda'+ tc_grade[i].length+tc_grade[i]);
        for(var j=0;j<tc_grade[i].length; ){
            if(parseInt(context.studentGrade)==parseInt(tc_grade[i][j])){
                //    console('这一条有相同的年级就跳出去比较下一条'+tc_grade[i][j]);
                i--;
                break;
            }else{
                // console(j+'暂时不相同'+tc_grade[i][j]);
                j++;
            }
            if(j==tc_grade[i].length){
                // console('走到投了');
                result.rows.remove(i);
                result.total--;
                i--;
                break;
            }
        }
    }
    //这里是时间搜索
    var  newtc_teachweek=[];
    if(context.keytime!=''&&context.keytime!=null)
    {
        for(var i=result.total-1;i>=0;i--) {
            newtc_teachweek[i]=result.rows[i].tc_teachweek.split("至");
            if(parseInt(newtc_teachweek[i][0])<=parseInt(context.keytime)&&parseInt(context.keytime)<=parseInt(newtc_teachweek[i][1])){
            }else{
                result.rows.remove(i);
                result.total--;
            }
        }
    }
    return result;
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa',
    // majorName:'体育1',
    terraceId:'f2be64fb-24c4-11e7-942b-00ac9c2c0afa'
    // keytime:'7'
}]