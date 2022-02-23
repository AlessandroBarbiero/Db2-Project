package it.polimi.Db2_Project.services;
import it.polimi.Db2_Project.dto.AverageBean;
import it.polimi.Db2_Project.dto.BestSellerOptProdBean;
import it.polimi.Db2_Project.dto.PurchasesBean;
import it.polimi.Db2_Project.dto.SalesBean;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@Stateless
public class ViewService {

    @PersistenceContext
    private EntityManager em;


    @SuppressWarnings("unchecked")
    public List<PurchasesBean> totalPurchasesPerPackage(){

        String sql = "SELECT s.name as servicePackageName, p.totalPurchases as totalPurchases " +
                "FROM purchases_per_package p, service_package s " +
                "WHERE p.servicePackageId = s.id";

        return em.createNativeQuery(sql, PurchasesBean.class).getResultList();
    }

    @SuppressWarnings("unchecked")
    public List<PurchasesBean> totalPurchasesPerPackageAndVP(){
        String sql = "SELECT s.name as servicePackageName, vp.numberOfMonths as numberOfMonths, vp.monthlyFee as monthlyFee, p.totalPurchases as totalPurchases " +
                "FROM purchases_per_package_and_vp p, service_package s , validity_period vp " +
                "WHERE p.servicePackageId = s.id AND p.validityPeriodId = vp.id ";

        return  em.createNativeQuery(sql, PurchasesBean.class).getResultList();
    }

    @SuppressWarnings("unchecked")
    public List<AverageBean> avgOptProdPerPackage(){
        String sql = "SELECT s.name as servicePackageName, aop.avg " +
                "FROM average_number_opt_products_per_package aop, service_package s " +
                "WHERE aop.servicePackageId = s.id";

        return  em.createNativeQuery(sql, AverageBean.class).getResultList();
    }


    @SuppressWarnings("unchecked")
    public List<BestSellerOptProdBean> bestSellerOptProduct(){
        String sql = "SELECT op.name as optionalProductName, bsop.revenue " +
                "FROM best_seller_opt_prod bsop, optional_product op " +
                "WHERE bsop.optionalProductId = op.id " +
                "ORDER BY revenue desc " +
                "LIMIT 1";

        return  em.createNativeQuery(sql, BestSellerOptProdBean.class).getResultList();
    }

    @SuppressWarnings("unchecked")
    public List<SalesBean> salesPerPackage(){
        String sql = "SELECT sp.name as servicePackageName, s.revenueWithOpProd, s.revenueWithoutOpProd " +
                "FROM sales_per_package s, service_package sp " +
                "WHERE sp.id = s.servicePackageId";

        return  em.createNativeQuery(sql, SalesBean.class).getResultList();
    }
}
