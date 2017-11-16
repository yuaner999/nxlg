package com.nxlg.algorithm;

import com.nxlg.model.DbTCcRSw;
import com.nxlg.model.TCcRSw;
import com.nxlg.rules.ITCcRSwIndex;
import com.nxlg.rules.decoder.ITCcRSwChromosomeDecoder;
import com.nxlg.rules.rule.IRule;
import com.nxlg.utils.PrjUtils;
import org.apache.commons.math3.genetics.*;

import java.util.*;

/**
 * Created by NEU on 2017/6/1.
 */
public class CourseArrangementAlgorithm {

    //遗传算法初始变量
    private double crossoverRate = 1;
    private double mutationRate = 0.10;
    private int selectionPolicy = 21;
    private int num_generation = 600;

    private int daySectionCount = 6;
    private int weekdaycount = 6;

    private int populationLimit = 100;
    private double elitismRate = 0.1;
    private int chromosomeCount;

    private List<IRule> rules;      //规则
    private ITCcRSwChromosomeDecoder chromosomDecoder;    //染色体解码
    private ITCcRSwIndex tCcRSwIndex;
    private List<DbTCcRSw> dbTCcRSws;   //已排好的课程表

    private int curweek;    //当前周

    public void setRules(List<IRule> rules) {
        this.rules = rules;
    }

    public void setChromosomDecoder(ITCcRSwChromosomeDecoder chromosomDecoder) {
        this.chromosomDecoder = chromosomDecoder;
    }

    public void settCcRSwIndex(ITCcRSwIndex tCcRSwIndex) {
        this.tCcRSwIndex = tCcRSwIndex;
    }

    public List<DbTCcRSw> getDbTCcRSws() {
        return dbTCcRSws;
    }

    public void setDbTCcRSws(List<DbTCcRSw> dbTCcRSws) {
        this.dbTCcRSws = dbTCcRSws;
    }

    public int getCurweek() {
        return curweek;
    }

    public void setCurweek(int curweek) {
        this.curweek = curweek;
    }

    public void setDaySectionCount(int daySectionCount) {
        this.daySectionCount = daySectionCount;
    }

    public void setWeekdaycount(int weekdaycount) {
        this.weekdaycount = weekdaycount;
    }

    public void setCrossoverRate(double crossoverRate) {
        this.crossoverRate = crossoverRate;
    }

    public void setMutationRate(double mutationRate) {
        this.mutationRate = mutationRate;
    }

    public void setSelectionPolicy(int selectionPolicy) {
        this.selectionPolicy = selectionPolicy;
    }

    public void setNum_generation(int num_generation) {
        this.num_generation = num_generation;
    }

    public void setPopulationLimit(int populationLimit) {
        this.populationLimit = populationLimit;
    }

    public void setElitismRate(double elitismRate) {
        this.elitismRate = elitismRate;
    }

    //计算染色体长度
    public void calcChromosomeCount() {
        //基因长度
        int codelen = Integer.toBinaryString(tCcRSwIndex.getTeachercourseSize()).length();
        this.chromosomeCount = tCcRSwIndex.getRoomSize() * this.weekdaycount * this.daySectionCount * codelen;
    }

    public CourseArrangementAlgorithm() {
    }

    public CourseArrangementAlgorithm(double elitismRate, int populationLimit, int weekdaycount, int daySectionCount, int num_generation, int selectionPolicy, double mutationRate, double crossoverRate) {
        this.elitismRate = elitismRate;
        this.populationLimit = populationLimit;
        this.weekdaycount = weekdaycount;
        this.daySectionCount = daySectionCount;
        this.num_generation = num_generation;
        this.selectionPolicy = selectionPolicy;
        this.mutationRate = mutationRate;
        this.crossoverRate = crossoverRate;
    }

    //安排课程
    public List<TCcRSw> arrangeCourse() {
        calcChromosomeCount();
        //调用遗传算法
        GeneticAlgorithm ga = new GeneticAlgorithm(
                new OnePointCrossover<Integer>(),
                this.crossoverRate,
                new BinaryMutation(),
                this.mutationRate,
                new TournamentSelection(this.selectionPolicy)
        );

        // initial population
        Population initial = getInitialPopulation();
        if(initial == null) return null;

        // stopping condition
        StoppingCondition stopCond = new FixedGenerationCount(this.num_generation);

        // run the algorithm
        Population finalPopulation = ga.evolve(initial, stopCond);

        // best chromosome from the final population
        TCcRSwChromosome bestFinal = (TCcRSwChromosome) finalPopulation.getFittestChromosome();
        System.out.println(bestFinal);
        bestFinal.fitness();
        List<Integer> chromesomedata = bestFinal.getSettings();

        int roomCnt = tCcRSwIndex.getRoomSize();
        //染色体解码
        List<TCcRSw> tCcRSwsList = chromosomDecoder.decodeToSection(chromesomedata, roomCnt, weekdaycount, daySectionCount, PrjUtils.calcCoursegeneticlen(tCcRSwIndex.getTeachercourseSize()), this.tCcRSwIndex);
        return tCcRSwsList;

    }

    //初始化种群
    private Population getInitialPopulation() {
        List<Chromosome> chromosomes = new ArrayList<>();

        for (int i = 0; i < this.populationLimit; i++) {

            //基因长度
            int codelen = Integer.toBinaryString(tCcRSwIndex.getTeachercourseSize()).length();

            List<Integer> tcList = new ArrayList<>();
            for (int tcIndex : tCcRSwIndex.getTeacherCourseSet()) {
                tcList.add(tcIndex);
            }
            //改进
            int roomSize = tCcRSwIndex.getRoomSize();
            int listSize = roomSize * weekdaycount * daySectionCount;
            List<Integer> tCcRSwlist = new ArrayList<Integer>(Collections.nCopies(listSize, 0));

            for (int tcIndex = 0; tcIndex < tcList.size(); tcIndex++) {
                int tcId = tcList.get(tcIndex);
                int weekhours = tCcRSwIndex.getTeacerCourseByteacherCourse(tcId).getWeekhours();
                String roomtype = tCcRSwIndex.getTeacerCourseByteacherCourse(tcId).getRoomType();
                int stunum = tCcRSwIndex.getTeacerCourseByteacherCourse(tcId).getDbstuNum();
                String teacher = tCcRSwIndex.getTeacerCourseByteacherCourse(tcId).getDbTeacherId();

                int cnt = weekhours % 2 == 0 ? weekhours / 2 : (weekhours + 1) / 2;
                for (int k = 0; k < cnt; k++) {
                    int roomNum = randomAssignRoom(roomtype, stunum, tCcRSwlist, teacher, tcId);
                    if(roomNum == -101) return null;
                    tCcRSwlist.set(roomNum, tcId);
                }
            }
            //编码
            List<Integer> temp = PrjUtils.codeBinary(tCcRSwlist, codelen, listSize, this.chromosomeCount);

            /**编码解码测试*/
            //解码
            List<TCcRSw> tCcRSwsList = chromosomDecoder.decodeToSection(temp, roomSize, weekdaycount, daySectionCount, PrjUtils.calcCoursegeneticlen(tCcRSwIndex.getTeachercourseSize()), this.tCcRSwIndex);
            List<Integer> list = new ArrayList<>();
            for (int k = 0; k < tCcRSwsList.size(); k++) {
                list.add(tCcRSwsList.get(k).getTecoId());
            }
            List<Integer> temp2 = PrjUtils.codeBinary(list, codelen, listSize, this.chromosomeCount);
            boolean flag = Objects.equals(temp,temp2);

            TCcRSwChromosome chromosome = new TCcRSwChromosome(temp);
            chromosome.setRules(this.rules);
            chromosome.setChromosomeDecoder(chromosomDecoder);
            chromosome.settCcRSwIndex(tCcRSwIndex);
            chromosome.setWeekdayscount(this.weekdaycount);
            chromosome.setDaysectioncount(this.daySectionCount);
            chromosomes.add(chromosome);
        }

        Population ret = new ElitisticListPopulation(chromosomes, populationLimit, elitismRate);
        return ret;
    }

    //随机分配教室
    public int randomAssignRoom(String roomtype, int stunum, List<Integer> rSwlist, String teacher, int tcId) {
        List<Integer> candidateRoomList = new ArrayList<>();
        //候选教室列表
        for (int i = 0; i < rSwlist.size(); i++) {
            int roomIndex = i / (weekdaycount * daySectionCount) + 1;
            //判断教室是否被占用
            if (curweek == 1) {
                if (rSwlist.get(i) != 0) continue;
            } else {
                if (IsRoomUsed(dbTCcRSws, i)) continue;
                else if (rSwlist.get(i) != 0) continue;
            }

            String type = tCcRSwIndex.getRoomByRoomId(roomIndex).getRoomType();
            int campacity = tCcRSwIndex.getRoomByRoomId(roomIndex).getRoomCapacity();
            if (Objects.equals(type, roomtype) && campacity >= stunum) {
                candidateRoomList.add(i);
                int section = (i % (weekdaycount * daySectionCount)) % weekdaycount;
                //判断教师冲突
                if (IsSamesectionOneTeacher(rSwlist, teacher, section, tcId)) continue;
                else return i;
            }
        }
        if (candidateRoomList.size() == 0) {
            for (int i = 0; i < rSwlist.size(); i++) {
                if (rSwlist.get(i) == 0) return i;
            }
        }
        if (candidateRoomList.size() == 0) return -101;  //错误提示信息：教室资源不足，请减少教学计划中需要安排的课程
        return candidateRoomList.get(0);
    }

    public boolean IsSamesectionOneTeacher(List<Integer> data, String teacher, int section, int tcId) {
        //获取节次课程表
        for (int j = 0; j < tCcRSwIndex.getRoomSize(); j++) {
            int tc = data.get(j * daySectionCount * weekdaycount + section);
            if (tc == 0 || tc == tcId) continue;
            String teacherId = tCcRSwIndex.getTeacerCourseByteacherCourse(tc).getDbTeacherId();
            if (Objects.equals(teacher, teacherId)) return true;
        }
        return false;
    }

    public boolean IsRoomUsed(List<DbTCcRSw> lastweekdata, int index) {
        //当前为第一周课程，此规则无惩罚
        if (lastweekdata.size() == 0) return false;
        DbTCcRSw lastTCcRSw = lastweekdata.get(index);
        if (lastTCcRSw.getDbTeCoId() == "" || lastTCcRSw.getDbTeCoId() == null) {  //上周本节课未安排课程
            return false;
        } else {
            int isSingleDoubleWeek = lastTCcRSw.getIsSingleDoubleWeek();
            if (isSingleDoubleWeek == 0) return true;      //判断是否是非单双周
            return false;
        }
//        return false;
    }

   /* //随机分配教室
    public int randomAssignRoom(int roomSize, String roomtype, int stunum, List<Integer> tCcRSwlist) {
        int roomNum = new Random().nextInt(roomSize * weekdaycount * daySectionCount);
        int roomIndex = roomNum / (weekdaycount * daySectionCount) + 1;

        if (Objects.equals(tCcRSwIndex.getRoomByRoomId(roomIndex).getRoomType(), roomtype) && tCcRSwIndex.getRoomByRoomId(roomIndex).getRoomCapacity() >= stunum) {
            if (tCcRSwlist.get(roomNum) == 0) return roomNum;
            else {
                roomNum = randomAssignRoom(roomSize, roomtype, stunum, tCcRSwlist);
            }
        }
        return roomNum;
    }*/
}
