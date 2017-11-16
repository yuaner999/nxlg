
/**
 * Created by NEU on 2017/5/22.
 */
function main(context) {
    //sessionUserID等非空判断
    if(getsession(context,"sessionUserID") == null||context.terraceId == null){
        return false;
    }
    var t=query(function () {/*
     SELECT
     `user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */}, context,"");
    context.studentId=t[0].studentId;
    var term=query(function () {/*
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    context.term=term[0].semester;
    //查这次确认 都确认哪些课程
    var course=query(function () {/*
     select courseId,class as tc_class,terraceId,term from stuchoosecourse where studentId=${studentId} and terraceId=${terraceId} and term=${term}
     */}, context,"");
    var con=createconnection();
    for(var i=0;i<course.length;i++){
        context.courseId=course[i].courseId;
        context.tc_class=course[i].tc_class;
        //totolpeople 所有选这门课这个班的所有人数
        var totolpeople=query(function () {/*
         select count(studentId) as countstudentId from stuchoosecourse
         where courseId=${courseId} and class=${tc_class} and term=${term} 
         */}, context,"");
        //tc_studentnum 教学任务中的开课人数
        var tc_studentnum=query(function () {/*
         select tc_studentnum from teachtask where tc_courseid=${courseId} and tc_class=${tc_class}
         */}, context,"");
        if(totolpeople.length>0){
            //如果选这门课的人数>=开课人数,把这学期所有选这个课 这个班的人（不分平台）变成确认选课
            if(parseInt(totolpeople[0].countstudentId)>=parseInt(tc_studentnum[0].tc_studentnum)){
                //console(context.courseId+"banji"+context.tc_class+"term"+context.term+"  iscomfirm=1")
                var result=multiexec(con,function () {/*
                 UPDATE stuchoosecourse set iscomfirm='1'
                 where term=${term} and courseId=${courseId} and class=${tc_class} 
                 */},context);
                if(!result){ rollback(con);closeconnection(con);return {result:0,errormessage: "更新失败"};}
                var result2=multiexec(con,function () {/*
                 UPDATE stuchoosecourse set istiaojicomfirm='1'
                 where term=${term} and courseId=${courseId} and class=${tc_class} and studentId=${studentId} and terraceId=${terraceId}
                 */},context);
                if(!result2){ rollback(con);closeconnection(con);return {result:0,errormessage: "更新失败"};}
            }else {
                rollback(con);closeconnection(con);
                return {result:0,errormessage: "当前有课程开课人数不足,请选择调剂课程"};
            }
        }else{
            rollback(con);closeconnection(con);
            return {result:0,errormessage: "当前有课程开课人数不足,请选择调剂课程"};
        }
    }
    //调剂确认了，把调剂这个人的调剂状态变成‘0’
    var updatestu=multiexec(con,function () {/*
     update student set cantiaoji='0',tiaojiterm=${term} where studentId=${studentId}
     */},context);
    if(!updatestu){ rollback(con);closeconnection(con);return {result:0,errormessage: "更新失败"};}
    commit(con);
    closeconnection(con);
    return {result:true};
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa',
    terraceId:'f2be64fb-24c4-11e7-942b-00ac9c2c0afa'
}]