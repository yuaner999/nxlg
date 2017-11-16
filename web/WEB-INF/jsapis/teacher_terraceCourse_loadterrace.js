/**
 * Created by NEU on 2017/6/21.
 */
function main(context){
    var result=query(function(){/*
     SELECT  `terraceId`,`terraceName`
     FROM `terrace` order by convert(terraceName USING gbk)
     */},context,"");
    return result;
}