/**
 * Created by NEU on 2017/3/20.
 */
function main(context) {
    //加载
    var result = query(function () {/*
     SELECT * FROM `student`
     WHERE
     `studentId` = ${studentId}
     */},context,"");
    return result;
}