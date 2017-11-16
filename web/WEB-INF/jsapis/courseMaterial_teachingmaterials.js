/**
 * Created by NEU on 2017/5/18.
 */
function main(context){
    var result=query(function(){/*
     SELECT * FROM `teachingmaterials`
     */},context,"");
    return result;
}
