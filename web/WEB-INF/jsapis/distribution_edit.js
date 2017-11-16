/**
 * Created by gq on 2017/6/1.
 */
function main(context){
    //基础数据非空判断
    if(context.deleteId == null){
        return false;
    }
    var result=exec(function(){/*
     UPDATE
     `bookdistribution`
     SET
     `is_giveout`='是'
     WHERE `distributionId` = ${deleteId}
     */},context);
    return result;
}