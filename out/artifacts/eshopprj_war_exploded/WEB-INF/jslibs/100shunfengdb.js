/**
 * Created by Administrator on 2016/12/28.
 */

//代理部分
db.relation("rs_shop.goods","rs_shop.shopid=rs_shop_dish.shopid","1:n")
db.relation("rs_shop.categories","rs_shop.shopid=rs_shop_category.shopid","1:n")
db.relation("rs_shop_category.goods","rs_shop_category.categoryid=rs_shop_dish.dishcategory","1:n")

//限制
db.constraint("rs_order","ordercreatetime","NOW()",null);

function initdb() {
    db.entities = query(function () {/*
     SELECT TABLE_NAME,COLUMN_NAME,IS_NULLABLE,COLUMN_KEY='PRI' PK,COLUMN_TYPE,COLUMN_KEY,COLUMN_COMMENT FROM INFORMATION_SCHEMA.Columns WHERE table_schema='shunfeng'
     ORDER BY TABLE_NAME,ORDINAL_POSITION
     */},{},"TABLE_NAME|entityname,properties:[COLUMN_NAME|fieldname,PK,IS_NULLABLE,COLUMN_TYPE,COLUMN_KEY,COLUMN_COMMENT]")
}
initdb()
addpkconstaints("UUID()");
