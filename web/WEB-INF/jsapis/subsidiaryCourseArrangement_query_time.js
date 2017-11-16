/**
 * Created by NEUNB_Lisy on 2017/5/20.
 */
//查询排课信息
function main(context) {
    var result = query(function () {/*
     SELECT
     *
     FROM
     `arrangelesson`
     WHERE
     tc_id=${tc_id}
     */},context,"");
    return result;
}