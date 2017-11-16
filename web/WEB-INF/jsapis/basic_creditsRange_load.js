/**
 * Created by NEU on 2017/5/16.
 */
function main(context) {
    var r= query(function () {/*
     SELECT a.wordbookValue AS mincredits,b.wordbookValue AS maxcredits FROM wordbook a ,wordbook b WHERE a.wordbookKey='最低学分' AND b.`wordbookKey`='最高学分'
     */},context,"mincredits,maxcredits");
    return r;
}