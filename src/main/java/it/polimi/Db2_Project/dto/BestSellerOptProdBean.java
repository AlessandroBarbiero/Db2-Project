package it.polimi.Db2_Project.dto;

public class BestSellerOptProdBean {
    private String optionalProductName;
    private Integer revenue;


    public BestSellerOptProdBean() {
    }

    public BestSellerOptProdBean(String optionalProductName, Integer revenue) {
        this.optionalProductName = optionalProductName;
        this.revenue = revenue;
    }

    public String getOptionalProductName()
    {
        return optionalProductName;
    }

    public void setOptionalProductName(String optionalProductName)
    {
        this.optionalProductName = optionalProductName;
    }

    public Integer getRevenue()
    {
        return revenue;
    }

    public void setRevenue(Integer revenue)
    {
        this.revenue = revenue;
    }
}
