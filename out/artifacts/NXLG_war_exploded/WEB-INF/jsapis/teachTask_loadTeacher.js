/**
 * Created by NEU on 2017/6/29.
 */
function main(context) {
    var r1=query(function () {/*
      SELECT teacherName,teacherId,teachCollege
      FROM teacher
    */},context,"");
    return r1;
}

var inputsamples=[
    {}
]