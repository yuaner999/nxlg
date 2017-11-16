/**
 * Created by NEU on 2017/4/19.
 * 修改排课信息
 */
function main(context) {
    //基础数据非空判断
    if(context.acId == null||context.semester == null||context.startWeek == null||context.endWeek == null||context.days == null||
        context.lessonsMorning == null||context.lessonAfternoon == null||context.lessonNight == null||context.is_now == null){
        return false;
    }
    //基础数据数值型判断
    if(isNaN(context.startWeek)||isNaN(context.endWeek)||isNaN(context.days)||isNaN(context.lessonsMorning)||isNaN(context.lessonAfternoon)||
        isNaN(context.lessonAfternoon)||isNaN(context.lessonNight)){
        return false;
    }
    var acId=context.acId;
    if(context.is_now=='true') context.is_now=true;
    if(context.is_now=='false') context.is_now=false;
    var r = query(function () {/*
     select acId from arrangecourse
     where semester=${semester}
     */},context,"");
    if(r.length==0||r[0].acId==acId){
        var con = createconnection();
        var result = multiexec(con,function () {/*
         UPDATE
         `arrangecourse`
         SET
         `semester` = ${semester},
         `startWeek` = ${startWeek},
         `endWeek` = ${endWeek},
         `days` = ${days},
         `lessonsMorning` = ${lessonsMorning},
         `lessonAfternoon` = ${lessonAfternoon},
         `lessonNight` = ${lessonNight},
         is_now=${is_now}
         WHERE `acId` = ${acId} ;
         */},context);

        if(!result) {rollback(con);closeconnection(con);return false;}
        if(context.is_now) {
            var rr = query(function () {/*
             select acId from arrangecourse where is_now = true and `acId` != ${acId} ;
             */}, context, "");
            if (!rr) rr = [];
            for (var i = 0; i < rr.length; i++) {
                var obj = rr[i];
                var result2 = multiexec(con, function () {/*
                 UPDATE  `arrangecourse`
                 SET `is_now` = false
                 WHERE `acId` = ${acId}
                 */}, obj);
                if (!result2) {
                    rollback(con);
                    closeconnection(con);
                    return false;
                }
            }
        }
        var c=commit(con);
        if(!c) {rollback(con);closeconnection(con);return false;}
        closeconnection(con);
        return true;
    }else{
        return 1;
    }
}