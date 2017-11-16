/**
 * 这个接口用于修改课程状态为删除
 **/

function main(context){
    var tc_id = context.tc_id;

    var result = exec(function(){/*
        delete from teachtask where tc_id = ${tc_id}
    */},{tc_id:tc_id});
    return result;
}