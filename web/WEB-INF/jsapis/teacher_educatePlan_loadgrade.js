/**
 * Created by NEU on 2017/5/3.
 */
function main(context){
    var result=query(function(){/*
     SELECT
     *
     FROM
     `wordbook`
     WHERE wordbookKey="年级"
     and case when ${grade} is null then 1=1 else wordbookValue like ${grade} end
     order by wordbookValue desc
     */},context,"");
    return result;
}
