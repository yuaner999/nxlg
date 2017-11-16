/**
 * Created by NEU on 2017/6/7.
 */
function main(context) {
    var r =query(function () {/*
     SELECT
     ep_college,COUNT(*) AS checkall
     FROM
     `nxlg`.`educateplane`
     WHERE (`educateplane`.ep_isDelete IS NULL OR `educateplane`.ep_isDelete="否") AND `educateplane`.ep_checkStatus="待审核"
     GROUP BY ep_college
     */}, context, "");
    return r;
}
