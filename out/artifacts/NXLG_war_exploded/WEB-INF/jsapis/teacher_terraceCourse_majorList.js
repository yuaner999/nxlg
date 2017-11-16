/**
 * Created by NEU on 2017/5/31.
 */
function main(context){
    context.type = getsession(context,"sessionUserType");
    if(context.type=="学生"){return {result:false,errormessage:"学生用户没有权限"};}
    else if(context.type=="教师"){
        var r =query(function () {/*
         SELECT * FROM `teacher` WHERE teacherNumber=${sessionUserName}
         */}, context, "");
        if(r.length<1||r==null){
            return {result:false,errormessage:"该教师没有权限"};
        }else{context.teachCollege=r[0].teachCollege;}
    }
    var result=querypagedata(function(){/*
     select * from `major`
     where (isDelete is null or isDelete="否")
     and case when ${type}="教师" then `majorCollege`=${teachCollege} else 1=1 end
     and checkStatus="已通过" and majorStatus="启用"
     order by convert(majorCollege USING gbk) COLLATE gbk_chinese_ci,convert(majorName USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return result;
}