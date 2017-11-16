/**
 * Created by NEU on 2017/5/31.
 */
function main(context) {
    var r =query(function () {/*
     SELECT * FROM `teacher` WHERE teacherNumber=${sessionUserName}
     */}, context, "");
    if(r.length<1||r==null){
        return false;
    }else{return r;}
}