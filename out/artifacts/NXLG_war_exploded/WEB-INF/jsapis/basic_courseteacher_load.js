/**
 * Created by NEU on 2017/5/16.
 */
function main(context){
    var result=query(function(){/*
     SELECT * FROM `teacher`
     */},context,"");
    return result;
}
