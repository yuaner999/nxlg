/**
 * Created by zcy on 2017/5/24.
 * 查询自助缴费时间
 */
function main(context) {
    var result=query(function () {/*
      SELECT wordbookValue FROM wordbook WHERE wordbookKey="教材自助缴费开始时间"
      UNION all
     SELECT wordbookValue FROM wordbook WHERE wordbookKey="教材自助缴费结束时间"
    */},context,"");
    return result;
}

var inputsamples=[
    {}
]