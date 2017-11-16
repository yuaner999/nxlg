/**
 * Created by NEU on 2017/5/3.
 */
function main(context) {
    //获取教师用户的，学院和专业
    var r =query(function () {/*
     SELECT * FROM `teacher` WHERE teacherNumber=${sessionUserName}
     */}, context, "");
    return r;
}
