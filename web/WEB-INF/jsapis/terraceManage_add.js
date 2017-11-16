/**
 * Created by NEU on 2017/4/18.
 */
function main(context){
    //数据非空判断
    if(context.terraceName == null){
        return false;
    }

    //判断是否有平台名称相同的
    context.terraceName = context.terraceName.replace(/^\s+|\s+$/g,"");
    var terrace = query(function () {/*
     SELECT *
     FROM `terrace`
     WHERE terraceName=${terraceName}
     */},context,"");

    if(terrace && terrace.length>0) return {result:false,errormessagge:'平台名称已经存在了'}


    var result=exec(function(){/*
     INSERT INTO `terrace` (
     `terraceId`,
     `terraceName`,
     `minCredits`,
     `minClasses`,
     `maxCredits`,
     `maxClasses`,
     `startTime`,
     `endTime`
     )
     VALUES(UUID(),${terraceName},${minCredits},${minClasses},${maxCredits},${maxClasses},${startTime},${endTime})
     */},context);
    return {result:result,errormessagge:'添加平台失败'};;
}
