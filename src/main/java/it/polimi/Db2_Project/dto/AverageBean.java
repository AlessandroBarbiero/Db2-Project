package it.polimi.Db2_Project.dto;

public class AverageBean {
    private String servicePackageName;
    private Float avg;

    public AverageBean() {
    }

    public AverageBean(String servicePackageName, Float avg) {
        this.servicePackageName = servicePackageName;
        this.avg = avg;
    }


    public String getServicePackageName()
    {
        return servicePackageName;
    }

    public void setServicePackageName(String servicePackageName)
    {
        this.servicePackageName = servicePackageName;
    }

    public Float getAvg()
    {
        return avg;
    }

    public void setAvg(Float avg)
    {
        this.avg = avg;
    }
}
