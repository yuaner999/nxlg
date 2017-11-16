/**
 * Created by NEU on 2017/4/19.
 * 新增排课信息
 */
function main(context){
    //基础数据非空判断
    if(context.semester == null||context.startWeek == null||context.endWeek == null||context.days == null||
           context.lessonsMorning == null||context.lessonAfternoon == null||context.lessonNight == null||context.is_now == null){
        return false;
    }
    //基础数据数值型判断
    if(isNaN(context.startWeek)||isNaN(context.endWeek)||isNaN(context.days)||isNaN(context.lessonsMorning)||isNaN(context.lessonAfternoon)|| 
            isNaN(context.lessonAfternoon)||isNaN(context.lessonNight)){
        return false;
    }
    if(context.is_now=='true') context.is_now=true;
    if(context.is_now=='false') context.is_now=false;
    var r=query(function () {/*
        select semester from arrangecourse where semester = ${semester}
    */},context,"");
    if(r.length>0){
        return 1;
    }
    var con = createconnection();
    var result=multiexec(con,function(){/*
     insert into `nxlg`.`arrangecourse` (
     `acId`,
     `semester`,
     `startWeek`,
     `endWeek`,
     `days`,
     `lessonsMorning`,
     `lessonAfternoon`,
     `lessonNight`,
     is_now
     )
     VALUES(UUID(),${semester},${startWeek},${endWeek},${days},${lessonsMorning},${lessonAfternoon},${lessonNight},${is_now})
     */},context);
    if(!result){rollback(con);closeconnection(con);return false;}

    if(context.is_now){
        var rr=query(function () {/*
         select acId from arrangecourse where is_now = true
         */},context,"");
        if(!rr) rr=[];
        for (var i = 0; i < rr.length; i++) {
            var obj = rr[i];
            var result2=multiexec(con,function(){/*
             UPDATE  `arrangecourse`
             SET `is_now` = false
             WHERE `acId` = ${acId}
             */},obj);
            if(!result2) {rollback(con);closeconnection(con);return false;}
        }
    }

    var c=commit(con);
    if(!c) {rollback(con);closeconnection(con);return false;}
    closeconnection(con);

    return true;
}
