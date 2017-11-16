/**
 * Created by gq on 2017/5/27.
 * 增加一个学院
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName")==null){
        return false;
    }
    //去空格
    context.wordbookValue = context.wordbookValue.replace(/^\s+|\s+$/g,"");
   if(context.wordbookValue==null || context.wordbookValue=='') return  {result:false,errormessagge:'学院名称不能为空'}
    var q = query(function () {/*
     SELECT *
     FROM `wordbook`
     WHERE wordbookKey='学院' and wordbookValue=${wordbookValue}
     */},context,"");
    if(q && q.length>0) return {result:false,errormessagge:'有该名称的学院了，不能重复添加'}

    var result=exec(function(){/*
     INSERT INTO `wordbook` (
     `wordbookId`,
     `wordbookKey`,
     `wordbookValue`,
     `createMan`,
     `createDate`
     )
     VALUES
     (
     uuid(),
     '学院',
     ${wordbookValue},
     ${sessionUserName},
     now()
     )
     */},context);
    return {result:result,errormessagge:''}
}