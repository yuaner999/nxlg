/**
 * Created by NEU on 2017/5/15.
 */
// 加载课程信息
function main(context) {
    var result = query(function () {/*
     SELECT *
     FROM
     `course`
     WHERE checkStatus="已通过" and courseStatus="启用" 
     */},context,"");
    return result;
}
