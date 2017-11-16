/**
 * Created by NEU on 2017/5/18.
 */
function main(context) {
    //基础数据非空判断
    if(context.tc_id == null||context.majorId == null||context.mtc_grade == null){
        return false;
    }
    var r =exec(function(){/*
     INSERT INTO `tcmajor` (
     `tcm_id`,
     `tcm_tc_id`,
     `tcm_majorid`,
     `tcm_grade`
     ) 
     VALUES
     (
     UUID(),
     ${tc_id},
     ${majorId},
     ${mtc_grade}
     ) ;
     */}, context);
    return r;
}
