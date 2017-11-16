package com.nxlg.utils;

import com.nxlg.model.TCcRSw;

import java.util.*;

/**
 * Created by liuzg on 2017/5/18.
 */
public class PrjUtils {

    public static int decodeint(List<Integer> seq, int start, int length) {
        int sum = 0;
        for (int i = start; i < seq.size() && i - start < length; i++) {
            int index = i - start;
            sum += seq.get(i) * Math.pow(2, index);
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
            if(obj.getTecoId() == 0) continue;
            if (map.containsKey(obj.getTecoId())) {//判断是否已经有该数值，如有，则将次数加1
                map.put(obj.getTecoId(), map.get(obj.getTecoId()).intValue() + 1);
            } else {
                map.put(obj.getTecoId(), 1);
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


}
