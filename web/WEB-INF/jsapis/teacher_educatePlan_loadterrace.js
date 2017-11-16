/**
 * Created by NEU on 2017/5/3.
 */
function main(context){
    var result=query(function(){/*
     SELECT distinct(terraceName) FROM `terrace`
     */},context,"");
    return result;
}
