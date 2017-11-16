/**
 * Created by NEU on 2017/5/31.
 */
function main(context) {
    var r = query(function () {/*
     SELECT majorName FROM `major` WHERE majorId=${tc_majorId} 
     */}, context, "");
    return r;
}
