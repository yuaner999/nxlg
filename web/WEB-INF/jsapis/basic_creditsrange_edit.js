/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName")==null){
        return false;
    }
    //基础数据非空判断
    if(context.mincredits == null||context.maxcredits == null){
        return false;
    }
    //基础数据数值型判断
    if(isNaN(context.mincredits)||isNaN(context.maxcredits)){
        return false;
    }
    var r= query(function () {/*
     SELECT a.wordbookValue AS mincredits,b.wordbookValue AS maxcredits FROM wordbook a ,wordbook b WHERE a.wordbookKey='最低学分' AND b.`wordbookKey`='最高学分'
     */},context,"");
    if(r.length>0){
        var con = createconnection();
        var r1=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
          SET `wordbookValue` = ${mincredits}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
          WHERE `wordbookKey` = '最低学分' ;
         */},context);
        if(!r1) {rollback(con);closeconnection(con);return {result:false,errormessage:"最低学分设置失败"}};
        var r2=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${maxcredits}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '最高学分' ;
         */},context);
        if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"最高学分设置失败"}};
        var r3 = commit(con);
        if(!r3) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新失败2"}};
        closeconnection(con);
        return true;
    }else{
        var con = createconnection();
        var r1=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '最低学分', ${mincredits}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r1) {rollback(con);closeconnection(con);return {result:false,errormessage:"最低学分设置失败"}};
        var r2=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '最高学分', ${maxcredits}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"最高学分设置失败"}};
        var r3 = commit(con);
        if(!r3) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新失败2"}};
        closeconnection(con);
        return true;
    }
}
/*
var inputsamples=[{
    mincredits:'3.2',
    maxcredits:'10'
}]*/
