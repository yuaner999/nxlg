/**
 /**
 * Created by NEU on 2017/4/20.
 */
function main(context){
    var result=query(function(){/*
     SELECT wordbookValue FROM wordbook WHERE wordbookKey="辅修结束时间"
     */},context,"");
    return result;
}