/**
 * Created by NEUNB_Lisy on 2017/5/17.
 * 根据ID值查找空余教室
 */

function main(context) {
    var result = query(function () {/*
     SELECT *
     FROM
     `classroom`
     WHERE
     `classroomId` = ${classroomId}
     */},context,"");
    return result;
}
