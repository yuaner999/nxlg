/**
 * Created by NEUNB_Lisy on 2017/5/17.
 */
//查询当前学期的值
function main(context) {
    var result = query(function () {/*
     SELECT
       *
     FROM
    `arrangecourse`
     WHERE
     is_now="1"
     */},context,"");
    return result;
}