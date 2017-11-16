/**
 * Created by NEU on 2017/5/18.
 */
// 加载后续课程信息
function main(context) {
    var result = query(function () {/*
     SELECT *
     FROM
     `course`
     WHERE courseId=${CId}
     */},context,"");
   // console(result[0].chineseName);
    //console(context.tc_teachmore);
    if(result[0].chineseName==context.tc_teachmore){
        return false;
    }
    return true;
}
