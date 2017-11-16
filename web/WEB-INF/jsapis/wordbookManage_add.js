/**
 * Created by NEU on 2017/3/15.
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //去空格
    context.wordbookKey = context.wordbookKey.replace(/^\s+|\s+$/g,"");
    //数据非空判断
    if(context.wordbookKey == null ||context.wordbookValue == null){
        return {result:false, msg:'值不能为空'}
    }

    var wordbook =  query(function () {/*
     SELECT * FROM wordbook
     WHERE wordbookKey=${wordbookKey}
     */},context,"");

    //验证是否有重复键
    if(wordbook && wordbook.length>0){
        return {result:false, msg:'字典键值数已存在'}
    }
    //添加
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
    return {result:true, msg:'添加成功'};
}



