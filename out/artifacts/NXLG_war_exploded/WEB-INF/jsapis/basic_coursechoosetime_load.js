/**
 * Created by NEU on 2017/5/16.
 */
function main(context) {
    var r= query(function () {/*
     SELECT a.wordbookValue AS thischoosestart,b.wordbookValue AS thischooseend,c.wordbookValue AS otherchoosestart,d.wordbookValue AS otherchooseend,
     e.wordbookValue AS tiaojistart,f.wordbookValue AS tiaojiend,g.wordbookValue AS thatchoosestart,h.wordbookValue AS thatchooseend,
     i.wordbookValue AS tiaojicomfirmstart,j.wordbookValue AS tiaojicomfirmend,k.wordbookValue AS tuikestart,l.wordbookValue AS tuikeend
     FROM wordbook a ,wordbook b,wordbook c ,wordbook d,wordbook e,wordbook f,wordbook g,wordbook h,wordbook i,wordbook j,wordbook k,wordbook l
     WHERE a.wordbookKey='本专业课程选课开始时间' AND b.`wordbookKey`='本专业课程选课结束时间'
     AND c.wordbookKey='其他专业课程选课开始时间' AND d.`wordbookKey`='其他专业课程选课结束时间'
     AND e.wordbookKey='调剂开始时间' AND f.`wordbookKey`='调剂结束时间'
     AND g.wordbookKey='辅修选课开始时间' AND h.`wordbookKey`='辅修选课结束时间'
     AND i.wordbookKey='调剂确认开始时间' AND j.`wordbookKey`='调剂确认结束时间'
     AND k.wordbookKey='退课开始时间' AND l.`wordbookKey`='退课结束时间'
     */},context,"thischoosestart,thischooseend,otherchoosestart,otherchooseend,tiaojistart,tiaojiend,thatchoosestart,thatchooseend,tiaojicomfirmstart,tiaojicomfirmend,tuikestart,tuikeend");
    return r;
}