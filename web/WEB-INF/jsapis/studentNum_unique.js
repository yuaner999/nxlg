/**
 * Created by NEU on 2017/3/16.
 */
function main(context) {
    //用来判断添加和修改时学生学号是否已存在
    var result = query(function () {/*
     SELECT `user`.`userId` FROM  `user`
     WHERE
     `typeId` <> ${studentId}
     AND `userName` = ${studentNum}
     */},context,"");
    return result;
}