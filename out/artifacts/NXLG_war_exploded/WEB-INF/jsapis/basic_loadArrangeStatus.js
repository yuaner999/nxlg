/**
 * Created by gq on 2017/6/5.
 */
function main(context) {
    var result = query(function () {/*
     SELECT * FROM wordbook WHERE wordbookKey='排课状态'
     */},context,"");
    return result;
}