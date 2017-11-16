/**
 * Created by NEU on 2017/4/21.
 * 新增教材信息
 */
function main(context){
    //数据非空判断
    if(context.booknumber == null ||context.name == null ||context.press == null ||context.edition == null ||
        context.price == null){
        return false;
    }
    var r=query(function () {/*
        SELECT booknumber
        FROM teachingmaterials
        WHERE name=${name} AND press=${press} AND edition=${edition} AND booknumber=${booknumber} AND price=${price} AND isdelete = '0'
    */},context,"");
    if(r.length>0){
        return 1;
    }
    var result=exec(function(){/*
     INSERT INTO teachingmaterials (
     `tmId`,
     `name`,
     `press`,
     `edition`,
     `booknumber`,
     `price`,
     `isdelete`
     )
     VALUES
     (
     uuid(),
     ${name},
     ${press},
     ${edition},
     ${booknumber},
     ${price},
     '0'
     ) 
     */},context);
    return result;
}
var inputsamples=[
    {
        booknumber:"121325454545"
    }
]