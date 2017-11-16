/**
 * Created by NEU on 2017/4/18.
 */
function main(context){
    var result=query(function(){/*
     SELECT wordbook.`wordbookId`,wordbook.`wordbookValue` FROM wordbook
     WHERE wordbook.`wordbookKey` = '培养层次'
     */},context,"");

    return result;
}