/**
 * Created by NEU on 2017/4/18.
 */
function main(context) {
    //用来判断添加和修改时课程代码是否已存在
    var result = query(function () {/*
     SELECT * FROM  course
     WHERE
     `courseCode` = ${courseCode}
     */},context,"");
    return result;
}