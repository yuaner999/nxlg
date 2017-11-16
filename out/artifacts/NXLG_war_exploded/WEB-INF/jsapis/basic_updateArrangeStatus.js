/**
 * Created by gq on 2017/6/5.
 */
/*function main(context) {
    var up = exec(function(){/!*
     UPDATE  `wordbook`
     SET
     `wordbookValue` = ${wordbookValue}
     WHERE `wordbookKey` = '排课状态' ;
     *!/}, context);
    if (!up) {return false};
    return true;
}*/
function main(context) {
    //基础数据非空判断
    if(context.wordbookValue == null){
        return false;
    }
    var up = exec(function(){/*
        UPDATE  `wordbook`
        SET
        `wordbookValue` = ${wordbookValue}
        WHERE `wordbookKey` = '排课状态' ;
    */}, context);
    if (!up) {return false};
    return true;
}