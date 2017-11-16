/**
 * Created by gq on 2017/5/27.
 * 修改学院
 */
function main(context) {
    //非空判断
    if(context.wordbookId==null){
        return false;
    }
    if(context.wordbookValue==null || context.wordbookValue=='') return  {result:false,errormessagge:'学院名称不能为空'}
    var con = createconnection();

    var r = query(function () {/*
     SELECT wordbookValue FROM wordbook
     WHERE wordbookId=${wordbookId}
     */},context,"");
    context.oldcollege=r[0].wordbookValue;
    if(context.oldcollege==context.wordbookValue) return {result:false,errormessagge:'名称没有变化不需要修改'}
    //去掉前后空格
    context.wordbookValue = context.wordbookValue.replace(/^\s+|\s+$/g,"");
    var q = query(function () {/*
     SELECT *
     FROM `wordbook`
     WHERE wordbookKey='学院' and wordbookValue=${wordbookValue}
     */},context,"");

    if(q && q.length>0) return {result:false,errormessagge:'想要修改的学院名称已经存在了'}
    //更新字典表
    var up1 = multiexec(con, function(){/*
     update wordbook set wordbookValue=${wordbookValue} where wordbookId = ${wordbookId}
     */}, context);
    if (!up1) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新字典表学院失败"}};

    //更新educateplane表
    var q1 = query(function () {/*
     SELECT * FROM educateplane
     WHERE ep_college=${oldcollege}
     */},context,"");
    if(q1 && q1.length>0){
        for(var i=0;i<q1.length;i++){
            q1[i].newcollege=context.wordbookValue;
            var up2 = multiexec(con, function(){/*
             update educateplane set ep_college=${newcollege} where ep_id = ${ep_id}
             */},q1[i]);
            if (!up2) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新educateplane表学院失败"}};
        }
    }

    //更新专业表
    var q2 = query(function () {/*
     SELECT * FROM major
     WHERE majorCollege=${oldcollege}
     */},context,"");
    if(q2 && q2.length>0){
        for(var j=0;j<q2.length;j++){
            q2[j].newcollege=context.wordbookValue;
            var up3 = multiexec(con, function(){/*
             update major set majorCollege=${newcollege} where majorId = ${majorId}
             */},q2[j]);
            if (!up3) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新专业表学院失败"}};
        }
    }

    //更新教师表
    var q3 = query(function () {/*
     SELECT * FROM teacher
     WHERE teachCollege=${oldcollege}
     */},context,"");
    if(q3 && q3.length>0){
        for(var k=0;k<q3.length;k++){
            q3[k].newcollege=context.wordbookValue;
            var up4 = multiexec(con, function(){/*
             update teacher set teachCollege=${newcollege} where teacherId = ${teacherId}
             */},q3[k]);
            if (!up4) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新教师表学院失败"}};
        }
    }

    //更新学生表
    var q4 = query(function () {/*
     SELECT * FROM student
     WHERE studentCollege=${oldcollege}
     */},context,"");
    if(q4 && q4.length>0){
        for(var o=0;o<q4.length;o++){
            q4[o].newcollege=context.wordbookValue;
            var up5 = multiexec(con, function(){/*
             update student set studentCollege=${newcollege} where studentId = ${studentId}
             */},q4[o]);
            if (!up5) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新学生表学院失败"}};
        }
    }

   var r2= commit(con);
    //如果提交失败rollback
    if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"提交失败"}};
    closeconnection(con);
    return {result:true,errormessage:""}
}