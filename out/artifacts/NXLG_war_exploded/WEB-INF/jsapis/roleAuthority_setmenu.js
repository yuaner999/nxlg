/**
 * Created by NEU on 2017/4/10.
 * 添加角色菜单
 */
function main(context) {
    //基础数据非空判断
    if(context.roleId == null){
        return false;
    }
    var data=query(function (){/*
     select menuId from role_menu where roleId=${roleId}
     */},context,"");
    if(data.length>0) {
        var con = createconnection();
        var result = multiexec(con, "delete from role_menu where roleId=${roleId}", context);
        if (!result) {
            rollback(con);
            closeconnection(con);
            return false;
        }
        commit(con);
        closeconnection(con);
    }
    for (var i = 0; i < context.node.length; i++) {
        var menuId = context.node[i];
        context.menuId = menuId;
        var data = exec(function () {/*
         INSERT INTO role_menu(`rmId`,`roleId`,`menuId`)
         VALUES
         (uuid(),${roleId},${menuId})
         */}, context, "");
        if (data == false) {
            return false;
        }
    }
    return true;
}