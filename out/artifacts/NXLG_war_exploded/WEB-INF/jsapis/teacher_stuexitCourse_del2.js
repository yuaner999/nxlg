/**
 * Created by NEU on 2017/4/18.
 */
function main(context){
    var result=exec(function(){/*
     delete from stuchoosecourse where scc=${scc}
     */},context);
    return result;
}
