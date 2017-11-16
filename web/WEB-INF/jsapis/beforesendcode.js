/**
 * Created by NEU on 2017/4/7.
 */
function main(context) {
    var r = query(function () {/*
     SELECT * FROM user WHERE `userName`=${userName} AND userEmail=${userEmail}
     */}, context, "");
    if (r==null||r.length == 0) {
        return {result: false, errormessage: "用户和邮箱不匹配"};
    }else{
        return {result: true};
    }
}