/**
 * Created by NEU on 2017/4/21.
 */
function main(context){
    var r=query(function(){/*
     select * from `major` where relationId=${majorId} AND checkStatus="待审核" AND (isDelete IS NULL OR isDelete="否")
     */},context,"");
    console("hahaha"+r);
    if(r.length<1||r==null){
        var result=query(function(){/*
         select * from `major` where majorId=${majorId} and majorStatus=${Mstatus} and (isDelete IS NULL OR isDelete="否")
         */},context,"");
        if(result.length<1||result==null){
            return 3;
        }else{
            return 2;
        }
    }else{
        return 1;
    }
}