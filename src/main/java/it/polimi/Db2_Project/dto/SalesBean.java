package it.polimi.Db2_Project.dto;

public class SalesBean {
    private String servicePackageName;
    private Integer revenueWithOpProd;
    private Integer revenueWithoutOpProd;

    public SalesBean(){

    }

    public SalesBean(String servicePackageName, Integer revenueWithOpProd, Integer revenueWithoutOpProd)
    {
        this.servicePackageName = servicePackageName;
        this.revenueWithOpProd = revenueWithOpProd;
        this.revenueWithoutOpProd = revenueWithoutOpProd;
    }

    public String getServicePackageName()
    {
        return servicePackageName;
    }

    public void setServicePackageName(String servicePackageName)
    {
        this.servicePackageName = servicePackageName;
    }

    public Integer getRevenueWithOpProd()
    {
        return revenueWithOpProd;
    }

    public void setRevenueWithOpProd(Integer revenueWithOpProd)
    {
        this.revenueWithOpProd = revenueWithOpProd;
    }

    public Integer getRevenueWithoutOpProd()
    {
        return revenueWithoutOpProd;
    }

    public void setRevenueWithoutOpProd(Integer revenueWithoutOpProd)
    {
        this.revenueWithoutOpProd = revenueWithoutOpProd;
    }
}

