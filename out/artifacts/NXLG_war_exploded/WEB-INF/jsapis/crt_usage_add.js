/**
 * Created by NEUNB_Lisy on 2017/5/24.
 * 已废弃
 */
function main(context){
    //基础数据非空判断
    if(context.crt_type == null||context.crt_usage == null){
        return false;
    }
    var result=exec(function(){/*
     INSERT INTO `classroomtype`
     (`crt_id`,
     `crt_type`,
     `crt_usage`)
     VALUES
     (
     uuid(),
     ${crt_type},
     ${crt_usage}
     )
     */},context);
    return result;
}