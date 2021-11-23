package it.polimi.Db2_Project.exceptions;

public class WrongConfigurationException extends RuntimeException{

    public WrongConfigurationException() {
    }

    public WrongConfigurationException(String message) {
        super(message);
    }
}
