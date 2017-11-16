/**
 * Created by NEU on 2017/4/18.
 */
function main(context) {
    //数据非空判断
    if(context.terraceName == null ||context.terraceId == null){
        return false;
    }

    //判断是否有平台名称相同的
    context.terraceName = context.terraceName.replace(/^\s+|\s+$/g,"");
    var terrace = query(function () {/*
     SELECT *
     FROM `terrace`
     WHERE terraceName=${terraceName}
     */},context,"");

    if(terrace && terrace.length>0) return {result:false,errormessagge:'想要修改的平台名称已经存在了'}

    //修改平台信息
    var result = exec(function () {/*
     UPDATE
     `terrace`
     SET
     `terraceName` = ${terraceName},
     `minCredits` = ${minCredits},
     `minClasses` = ${minClasses},
     `maxCredits` = ${maxCredits},
     `maxClasses` = ${maxClasses},
     `startTime` = ${startTime},
     `endTime` = ${endTime}
     WHERE `terraceId` = ${terraceId}
     */},context);
    return  {result:result,errormessagge:'修改平台失败'};
}