/**
 * Created by NEU on 2017/6/12.
 */
function main(context){
    //基础数据非空判断
    if(context.transferid == null){
        return false;
    }
    var result=exec(function(){/*
     UPDATE
     `nxlg`.`transferapply`
     SET
     `reason` =${reason},
     `setdate` = NOW(),
     `status` = '待审核'
     WHERE `transferid` = ${transferid} ;
     */},context);
    return{result:result,errormessage:''}
}