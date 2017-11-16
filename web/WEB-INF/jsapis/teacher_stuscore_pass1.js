function main(context){
    //基础数据非空判断
    if(context.scc == null){
        return false;
    }
    var result=exec(function(){/*
     update stuchoosecourse set pass="已通过" where scc=${scc}
     */},context);
    return result;
}