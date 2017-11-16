/**
 * Created by NEU on 2017/5/16.
 * 设置消息已读
 */
function main(context) {
    //基础数据非空判断
    if(context.messageIds.length <= 0){
        return false;
    }
    for(var i=0;i<context.messageIds.length;i++){
        context.messageId=context.messageIds[i];
        var r=exec(function () {/*
         UPDATE
         `message`
         SET
         `isRead` = '是'
         WHERE `messageId` = ${messageId}
         */},context);
        if(!r){
            return false;
        }
    }
    return r;
}