package com.nxlg.algorithm;

import com.nxlg.model.TCcRSw;
import com.nxlg.rules.*;
import com.nxlg.rules.decoder.ITCcRSwChromosomeDecoder;
import com.nxlg.rules.rule.*;
import com.nxlg.utils.PrjUtils;
import org.apache.commons.math3.genetics.AbstractListChromosome;
import org.apache.commons.math3.genetics.BinaryChromosome;
import org.apache.commons.math3.genetics.InvalidRepresentationException;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by NEU on 2017/6/1.
 */
public class TCcRSwChromosome extends BinaryChromosome {

    private List<IRule> rulelist = new ArrayList<>();
    private ITCcRSwChromosomeDecoder chromosomeDecoder;
    private ITCcRSwIndex tCcRSwIndex;
    private int weekdayscount;
    private int daysectioncount;

    public void setRules(List<IRule> rules) {
        this.rulelist = rules;
    }

    public void setChromosomeDecoder(ITCcRSwChromosomeDecoder chromosomeDecoder) {
        this.chromosomeDecoder = chromosomeDecoder;
    }

    public void settCcRSwIndex(ITCcRSwIndex tCcRSwIndex) {
        this.tCcRSwIndex = tCcRSwIndex;
    }

    public void setWeekdayscount(int weekdayscount) {
        this.weekdayscount = weekdayscount;
    }

    public void setDaysectioncount(int daysectioncount) {
        this.daysectioncount = daysectioncount;
    }

    public TCcRSwChromosome(List<Integer> representation) throws InvalidRepresentationException {
        super(representation);
    }

    @Override
    public AbstractListChromosome<Integer> newFixedLengthChromosome(List<Integer> chromosomeRepresentation) {
        TCcRSwChromosome t = new TCcRSwChromosome(chromosomeRepresentation);
        t.setChromosomeDecoder(this.chromosomeDecoder);
        t.settCcRSwIndex(this.tCcRSwIndex);
        t.setRules(this.rulelist);
        t.setWeekdayscount(weekdayscount);
        t.setDaysectioncount(daysectioncount);
        return t;
    }

    //适应度函数
    @Override
    public double fitness() {
        double fitnessvalue = 0;

        List<Integer> seq = this.getRepresentation();
        int roomCnt = tCcRSwIndex.getRoomSize();
        //染色体解码
        List<TCcRSw> tCcRSwsList = chromosomeDecoder.decodeToSection(seq, roomCnt, weekdayscount, daysectioncount, PrjUtils.calcCoursegeneticlen(tCcRSwIndex.getTeachercourseSize()), this.tCcRSwIndex);

        //节规则—每个教室每节
        for (TCcRSw curtCcRSw : tCcRSwsList) {
            for (IRule rule : rulelist) {
                if (rule instanceof TCcRWRule) {
                    TCcRWRule tRule = (TCcRWRule) rule;
                    tRule.setData(curtCcRSw);
                    tRule.settCcRSwIndex(tCcRSwIndex);
                    fitnessvalue += -tRule.calculatePunishValue();
                }
            }
        }
        //天规则—每个教室每天
        for (int dayIndex = 0; dayIndex < roomCnt * weekdayscount; dayIndex++) {
            int index = 0;
            for (IRule rule : rulelist) {
                if (rule instanceof TCcRSRule) {
                    TCcRSRule tRule = (TCcRSRule) rule;
                    tRule.setData(PrjUtils.divideChromosome(tCcRSwsList, index, daysectioncount));
                    tRule.settCcRSwIndex(tCcRSwIndex);
                    fitnessvalue += -tRule.calculatePunishValue();
                }
            }
            index += daysectioncount;
        }

        //教室规则—每个教室
        for (int roomIndex = 0; roomIndex < roomCnt; roomIndex++) {
            int index = 0;
            for (IRule rule : rulelist) {
                if (rule instanceof TCcSWRule) {
                    TCcSWRule tRule = (TCcSWRule) rule;
                    tRule.setData(PrjUtils.divideChromosome(tCcRSwsList, index, daysectioncount * weekdayscount));
                    tRule.settCcRSwIndex(tCcRSwIndex);
                    fitnessvalue += -tRule.calculatePunishValue();

                }
            }
            index += daysectioncount * weekdayscount;
        }

        //全局考虑的规则
        for (IRule rule : rulelist) {
             if (rule instanceof TCcRSWRule) {
                TCcRSWRule tRule = (TCcRSWRule) rule;
                tRule.setData(tCcRSwsList);
                tRule.settCcRSwIndex(tCcRSwIndex);
                fitnessvalue += -tRule.calculatePunishValue();

            }
        }

        return fitnessvalue;
    }

    public List<Integer> getSettings() {
        return this.getRepresentation();
    }

}
