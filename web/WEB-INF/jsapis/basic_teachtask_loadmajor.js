/**
 * Created by NEU on 2017/5/20.
 */
function main(context){
    var r=query(function () {/*
     select major.*,tcmajor.tcm_grade
     from tcmajor
     left join major on tcmajor.tcm_majorid=major.majorId
     where tcmajor.tcm_tc_id=${tc_id}
     */},context,"");
    return r;
}
