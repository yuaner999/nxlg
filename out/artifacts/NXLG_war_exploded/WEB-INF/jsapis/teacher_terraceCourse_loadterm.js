/**
 * Created by NEU on 2017/6/8.
 */
function main(context) {
    var result = query(function () {/*
     SELECT distinct(semester) FROM arrangecourse ORDER BY semester 
     */},context,"");
    return result;
}
