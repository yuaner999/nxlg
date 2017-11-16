/**
 * Created by NEUNB_Lisy on 2017/7/31.
 */
function main(context) {
    //判断基础数据是否为空
    if (context.menuId == null || context.jsapis_name == null){
        return false;
    }
    var con = createconnection();
    var result = multiexec(con , function () {/*
        UPDATE
        `menu_jsapi`
        SET
        `menuId` = ${menuId},
        `jsapis_name` = ${jsapis_name}
        WHERE `mj_id` = ${mj_id}
    */},context);
    if(!result){
        rollback(con);
        closeconnection(con);
        return result;
    };

    commit(con);
    closeconnection(con);
    return result;
}