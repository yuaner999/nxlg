/**
 * Created by NEU on 2017/3/15.
 */

function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //数据非空判断
    if(context.wordbookKey == null ||context.wordbookValue == null||context.wordbookId == null){
        return false;
    }
    //修改数据字典
    var result = exec(function () {/*
     UPDATE
     `wordbook`
     SET
     `wordbookKey` = ${wordbookKey},
     `wordbookValue` = ${wordbookValue},
     `updateMan` = ${sessionUserName},
     `updateDate` = NOW()
     WHERE `wordbookId` = ${wordbookId}
     */},context);
    return result;
}
