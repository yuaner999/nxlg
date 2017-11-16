/**
 * Created by NEU on 2017/5/3.
 */
function main(context){
    var result=query(function(){/*
     SELECT
     *
     FROM
     `wordbook`
     WHERE wordbookKey="课程类别一"
     */},context,"");
    return result;
}
