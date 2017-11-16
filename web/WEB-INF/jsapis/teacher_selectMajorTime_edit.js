/**
 * Created by NEU on 2017/4/20.
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.startTime == null||context.endTime == null||context.startT == null||context.endT == null){
        return false;
    }
    var result=exec(function(){/*
     UPDATE `wordbook` SET `wordbookValue` = ${startTime},`updateMan` = ${sessionUserName},`updateDate` = NOW() WHERE `wordbookKey` = "选修开始时间";
     UPDATE `wordbook` SET `wordbookValue` = ${endTime},`updateMan` = ${sessionUserName},`updateDate` = NOW() WHERE `wordbookKey` ="选修结束时间";
     UPDATE `wordbook` SET `wordbookValue` = ${startT},`updateMan` = ${sessionUserName},`updateDate` = NOW() WHERE `wordbookKey` = "辅修开始时间";
     UPDATE `wordbook` SET `wordbookValue` = ${endT},`updateMan` = ${sessionUserName},`updateDate` = NOW() WHERE `wordbookKey` = "辅修结束时间";
     */},context);
    return result;
}
