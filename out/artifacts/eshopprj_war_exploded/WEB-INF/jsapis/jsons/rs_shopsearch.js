/**
 * Created by liuzg on 2017/3/4.
 */
function main(context) {
    // var r = querypagedata("select * from rs_shop where shopname like concat('%',${shopname},'%')",context,"",context.page,context.rows);
    // return r;
    //
    // return query(function () {/*
    //     select * from rs_shop
    // */},context,"shopname,a[]")

    // exec("insert into rs_shop()")

    // var con = createconnection();
    // var r1 = multiexec(con,"insert order",context);
    // if(r1){
    //     for(var i=0;i<context.orderitems.length;i++){
    //         var orderitem = context.orderitems[i];
    //         var r2 = multiexec(con,"insert orderitem",context)
    //         if(!r2) {
    //             rollback(con);
    //             closeconnection(con);
    //             return {result:false,errormessage:"xxxxx"}
    //         }
    //     }
    // }
    // commit(con);
    // closeconnection(con);
    // return {};

    // var q = dbcontext().query("rs_shop[goods,categories[goods]]")
    //     .search("dishname","root.goods.dishname=${dishname}")
    //     .search("shopname","root.shopname=${shopname}")
    //     .buildsqlquery();
    // var r = query(q.sql,context,q.mappingstr);
    // return {total:r.length,rows:r,q:q};

    insertentity("rs_shop",context)
    insertentitybatch()
    updateentity()
    updateentitybatch()
    deleteentity()


}