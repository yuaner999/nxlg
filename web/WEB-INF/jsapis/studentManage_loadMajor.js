/**
 * Created by NEU on 2017/4/20.
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
    //加载专业
    var result = query(function () {/*
     SELECT `majorId`, `majorName` FROM `major` WHERE 1=1
     and case when ${majorCollege} is not null and ${majorCollege}<>'' then  majorCollege=${majorCollege} else 1=1 end
     AND  (`major`.`checkStatus` = '已通过') AND (ISNULL(`major`.`isDelete`) OR (`major`.`isDelete` = '否'))
     and case when ${type}="教师" then majorCollege like CONCAT('%',${teachCollege},'%') else 1=1 end
     */},context,"");
    return result;
}