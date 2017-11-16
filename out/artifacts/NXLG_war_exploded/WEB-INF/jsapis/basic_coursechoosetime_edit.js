/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName")==null){
        return false;
    }
    //基础数据非空判断
    if(context.tuikestart == null||context.tuikeend == null||context.tiaojicomfirmend == null||context.tiaojicomfirmstart == null||context.thischoosestart == null||context.thischooseend == null||
        context.otherchoosestart == null||context.otherchooseend == null||context.tiaojistart == null||context.tiaojiend == null
        ||context.thatchoosestart == null||context.thatchooseend == null){
        return false;
    }
    var r= query(function () {/*
     SELECT a.wordbookValue AS thischoosestart,b.wordbookValue AS thischooseend,c.wordbookValue AS otherchoosestart,d.wordbookValue AS otherchooseend,
     e.wordbookValue AS tiaojistart,f.wordbookValue AS tiaojiend,g.wordbookValue AS thatchoosestart,h.wordbookValue AS thatchooseend,
     i.wordbookValue AS tiaojicomfirmstart,j.wordbookValue AS tiaojicomfirmend,k.wordbookValue AS tuikestart,l.wordbookValue AS tuikeend
     FROM wordbook a ,wordbook b,wordbook c ,wordbook d,wordbook e ,wordbook f,wordbook g,wordbook h,wordbook i,wordbook j,wordbook k,wordbook l
     WHERE a.wordbookKey='本专业课程选课开始时间' AND b.`wordbookKey`='本专业课程选课结束时间'
     AND c.wordbookKey='其他专业课程选课开始时间' AND d.`wordbookKey`='其他专业课程选课结束时间'
     AND e.wordbookKey='调剂开始时间' AND f.`wordbookKey`='调剂结束时间'
     AND g.wordbookKey='辅修选课开始时间' AND h.`wordbookKey`='辅修选课结束时间'
     AND i.wordbookKey='调剂确认开始时间' AND j.`wordbookKey`='调剂确认结束时间'
     AND k.wordbookKey='退课开始时间' AND l.`wordbookKey`='退课结束时间'
     */},context,"");
    var con = createconnection();
    if(r.length>0){
        var r1=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${thischoosestart}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '本专业课程选课开始时间' ;
         */},context);
        if(!r1) {rollback(con);closeconnection(con);return {result:false,errormessage:"本专业课程选课开始时间失败"}};
        var r2=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${thischooseend}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '本专业课程选课结束时间' ;
         */},context);
        if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"本专业课程选课结束时间失败"}};
        var r3=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${otherchoosestart}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '其他专业课程选课开始时间' ;
         */},context);
        if(!r3) {rollback(con);closeconnection(con);return {result:false,errormessage:"其他专业课程选课开始时间失败"}};
        var r4=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${otherchooseend}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '其他专业课程选课结束时间' ;
         */},context);
        if(!r4) {rollback(con);closeconnection(con);return {result:false,errormessage:"其他专业课程选课结束时间失败"}};
        var r5=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${tiaojistart}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '调剂开始时间' ;
         */},context);
        if(!r5) {rollback(con);closeconnection(con);return {result:false,errormessage:"调剂开始时间失败"}};
        var r6=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${tiaojiend}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '调剂结束时间' ;
         */},context);
        if(!r6) {rollback(con);closeconnection(con);return {result:false,errormessage:"调剂结束时间失败"}};
        var r7=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${thatchoosestart}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '辅修选课开始时间' ;
         */},context);
        if(!r7) {rollback(con);closeconnection(con);return {result:false,errormessage:"调剂开始时间失败"}};
        var r8=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${thatchooseend}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '辅修选课结束时间' ;
         */},context);
        if(!r8) {rollback(con);closeconnection(con);return {result:false,errormessage:"调剂结束时间失败"}};
        var r9=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${tiaojicomfirmstart}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '调剂确认开始时间' ;
         */},context);
        if(!r9) {rollback(con);closeconnection(con);return {result:false,errormessage:"调剂开始时间失败"}};
        var r10=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${tiaojicomfirmend}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '调剂确认结束时间' ;
         */},context);
        if(!r10) {rollback(con);closeconnection(con);return {result:false,errormessage:"调剂结束时间失败"}};
        var r11=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${tuikestart}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '退课开始时间' ;
         */},context);
        if(!r11) {rollback(con);closeconnection(con);return {result:false,errormessage:"退课开始时间失败"}};
        var r12=multiexec(con,function () {/*
         UPDATE  `nxlg`.`wordbook`
         SET `wordbookValue` = ${tuikeend}, `updateMan` = ${sessionUserName}, `updateDate` = NOW()
         WHERE `wordbookKey` = '退课结束时间' ;
         */},context);
        if(!r12) {rollback(con);closeconnection(con);return {result:false,errormessage:"退课结束时间失败"}};
    }else{
        var r1=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '调剂结束时间', ${tiaojiend}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r1) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r2=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '调剂开始时间', ${tiaojistart}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r2) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r3=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '其他专业课程选课结束时间', ${otherchooseend}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r3) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r4=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '其他专业课程选课开始时间', ${otherchoosestart}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r4) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r5=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '本专业课程选课结束时间', ${thischooseend}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r5) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r6=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '本专业课程选课开始时间', ${thischoosestart}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r6) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r7=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '辅修选课开始时间', ${thatchoosestart}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r7) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r8=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '辅修选课结束时间', ${thatchooseend}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r8) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r9=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '调剂确认开始时间', ${tiaojicomfirmstart}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r9) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r10=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '调剂确认结束时间', ${tiaojicomfirmend}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r10) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r11=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '退课开始时间', ${tuikestart}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r11) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
        var r12=multiexec(con,function () {/*
         INSERT INTO `nxlg`.`wordbook` (`wordbookId`, `wordbookKey`,`wordbookValue`,`createMan`,`createDate`)
         VALUES(UUID(), '退课结束时间', ${tuikeend}, ${sessionUserName},NOW() ) ;
         */},context);
        if(!r12) {rollback(con);closeconnection(con);return {result:false,errormessage:"设置失败"}};
    }
    var end = commit(con);
    if(!end) {rollback(con);closeconnection(con);return {result:false,errormessage:"更新失败2"}};
    closeconnection(con);
    return true;
}
/*
 var inputsamples=[{
     thischoosestart:'2017-05-16 16:24:00',
thischooseend:'2017-05-17 16:24:01',
otherchoosestart:'2017-05-18 16:24:03',
otherchooseend:'2017-05-19 16:24:04',
tiaojistart:'2017-05-20 16:24:06',
tiaojiend:'2017-05-21 16:24:07',
thatchoosestart:'2017-05-23 16:24:09',
thatchooseend:'2017-06-01 16:24:10'
 }]
*/
