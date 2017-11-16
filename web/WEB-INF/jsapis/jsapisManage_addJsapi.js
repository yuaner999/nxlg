/**
 * Created by NEUNB_Lisy on 2017/7/15.
 */
function main(context) {
    //基础数据非空判断
    if(context.jsapis_name == null||context.menuId== null){
        return false;
    }
    var r =exec(function(){/*
     INSERT INTO `menu_jsapi` (
     `mj_id`,
     `menuId`,
     `jsapis_name`
     )
     VALUES
     (
     UUID(),
     ${menuId},
     ${jsapis_name}
     ) ;
     */}, context);
    return r;
}
