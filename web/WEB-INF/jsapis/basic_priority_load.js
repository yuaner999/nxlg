/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    var result=query(function(){/*
    select * from prioritysort
     ORDER BY sort 
     */},context,"");
    return result;
}
