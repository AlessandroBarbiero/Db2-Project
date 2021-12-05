package it.polimi.Db2_Project.web.user;

import it.polimi.Db2_Project.services.UserService;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "registrationServlet", value = "/registration")
public class RegistrationServlet extends HttpServlet {

    @EJB
    private UserService userService;

    private static final String EMPTY_FIELD_ERROR = "Please fill all the fields";
    private static final String ERROR_STRING = "errorString";
    private static final String INVALID_USERNAME = "The username is already used by another user, please choose another one";
    private static final String INVALID_EMAIL = "The email is already used by another user, please choose another one";
    private static final long serialVersionUID = 1L;

    public static String getErrorString() {
        return ERROR_STRING;
    }

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
        String email = request.getParameter("email");

        if(username.isEmpty() || password.isEmpty() || email.isEmpty())
        {
            session.setAttribute(ERROR_STRING, EMPTY_FIELD_ERROR);
        }
        else
        {
            if(userService.findUserByUsername(username).isPresent())
                session.setAttribute(ERROR_STRING, INVALID_USERNAME);
            else if(userService.findUserByEmail(email).isPresent())
                session.setAttribute(ERROR_STRING, INVALID_EMAIL);
            else
                userService.createUser(username,password,email);

        }
        response.sendRedirect("registration");
    }

}


