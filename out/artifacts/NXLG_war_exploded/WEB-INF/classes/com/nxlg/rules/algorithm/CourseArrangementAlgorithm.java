package com.nxlg.algorithm;

import com.nxlg.model.DbTCcRSw;
import com.nxlg.model.TCcRSw;
import com.nxlg.rules.ITCcRSwIndex;
import com.nxlg.rules.decoder.ITCcRSwChromosomeDecoder;
import com.nxlg.rules.rule.IRule;
import com.nxlg.utils.PrjUtils;
import org.apache.commons.math3.genetics.*;

import java.util.ArrayList;
import java.util.List;

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

    public void setRules(List<IRule> rules) {
        this.rules = rules;
    }

    public void setChromosomDecoder(ITCcRSwChromosomeDecoder chromosomDecoder) {
        this.chromosomDecoder = chromosomDecoder;
    }

    public void settCcRSwIndex(ITCcRSwIndex tCcRSwIndex) {
        this.tCcRSwIndex = tCcRSwIndex;
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

    private Population getInitialPopulation() {
        List<Chromosome> chromosomes = new ArrayList<>();

        for (int i = 0; i < this.populationLimit; i++) {
            List<Integer> temp = new ArrayList<>(this.chromosomeCount);
            for (int j = 0; j < this.chromosomeCount; j++) {
                temp.add(Math.random() < 0.5 ? 1 : 0);
            }
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

    //转变为数据库对象的数据
    private DbTCcRSw convertToDbObj(TCcRSw tCcRSw) {
        String dbTecoId = "";
        if(tCcRSwIndex.getTeacerCourseByteacherCourse(tCcRSw.getTecoId()) == null) dbTecoId = "";
        else dbTecoId = tCcRSwIndex.getTeacerCourseByteacherCourse(tCcRSw.getTecoId()).getDbTeCoId();

        return new DbTCcRSw(
                dbTecoId,
                tCcRSwIndex.getDbClassIdByClassId(tCcRSw.getClassId()),
                tCcRSwIndex.getDbRoomIdByRoomId(tCcRSw.getRoomId()),
                tCcRSw.getSectionId(),
                tCcRSw.getWeekDay()
        );
    }

}
