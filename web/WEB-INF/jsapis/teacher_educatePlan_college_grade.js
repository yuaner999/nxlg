function main(context){

    var selgradeInf = query(function(){/*
        SELECT DISTINCT(wordbookValue) FROM wordbook WHERE wordbookKey='年级'  ORDER BY wordbookValue DESC
    */},context,"")

    if(selgradeInf.length == 0){
        return {result:false,errormessage:"请没有查询到年级信息"}
    }

    return {result:true,_sel_grade:selgradeInf}
}