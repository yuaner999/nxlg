package com.nxlg.rulesloader;

import com.nxlg.rules.rule.IRule;
import com.nxlg.rules.ruleLoader.IRuleLoader;
import com.nxlg.rules.ruleLoader.JsonRuleLoader;
import com.nxlg.rules.ruleLoader.JsonStringSourceContext;
import com.nxlg.utils.DbUtils;

import javax.sql.DataSource;
import java.util.*;

/**
 * Created by NEU on 2017/6/6.
 */
public class DbJsonRulesLoader implements IRulesLoader {
    private DataSource dataSource;

    @Override
    public Set<IRule> loadRules() {

        List<String> blacklist = Arrays.asList(
//                "com.nxlg.rules.RoomCapacityRule",
//                "com.nxlg.rules.CouresSectionRule",
//                "com.nxlg.rules.CoteRoomType",
//                "com.nxlg.rules.SameCourseOneday",
//                "com.nxlg.rules.SameCourseNeighbordays",
//                "com.nxlg.rules.SameSectionOneCourseOneWeek",
//                "com.nxlg.rules.SameSectionOneTeacher",
//                "com.nxlg.rules.SchoolHours",
//                "com.nxlg.rules.NextCourseIsNull",
//                "com.nxlg.rules.NoArrangeCourse"
        );
        //上一周课程结果
//        List<TCcRSw> tCcRSwResult = new ArrayList<>();
        //初始化上一周课程列表


        //从数据库中取出规则列表
        String sql = "SELECT * FROM prioritysort where isenabled='1'";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);
        Set<IRule> rules = new HashSet<>();
        IRuleLoader loader = new JsonRuleLoader();
        JsonStringSourceContext jsoncontext = new JsonStringSourceContext();
        for (Map<String, Object> row : rows)
            try {
                String classname = row.get("classname").toString();
                String punishvalue = row.get("punishValue").toString();
//                classpath += (",lastweekdata:" + tCcRSwResult);
//                if (blacklist.contains(classpath)) continue;
                String classpath = "{'ClassName':'" + classname + "','punishValue':" + punishvalue + "}";
                jsoncontext.loadSource(classpath);
                IRule rule = (IRule) loader.createObject(jsoncontext.getData());
                rules.add(rule);
            } catch (Exception e) {
                e.printStackTrace();
            }
        return rules;

    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

}
