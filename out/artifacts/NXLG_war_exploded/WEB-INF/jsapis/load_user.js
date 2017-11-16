/**
 * Created by NEU on 2017/3/23.
 */
function main(context) {
   var result=query(function () {/*
     select userName,typeName from user where userId=${userId}  
   */},context,"");
    return result;
}