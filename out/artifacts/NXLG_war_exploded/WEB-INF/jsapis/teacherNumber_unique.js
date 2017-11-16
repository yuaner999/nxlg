/**
 * Created by NEU on 2017/3/23.
 */
function main(context) {
    //教师工号唯一
    var result = query(function () {/*
     SELECT * FROM  `user`
     WHERE
     `typeId` <> ${teacherId}
     AND `userName` = ${teacherNumber}
     */},context,"");
    return result;
}