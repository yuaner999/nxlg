/**
 * Created by NEU on 2017/6/19.
 */
function main(context){
    //基础数据非空判断
    if(context.isenabled == null||context.id == null||context.punishValue == null){
        return false;
    }
    //基础数据数值型判断
    if(isNaN(context.punishValue)){
        return false;
    }
    var result = exec(function () {/*
     UPDATE  `nxlg`.`prioritysort` 
     SET   `isenabled` = ${isenabled},  `punishValue` = ${punishValue} 
     WHERE `id` = ${id} ;
     */},context);
    return result;
}
