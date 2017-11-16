/**
 * Created by NEU on 2017/5/15.
 */
function main(context) {
    var result = query(function () {/*
     SELECT *
     FROM
     `course`
     WHERE courseId=${id}
     */},context,"");
    return result;
}
