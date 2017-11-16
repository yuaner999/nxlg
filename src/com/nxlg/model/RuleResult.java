package com.nxlg.model;

/**
 * Created by NEU on 2017/6/9.
 * 规则结果
 */
public class RuleResult {

    private int count;
    private String classname;
    private double punishvalue;
    private double calcPunishValue;

    public RuleResult() {
    }

    public RuleResult(String classname, int count, double punishvalue, double calcPunishValue) {
        this.count = count;
        this.classname = classname;
        this.punishvalue = punishvalue;
        this.calcPunishValue = calcPunishValue;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getClassname() {
        return classname;
    }

    public void setClassname(String classname) {
        this.classname = classname;
    }

    public double getPunishvalue() {
        return punishvalue;
    }

    public void setPunishvalue(double punishvalue) {
        this.punishvalue = punishvalue;
    }

    public double getCalcPunishValue() {
        return calcPunishValue;
    }

    public void setCalcPunishValue(double calcPunishValue) {
        this.calcPunishValue = calcPunishValue;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        RuleResult that = (RuleResult) o;

        if (count != that.count) return false;
        if (Double.compare(that.punishvalue, punishvalue) != 0) return false;
        if (Double.compare(that.calcPunishValue, calcPunishValue) != 0) return false;
        return classname != null ? classname.equals(that.classname) : that.classname == null;

    }

    @Override
    public int hashCode() {
        int result;
        long temp;
        result = count;
        result = 31 * result + (classname != null ? classname.hashCode() : 0);
        temp = Double.doubleToLongBits(punishvalue);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        temp = Double.doubleToLongBits(calcPunishValue);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        return result;
    }

    @Override
    public String toString() {
        return "RuleResult{" +
                "count=" + count +
                ", classname='" + classname + '\'' +
                ", punishvalue=" + punishvalue +
                ", calcPunishValue=" + calcPunishValue +
                '}';
    }
}
