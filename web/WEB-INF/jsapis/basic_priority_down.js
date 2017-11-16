/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    //基础数据非空判断
    if(context.sort == null||context.id == null){
        return false;
    }
    //基础数据数值型判断
    if(isNaN(context.sort)){
        return false;
    }
    var con = createconnection();
    context.changesort=parseInt(context.sort)+1;
    var result1=multiexec(con,function(){/*
     UPDATE prioritysort SET sort=sort-1 WHERE sort=${changesort}
     */},context);
    if(!result1){
        rollback(con);
        closeconnection(con);
        return false;
    }
    var result=multiexec(con,function(){/*
     UPDATE prioritysort SET sort=sort+1 WHERE id=${id}
     */},context);
    if(!result){
        rollback(con);
        closeconnection(con);
        return false;
    }
    commit(con);
    closeconnection(con);
    return true;
}
/* var inputsamples=[
 {
 id:'12',
 sort:12

 }
 ]*/

