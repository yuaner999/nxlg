/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    //sessionUserID非空判断
    if(getsession(context,"sessionUserID") == null){
        return false;
    }
    //基础数据非空判断
    if(context.paystart == null||context.payend == null){
        return false;
    }
    var r= query(function () {/*
     SELECT a.wordbookValue AS paystart,b.wordbookValue AS payend
     FROM wordbook a ,wordbook b
     WHERE a.wordbookKey='教材自助缴费开始时间' AND b.`wordbookKey`='教材自助缴费结束时间'
     */},context,""); 
    var con = createconnection();
    if(r.length>0){
        var r1=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
          SET `wordbookValue` = ${paystart}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
          WHERE `wordbookKey` = '教材自助缴费开始时间' ;
         */},context);
        if(!r1) {rollback(con);closeconnection(con);return {result:false,errormessage:"最低学分设置失败"}};
        var r2=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${payend}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '教材自助缴费结束时间' ;
         */},context);
        if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"最高学分设置失败"}};
    }else{
        var r1=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '教材自助缴费开始时间', ${paystart}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r1) {rollback(con);closeconnection(con);return {result:false,errormessage:"最低学分设置失败"}};
        var r2=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '教材自助缴费结束时间', ${payend}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"最高学分设置失败"}};
    } 
    var r3 = commit(con);
    if(!r3) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新失败2"}};
    closeconnection(con);
    return true;
}
