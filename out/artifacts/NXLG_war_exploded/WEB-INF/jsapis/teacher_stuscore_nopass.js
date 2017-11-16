/**
 * Created by NEU on 2017/6/6.
 */
function main(context){
    //基础数据非空判断
    if(context.stulist.length < 1){
        return false;
    }
    var con = createconnection();
    for(var i=0;i<context.stulist.length;i++){
        var result=multiexec(con,function(){/*
         update stuchoosecourse set pass="未通过" where scc=${scc}
         */},context.stulist[i]);
        if(!result) {rollback(con);closeconnection(con);return {result:false,errormessage:"失败"}};
    }
    commit(con);
    closeconnection(con);
    return true;
}