/**
 * Created by NEU on 2017/6/12.
 */
function main(context){
    var result=exec(function(){/*
     DELETE  FROM   `nxlg`.`transferapply`
     WHERE `transferid`=${transferid}
     */},context);
    return{result:result,errormessage:''}
}