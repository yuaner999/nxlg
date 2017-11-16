/**
 * Created by gq on 2017/6/5.
 */
function main(context) {
    var result = query(function () {/*
     SELECT * FROM wordbook WHERE wordbookKey='排课错误信息'
     */},context,"");
    return result;
}