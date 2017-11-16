/**
 * Created by NEU on 2017/5/20.
 * 在用户点击确认按钮的时候，
 * 如果人数达到这个课程这个班级的最低开课人数 那么就把所有选这个课这个班这个学期的条状态变成1
 * 否则点击确认按钮，把这条状态变成0
 */
function main(context) {
    //sessionUserID等非空判断
    if(getsession(context,"sessionUserID") == null||context.terraceId == null||context.isautotiaoji == null){
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
     select courseId,class as tc_class,terraceId,term,scc from stuchoosecourse where studentId=${studentId} and terraceId=${terraceId} and term=${term}
     */}, context,"");
    var con=createconnection();
    for(var i=0;i<course.length;i++){
        context.courseId=course[i].courseId;
        context.tc_class=course[i].tc_class;
         //totolpeople 所有选这门课这个班的所有人数(已经确认的)
         var totolpeople=query(function () {/*
          select count(studentId) as countstudentId from stuchoosecourse
          where courseId=${courseId} and class=${tc_class} and term=${term} and (iscomfirm='1' or iscomfirm='0')
          */}, context,"");
         //tc_studentnum 教学任务中的开课人数
         var tc_studentnum=query(function () {/*
          select tc_studentnum from teachtask where tc_courseid=${courseId} and tc_class=${tc_class}
          */}, context,"");
         if(totolpeople.length>0){
             //如果选这门课的人数+1>=开课人数,把这学期所有确定选这个课这个班的人（不分平台）变成确认选课
             if(parseInt(totolpeople[0].countstudentId+1)>=parseInt(tc_studentnum[0].tc_studentnum)){
                 //console(context.courseId+"banji"+context.tc_class+"term"+context.term+"  iscomfirm=1")
                 var result=multiexec(con,function () {/*
                  UPDATE stuchoosecourse set iscomfirm='1'
                  where term=${term} and courseId=${courseId} and class=${tc_class} and (iscomfirm='1' or iscomfirm='0')
                  */},context);
                 if(!result){ rollback(con);closeconnection(con);return false;}
                 //然后把自己的这条数据也变成确认选课，isautotiaoji
                 var result0=multiexec(con,function () {/*
                  UPDATE stuchoosecourse set iscomfirm='1',isautotiaoji=${isautotiaoji}
                  where term=${term} and courseId=${courseId} and class=${tc_class} and studentId=${studentId}
                  */},context);
                 if(!result0){ rollback(con);closeconnection(con);return false;}
             }else {
                 //console(context.courseId+"banji"+context.tc_class+"term"+context.term+"  iscomfirm=0")
                 var result2=multiexec(con,function () {/*
                  UPDATE stuchoosecourse set iscomfirm='0'
                  where term=${term} and courseId=${courseId} and class=${tc_class} and (iscomfirm='1' or iscomfirm='0')
                  */},context);
                 if(!result2){
                     rollback(con);closeconnection(con);return false;
                 }
                 //把自己这条数据变成调剂 ，isautotiaoji
                 var result4=multiexec(con,function () {/*
                  UPDATE stuchoosecourse set iscomfirm='0',isautotiaoji=${isautotiaoji}
                  where term=${term} and courseId=${courseId} and class=${tc_class} and  studentId=${studentId} and terraceId=${terraceId}
                  */},context);
                 if(!result4){ rollback(con);closeconnection(con);return false;}
             }
         }else{
             var result3=multiexec(con,function () {/*
              UPDATE stuchoosecourse set iscomfirm='0',isautotiaoji=${isautotiaoji}
              where term=${term} and courseId=${courseId} and class=${tc_class} and studentId=${studentId} and terraceId=${terraceId}
              */},context);
            // console("3");
             if(!result3){
                 rollback(con);closeconnection(con);return false;
             }
         }
    }
    commit(con);
    closeconnection(con);
    return true;
}
var inputsamples=[{
    sessionUserID:'95f8987f-392a-11e7-9e12-00ac9c2c0afa',
    terraceId:'f2be64fb-24c4-11e7-942b-00ac9c2c0afa',
    isautotiaoji:'0'
}]