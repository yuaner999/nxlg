/**
 * Created by NEU on 2017/4/18.
 */
// 加载课程信息
function main(context) {
    var r =query(function () {/*
     SELECT `teacher`.`teachCollege` FROM `teacher` WHERE teacherNumber=${sessionUserName}
     */}, context, "");
    return r;
}
