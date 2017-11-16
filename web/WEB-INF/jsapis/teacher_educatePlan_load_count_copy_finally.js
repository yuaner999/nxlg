function main(context){
    //sessionUserName非空判断

    var sessionUserName = getsession(context,"sessionUserName");

    console(sessionUserName)

    if(sessionUserName == null){
        return false;
    }
    //这三个字段用于更新
    var a = context.a;
    var b = context.b;
    var c = context.c;
    //被复制的信息
    var _copy_college_information = context._copy_college_information;

    //执行批量更新操作
    for(var i=0;i<_copy_college_information.length;i++){
        var id = _copy_college_information[i].ep_id;
        var term = _copy_college_information[i].ep_term;
        var chineseName = _copy_college_information[i].ep_courseid;
        var courseCategory = _copy_college_information[i].courseCategory_1;
        var terrace = _copy_college_information[i].ep_terrace;
        var checkway = _copy_college_information[i].ep_checkway;
        var week = _copy_college_information[i].ep_week;
        var queryCollege = exec(function(){/*
           INSERT INTO educateplane
           VALUES (UUID(),${c},${a},${b},${term},${chineseName},${courseCategory},${terrace},${checkway},NULL,${week},NULL,'待审核','新增',NULL,NULL,NULL,${sessionUserName},NOW(),NULL)
        */},{a:a,b:b,c:c,id:id,term:term,chineseName:chineseName,courseCategory:courseCategory,terrace:terrace,checkway:checkway,week:week,sessionUserName:sessionUserName})
    }

    return {errormessage:"success"};
}