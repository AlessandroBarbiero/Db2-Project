package it.polimi.Db2_Project.web.user;

import it.polimi.Db2_Project.entities.UserEntity;
import it.polimi.Db2_Project.services.UserService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "loginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    @EJB
    private UserService userService;

    private static final String EMPTY_FIELD_ERROR = "Please fill all the fields";
    private static final String ERROR_STRING = "errorString";
    private static final String INVALID_CREDENTIALS = "Username and password are invalid";
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.getRequestDispatcher("/UserPages/landing-page.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        HttpSession session = request.getSession();
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if(username.isEmpty() || password.isEmpty()) {
            session.setAttribute(ERROR_STRING, EMPTY_FIELD_ERROR);
        }
        else {
            Optional<UserEntity> user = userService.checkCredentials(username, password);
            if(!user.isPresent())
                session.setAttribute(ERROR_STRING, INVALID_CREDENTIALS);

            else {
                // saves the user in the session when the page is changed
                session.setAttribute("user", user.get());
                if(session.getAttribute("pendingOrder") == null)
                    response.sendRedirect("home-user");
                else
                    response.sendRedirect("confirmation");
                return;
            }
        }
        response.sendRedirect("login?success=false");
    }

}
