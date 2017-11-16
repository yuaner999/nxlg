/**
 * Created by NEU on 2017/5/20.
 */
function main(context){
    var r = exec(function () {/*
     delete
     from
     `nxlg`.`stuchoosecourse`
     where scc=${scc};
     */}, context);
    return r;
}
var inputsamples=[{
    scc:'6a99a895-3f92-11e7-a6e6-00ac9c2c0afa'
}]
