/**
 * Created by NEU on 2017/3/17.
 */
function main(context){
    var result=query(function(){/*
     SELECT
     *
     FROM
     `wordbook`
     WHERE wordbookKey ="学院"
     and case when ${college} is null then 1=1 else wordbookValue like ${college} end
     order by wordbookValue
     */},context,"");
    return result;
}