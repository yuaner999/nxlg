/**
 * Created by NEU on 2017/4/18.
 */
function main(context){
    //数据非空判断
    if(context.terraceName == null){
        return false;
    }
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
    return result;
}
