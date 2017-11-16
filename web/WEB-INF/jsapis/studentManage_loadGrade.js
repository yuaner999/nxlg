/**
 * Created by NEU on 2017/3/17.
 */
function main(context) {
    //加载年级
    var result = query(function () {/*
     select distinct(wordbookValue) from wordbook where wordbookKey='年级'
     */},context,"");
    return result;
}