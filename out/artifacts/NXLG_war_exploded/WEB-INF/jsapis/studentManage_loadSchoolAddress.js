/**
 * Created by NEU on 2017/3/17.
 */
function main(context) {
    //加载校区
    var result = query(function () {/*
     select distinct(wordbookValue) from wordbook where wordbookKey='校区'
     */},context,"");
    return result;
}