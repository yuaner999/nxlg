/**
 * Created by gq on 2017/6/1.
 * 查询新建班级时所需的 学院 专业 年级 下拉选
 */
function main(context) {
    var co = query(function () {/*
     SELECT * FROM wordbook WHERE wordbookKey='学院'
     */},context,"");

    var ma = query(function () {/*
     SELECT * FROM major WHERE (isDelete='否' or isDelete is null) and majorStatus='启用' and checkStatus='已通过'
     */},context,"");

    var gr = query(function () {/*
     select * from wordbook where wordbookKey='年级'
     */},context,"");

    // var se = query(function () {/*
    //  SELECT semester FROM bookdistribution GROUP BY semester
    //  */},context,"");
    var se = query(function () {/*
     SELECT semester FROM arrangecourse GROUP BY semester
     */},context,"");

    var cl = query(function () {/*
      select * from class
     */},context,"");

    var te = query(function () {/*
     select * from terrace
     */},context,"");

    var sem = query(function () {/*
     SELECT semester FROM arrangecourse GROUP BY semester
     */},context,"");

    var semNow = query(function () {/*
     SELECT semester FROM arrangecourse WHERE arrangecourse.is_now=1
     */},context,"");

    return {college:co,major:ma,grade:gr,semester:se,class:cl,terrace:te,newsemester:sem,semNow:semNow};
}