/**
 * Created by NEU on 2017/6/5.
 */
function main(context){
    //基础数据非空判断
    if(context.tc_id == null||context.courseId == null||context.class == null||context.now_timepitch == null
        ||context.odd_teachName == null||context.now_timeweek == null||context.odd_teachweek == null){
        return false;
    }
    var con = createconnection();
    for(var i=0;i<context.checkitem.length;i++){
        var result=multiexec(con,function(){/*
         INSERT INTO `nxlg`.`manualadjustcourse` (`mac_id`, `tc_id`,`courseId`, `class`,`odd_teachweek`, `odd_teachName`,`now_timeweek`, `now_timepitch`, `type`, `settime`)
         VALUES(uuid(),${tc_id},${courseId},${class},${odd_teachweek},${odd_teachName},${now_timeweek},${now_timepitch}, '停课',NOW()) ;
         */},context.checkitem[i]);
        if(!result) {rollback(con);closeconnection(con);return {result:false,errormessage:"失败"}};
    }
    commit(con);
    closeconnection(con);
    return true;
}