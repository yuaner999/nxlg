/**
 * Created by NEU on 2017/3/17.
 */
function main(context){
    var result=query(function(){/*
     SELECT
     *
     FROM
     `wordbook`
     WHERE wordbookKey ="学科"
     */},context,"");
    return result;
}