/**
 * Created by NEU on 2017/5/18.
 */
function main(context) {
    //基础数据非空判断
    if(context.tc_id == null||context.tMajors == null){
        return false;
    }

    console(context.tc_id)
    console(context.tMajors)
    //数据为待审核且没有设置专业，则tcmajor无操作。
    var con=createconnection();
    if(context.tc_checkStatus!="已通过"){
        var delfirst=query(function () {/*
        select * from tcmajor where tcm_tc_id=${tc_id};
        */},context,"");
        if(delfirst.length>0){
            var del=multiexec(con,function(){/*
             delete from tcmajor where tcm_tc_id=${tc_id};
             */},context);
            if(!del){
                rollback(con);
                closeconnection(con);
                return false;
            }
        }
    }
    for (var i=0;i<context.tMajors.length;i++){
        var majorId=context.tMajors[i].majorId;
        var tc_id=context.tc_id;
        var tcm_grade=context.tMajors[i].tcm_grade;
        var insert=multiexec(con,function(){/*
         INSERT INTO `tcmajor` (`tcm_id`,`tcm_tc_id`,`tcm_majorid`,`tcm_grade`)
         VALUES (UUID(),${tc_id},${majorId},${tcm_grade}) ;
         */},{tc_id:tc_id,majorId:majorId,tcm_grade:tcm_grade});
        if(!insert){
            rollback(con);
            closeconnection(con);
            return false;
        }
    }
    commit(con);
    closeconnection(con);
    return true;
}
