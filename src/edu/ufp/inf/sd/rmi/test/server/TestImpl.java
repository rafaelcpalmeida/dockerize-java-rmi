package edu.ufp.inf.sd.rmi.test.server;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.logging.Level;
import java.util.logging.Logger;


public class TestImpl extends UnicastRemoteObject implements TestRI {


    public TestImpl() throws RemoteException {
        super();
    }

    @Override
    public String methodName() throws RemoteException {
        System.out.println("someone call me!");
        return "someone called me!";
    }
}