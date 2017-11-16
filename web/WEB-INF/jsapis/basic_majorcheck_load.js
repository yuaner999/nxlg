/**
 * Created by NEU on 2017/7/1.
 */
function main(context) {
    var n= query(function () {/*
     SELECT * from tcmajor where tcm_tc_id=${tc_id}
     */},context,"");
     return {total:n.length,rows:n};
}
var inputsamples=[{

}]
