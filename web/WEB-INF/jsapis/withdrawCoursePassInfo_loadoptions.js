/**
 * Created by gq on 2017/6/3.
 */
function main(context){
    var major= query(function () {/*
     SELECT majorId,majorName FROM major WHERE majorStatus='启用' AND checkStatus='已通过'
     */},context,"");

    var semester= query(function () {/*
     SELECT  `term`
     FROM `stuchoosecourse` GROUP BY term
     */},context,"");

    var course= query(function () {/*
     SELECT  `courseId`,`chineseName`
     FROM `course`  WHERE checkstatus='已通过'
     */},context,"");


    return {major:major,semester:semester,course:course}
}
