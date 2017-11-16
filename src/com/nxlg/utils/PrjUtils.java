package com.nxlg.utils;

import com.nxlg.model.DbTCcRSw;
import com.nxlg.model.TCcRSw;
import com.nxlg.rules.TCcRSwIndex;

import java.util.*;

/**
 * Created by liuzg on 2017/5/18.
 */
public class PrjUtils {

    /**
     * 基因编码
     */
    public static String codeGeneString(int num, int genesize) {
        char[] chs = new char[genesize];
        for (int i = 0; i < genesize; i++) {
            chs[genesize - 1 - i] = (char) (((num >> i) & 1) + '0');
        }
        return new String(chs);
    }

    public static List<Integer> codeBinary(List<Integer> tCcRSWlist, int genesize, int listSize, int chromosomeCount) {
        List<Integer> genelist = new ArrayList<>(chromosomeCount);
        for (int i = 0; i < listSize; i++) {
            String seq = codeGeneString(tCcRSWlist.get(i), genesize);
            for (int j = 0; j < seq.length(); j++) {
                genelist.add((int) seq.charAt(j) - 48);
            }
        }
        return genelist;
    }

    /**
     * 基因解码
     */
    public static int decodeint(List<Integer> seq, int start, int length) {
        int sum = 0;
        for (int i = 0; i < length; i++) {
            int index = length - i - 1;
            sum += seq.get(i + start) * Math.pow(2, index);
        }
        return sum;
    }

    //计算基因长度
    public static int calcCoursegeneticlen(int teacherCoursesetSize) {
        return Integer.toBinaryString(teacherCoursesetSize).length();
    }

    //分解染色体
    public static List<TCcRSw> divideChromosome(List<TCcRSw> tCcRSws, int start, int length) {
        List<TCcRSw> tCcRSwList = new ArrayList<>();
        for (int i = start; i - start < length; i++) {
            tCcRSwList.add(tCcRSws.get(i));
        }
        return tCcRSwList;
    }

    //统计一个列表中重复课程出现的次数
    public static Map<Integer, Integer> CouseCntOneList(List<TCcRSw> data) {

        Map<Integer, Integer> map = new HashMap<Integer, Integer>();//新建一个map集合，用来保存重复的次数
        for (TCcRSw obj : data) {
            if (obj.getTecoId() == 0) continue;
            if (map.containsKey(obj.getTecoId())) {//判断是否已经有该数值，如有，则将次数加1
                map.put(obj.getTecoId(), map.get(obj.getTecoId()).intValue() + 1);
            } else {
                map.put(obj.getTecoId(), 1);
            }
        }
        return map;
    }

    //统计所有课程的学分
    public static Map<Integer, Integer> CouseCntCount(List<TCcRSw> data, TCcRSwIndex tCcRSwIndex) {
        //获取所有课程索引
        Set<Integer> teco = tCcRSwIndex.getTeacherCourseSet();
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();//新建一个map集合，用来保存重复的次数
        for (Integer obj : teco) {
            map.put(obj, 0);
        }
        for (TCcRSw obj : data) {
            if (obj.getTecoId() == 0) continue;
            if (map.containsKey(obj.getTecoId())) {//判断是否已经有该数值，如有，则将次数加1
                map.put(obj.getTecoId(), map.get(obj.getTecoId()).intValue() + 1);
            }
        }
        return map;
    }

    //判断两个列表中课程重复次数
    public static int CourseCntTwoList(List<TCcRSw> list1, List<TCcRSw> list2) {

        List<Integer> list11 = removeDuplicateWithOrder(list1);
        List<Integer> list12 = removeDuplicateWithOrder(list2);

        int cnt = 0;
        for (int i = 0; i < list11.size(); i++) {
            for (int j = 0; j < list12.size(); j++) {
                if (list11.get(i) == list12.get(j) && list11.get(i) != 0)
                    cnt++;
            }
        }
        return cnt;
    }

    //去重列表中的重复值以及0值
    public static List<Integer> removeDuplicateWithOrder(List<TCcRSw> list) {
        Set set = new HashSet();
        List<Integer> newList = new ArrayList<>();
        for (Iterator iter = list.iterator(); iter.hasNext(); ) {
            TCcRSw element = (TCcRSw) iter.next();
            if (set.add(element.getTecoId()))
                newList.add(element.getTecoId());
        }
        return newList;
    }

    //转换为数据库中的真实数据
    public static List<DbTCcRSw> convertToDbTCcRSwData(List<TCcRSw> tCcRSwsList, TCcRSwIndex tCcRSwIndex, int curweek) {
        List<DbTCcRSw> dbresult = new ArrayList<>(tCcRSwsList.size());
        for (TCcRSw item : tCcRSwsList) {
            dbresult.add(convertToDbObj(item, tCcRSwIndex, curweek));
        }
        return dbresult;
    }

    //转变为数据库对象的数据
    public static DbTCcRSw convertToDbObj(TCcRSw tCcRSw, TCcRSwIndex tCcRSwIndex, int curweek) {
        String dbTecoId = "";
        if (tCcRSwIndex.getTeacerCourseByteacherCourse(tCcRSw.getTecoId()) == null) dbTecoId = "";
        else dbTecoId = tCcRSwIndex.getTeacerCourseByteacherCourse(tCcRSw.getTecoId()).getDbTeCoId();
        int isSingleDoubleWeek = 0;
        if (tCcRSwIndex.getTeacerCourseByteacherCourse(tCcRSw.getTecoId()) == null)
            isSingleDoubleWeek = 0;
        else
            isSingleDoubleWeek = tCcRSwIndex.getTeacerCourseByteacherCourse(tCcRSw.getTecoId()).getIsSingleDoubleWeek();
        String room = tCcRSwIndex.getDbRoomIdByRoomId(tCcRSw.getRoomId());
        int section = tCcRSw.getSectionId();
        int weekday = tCcRSw.getWeekDay();
        return new DbTCcRSw(dbTecoId, room, section, weekday, curweek, isSingleDoubleWeek);
    }

}
