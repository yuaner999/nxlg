/**
 * Created by NEU on 2017/4/18.
 */
function main(context) {
    //数据非空判断
    if(context.terraceName == null ||context.terraceId == null){
        return false;
    }
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
    return result;
}