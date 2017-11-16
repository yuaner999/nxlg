/**
 * Created by NEU on 2017/5/16.
 */
function main(context){
    var result=query(function(){/*
    SELECT
    *
    FROM
    `teacher`
    WHERE
    `teacher`.`teachCollege`=
     (
         SELECT
         `teachCollege`
         FROM
         `nxlg`.`user`
         LEFT JOIN `nxlg`.`teacher`
         ON (`teacher`.`teacherId`=`user`.`typeId`)
         WHERE
         `userId`=${sessionUserID}
     )
     */},context,"");
    return result;
}
