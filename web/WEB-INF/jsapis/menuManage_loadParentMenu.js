/**
 * Created by liulei on 2017-03-04.
 */
function main(context) {
    //加载菜单
    var result = query(function () {/*
        select * from menu where menuParent='' order by menuSort
    */},context,"");
    return result;
}