/**
 * Created by gq on 2017/5/27.
 * 加载任教学院
 */
function main(context) {
    var result = querypagedata(function () {/*
     SELECT wordbookValue FROM wordbook WHERE wordbookKey='学院'
     */},context,"");
    return result;
}