/**
 * Created by NEU on 2017/3/15.
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //数据非空判断
    if(context.wordbookKey == null ||context.wordbookValue == null){
        return false;
    }
    var result=exec(function(){/*
     INSERT INTO `wordbook` (
     `wordbookId`,
     `wordbookKey`,
     `wordbookValue`,
     `createMan`,
     `createDate`
     )
     VALUES(UUID(),${wordbookKey},${wordbookValue},${sessionUserName},NOW())
     */},context);
    return result;
}



