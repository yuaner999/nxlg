/**
 * Created by liuzg on 2017/2/22.
 */
function main(context) {

    return query(function(){/*
     SELECT c1.`categoryid` c1cateid, c1.`categoryname` c1catename, c2.`categoryid` c2cateid,c2.`categoryname` c2catename
     FROM sp_category c1 INNER JOIN sp_category c2
     ON c1.`categoryid`=c2.`categoryparentid`
     */},context,"c1cateid|cateid,c1catename|catename,subcategories:[c2cateid|cateid,c2catename|catename]")

}