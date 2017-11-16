/**
 * Created by NEU on 2017/5/3.
 */
function main(context){
    var result=query(function(){/*
     SELECT DISTINCT(`majorName`) FROM `major` WHERE majorCollege=${ep_college} and (isDelete is null or isDelete="否") and checkStatus="已通过"
     */},context,"");
    return result;
}
