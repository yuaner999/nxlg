/**
 * Created by NEU on 2017/3/17.
 */
function main(context) {
    context.type = getsession(context,"sessionUserType");
    if(context.type=="教师"){
        var r =query(function () {/*
         SELECT * FROM `teacher` WHERE teacherNumber=${sessionUserName}
         */}, context, "");
        if(r.length<1||r==null){
            return {result:false,errormessage:"该教师没有权限"};
        }else{context.teachCollege=r[0].teachCollege;}
    }
    if(context.teachCollege==null){
        context.teachCollege="";
    }
    //加载学院
    var result = query(function () {/*
     select distinct(wordbookValue) from wordbook where wordbookKey='学院'
     and case when ${type}="教师" then wordbookValue like CONCAT('%',${teachCollege},'%') else 1=1 end
     */},context,"");
    return result;
}