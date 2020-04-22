package edu.ufp.inf.sd.rmi.test.server;

import java.rmi.Remote;
import java.rmi.RemoteException;


public interface TestRI extends Remote {
    String methodName() throws RemoteException;
}