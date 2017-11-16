/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    var result=query(function(){/*
     SELECT
     DISTINCT(`crt_type`) AS crt_type
     FROM
     `nxlg`.`classroomtype`
    */},context,"");
    return result;
}
var inputsamples=[
    {}
]