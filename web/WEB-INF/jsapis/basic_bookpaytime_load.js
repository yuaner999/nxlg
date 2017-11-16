/**
 * Created by NEU on 2017/5/16.
 */
function main(context) {
    var r= query(function () {/*
     SELECT a.wordbookValue AS paystart,b.wordbookValue AS payend
     FROM wordbook a ,wordbook b
     WHERE a.wordbookKey='教材自助缴费开始时间' AND b.`wordbookKey`='教材自助缴费结束时间'
     */},context,"paystart,payend");
    return r;
}