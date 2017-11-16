/**
 * Created by NEU on 2017/6/29.
 */
function main(context){
    //sessionUserID非空判断
    if(getsession(context,"sessionUserID") == null){
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
    var con=createconnection();
    var r1=multiexec(con,function () {/*
     update stuchoosecourse set istiaojicomfirm='2' where studentId=${studentId}
     */},context);
    if(!r1) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新失败"}};
    var r2=multiexec(con,function () {/*
     update student set cantiaoji='1',tiaojiterm=${term} where studentId=${studentId}
     */},context);
    if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新失败"}};
    var end = commit(con);
    if(!end) {rollback(con);closeconnection(con);return {result:false,errormessage:"提交失败"}};
    closeconnection(con);
    return {result:true};
}
