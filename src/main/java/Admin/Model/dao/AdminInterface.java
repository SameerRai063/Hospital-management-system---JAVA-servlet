package Admin.Model.dao;

import Admin.Model.Admin;
import java.util.List;

public interface AdminInterface {
    List<Admin> getAllAdmins() throws Exception;
    Admin getAdminById(int userId) throws Exception;
    boolean addAdmin(Admin admin) throws Exception;
    boolean deleteAdmin(int userId) throws Exception;
    int getTotalAdmins() throws Exception;
}

