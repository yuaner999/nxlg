/**
 * Created by gq on 2017/6/5.
 */
function main(context) {
    var r= query(function () {/*
     SELECT a.wordbookValue AS paystart,b.wordbookValue AS payend
     FROM wordbook a ,wordbook b
     WHERE a.wordbookKey='排课开始时间' AND b.`wordbookKey`='排课结束时间'
     */},context,"paystart,payend");
    return r;
}