/**
 * Created by NEU on 2017/3/17.
 */
function main(context) {
    //加载学院
    var result = query(function () {/*
     select distinct(wordbookValue) from wordbook where wordbookKey='学院'
     */},context,"");
    return result;
}