/**
 * Created by NEU on 2017/3/17.
 */
function main(context){
    var result=query(function(){/*
     SELECT
     *
     FROM
     `wordbook`
     WHERE wordbookKey ="培养层次"     
     */},context,"");
    return result;
}