/**
 * Created by NEU on 2017/4/20.
 */
function main(context){
    var result=query(function(){/*
     SELECT wordbookValue FROM wordbook WHERE wordbookKey="选修开始时间"
     */},context,"");
    return result;
}
var inputsamples=[{

}]