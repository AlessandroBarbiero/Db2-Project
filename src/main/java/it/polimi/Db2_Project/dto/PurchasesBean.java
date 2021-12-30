package it.polimi.Db2_Project.dto;

public class PurchasesBean {
    private String servicePackageName;
    private Integer numberOfMonths;
    private Float monthlyFee;
    private Integer totalPurchases;

    public PurchasesBean() {
    }

    public PurchasesBean(String servicePackageName, Integer totalPurchases) {
        this.servicePackageName = servicePackageName;
        this.totalPurchases = totalPurchases;
    }

    public PurchasesBean(String servicePackageName, Integer numberOfMonths, Float monthlyFee, Integer totalPurchases) {
        this.servicePackageName = servicePackageName;
        this.numberOfMonths = numberOfMonths;
        this.monthlyFee = monthlyFee;
        this.totalPurchases = totalPurchases;
    }

    public String getServicePackageName() {
        return servicePackageName;
    }

    public void setServicePackageName(String servicePackageName) {
        this.servicePackageName = servicePackageName;
    }

    public Integer getNumberOfMonths() {
        return numberOfMonths;
    }

    public void setNumberOfMonths(Integer numberOfMonths) {
        this.numberOfMonths = numberOfMonths;
    }

    public Float getMonthlyFee() {
        return monthlyFee;
    }

    public void setMonthlyFee(Float monthlyFee) {
        this.monthlyFee = monthlyFee;
    }

    public Integer getTotalPurchases() {
        return totalPurchases;
    }

    public void setTotalPurchases(Integer totalPurchases) {
        this.totalPurchases = totalPurchases;
    }
}
