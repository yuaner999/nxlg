/**
 * Created by NEU on 2017/3/15.
 */
function main(context) {
    //加载角色
    var result = query(function () {/*
     select distinct(roleName),roleId from role where isNeuNb='否'
     */},context,"");
    return result;
}