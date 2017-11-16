/**
 * Created by NEU on 2017/4/8.
 * 获取角色菜单
 */
function main(context) {
    if(context.roleId==""||context.roleId==null){
        var data=query(function (){/*
         select menuId,menuName,menuParent from menu
        */},context,"");
        return data;
    }else{
        var data=query(function (){/*
         select menuId from role_menu where roleId=${roleId}
         */},context,"");
        return data;
    }
}