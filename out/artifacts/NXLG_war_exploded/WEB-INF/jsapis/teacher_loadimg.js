/**
 * Created by NEU on 2017/3/20.
 */
function main(context) {
    //加载
    var result = query(function () {/*
     SELECT * FROM `teacher`
     WHERE
     `teacherId` = ${teacherId}
     */},context,"");
    return result;
}