
/**
 * Created by NEU on 2017/5/23.
 */
function main(context){
    //数据非空判断
    if(context.scc == null){
        return false;
    }
    var r =  exec(function () {/*
     UPDATE
     `nxlg`.`stuchoosecourse`
     SET
     `scc_status` = "退课申请",
     `Areason` = ${reason}
     WHERE `scc` = ${scc};
    */},context);
    return r;
}
