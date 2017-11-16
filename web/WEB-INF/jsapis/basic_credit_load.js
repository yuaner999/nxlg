/**
 * Created by NEU on 2017/5/16.
 *
 */
function main(context) {
    var t=query(function () {/*
     SELECT
     a.majorId AS amajorId,`user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     LEFT JOIN major a ON a.majorName=student.studentMajor
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     AND a.`checkStatus`='已通过' AND (ISNULL(a.`isDelete`) OR (a.`isDelete` = '否'))
     */}, context,"");
    context.majorId=t[0].amajorId;
    var r= query(function () {/*
     SELECT  *  FROM majorterracescore
     WHERE majorId=${majorId} and terraceId=${terraceId}
     */},context,"");
    return r;
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa'
}]