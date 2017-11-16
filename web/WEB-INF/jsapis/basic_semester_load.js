/**
 * Created by NEU on 2017/6/12.
 */
function main(context){
    var term=query(function () {/*
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    return term;
}