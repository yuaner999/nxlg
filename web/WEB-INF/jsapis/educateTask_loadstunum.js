/**
 * Created by NEU on 2017/6/26.
 */
function main(context) {
    var r = query(function () {/*
     SELECT
     COUNT(DISTINCT studentId) AS snum1
     FROM  `student`
     WHERE studentGrade=${ep_grade} and studentCollege=${ep_college} and studentMajor=${ep_major}
     */}, context, "");
    return r;
}