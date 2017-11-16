/**
 * Created by gq on 2017/6/5.
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName")==null){
        return false;
    }
    var r= query(function () {/*
     SELECT a.wordbookValue AS paystart,b.wordbookValue AS payend
     FROM wordbook a ,wordbook b
     WHERE a.wordbookKey='排课开始时间' AND b.`wordbookKey`='排课结束时间'
     */},context,"");
    var con = createconnection();
    if(r.length>0){
        var r1=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${paystart}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '排课开始时间' ;
         */},context);
        if(!r1) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置排课开始时间失败"}};
        var r2=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${payend}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '排课结束时间' ;
         */},context);
        if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置排课结束时间失败"}};
    }else{
        var r1=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '排课开始时间', ${paystart}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r1) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置排课开始时间失败"}};
        var r2=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '排课结束时间', ${payend}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置排课结束时间失败"}};
    }
    var r3 = commit(con);
    if(!r3) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新失败2"}};
    closeconnection(con);
    return true;
}