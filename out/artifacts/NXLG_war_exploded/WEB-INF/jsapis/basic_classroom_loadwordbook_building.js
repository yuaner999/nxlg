/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    var result=query(function(){/*
     SELECT
     *
     FROM
     `wordbook`
     WHERE wordbookKey="教学楼"
    */},context,"");
    return result;
}
