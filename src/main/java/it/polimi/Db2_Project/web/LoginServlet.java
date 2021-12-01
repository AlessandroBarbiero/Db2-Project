package it.polimi.Db2_Project.web;

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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @EJB
    private UserService userService;

    private static final String EMPTY_FIELD_ERROR = "Please fill all the fields";
    private static final String ERROR_STRING = "errorString";
    private static final String INVALID_USERNAME = "The username is already used by another user, please choose another one";
    private static final String INVALID_EMAIL = "The email is already used by another user, please choose another one";
    private static final String INVALID_CREDENTIALS = "Username and password are invalid";
    private static final long serialVersionUID = 1L;

    private HttpSession session;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String errorString;
        session = request.getSession();

        errorString = (String) session.getAttribute(ERROR_STRING);
        if(errorString !=null)
            System.out.println(errorString);
        request.getRequestDispatcher("/UserPages/landing-page.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        session = request.getSession();
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if(username.isEmpty() || password.isEmpty())
        {
            session.setAttribute(ERROR_STRING, EMPTY_FIELD_ERROR);
        }
        else
        {
            session.removeAttribute(ERROR_STRING);
            Optional<UserEntity> user = userService.checkCredentials(username, password);
            if(!user.isPresent())
                session.setAttribute(ERROR_STRING, INVALID_CREDENTIALS);

            else
                // for saving the user id in the session when we change page
                session.setAttribute("ID", user.get().getId());

        }
        response.sendRedirect("registration");
    }

}
