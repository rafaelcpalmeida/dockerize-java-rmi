package edu.ufp.inf.sd.rmi.util.rmisetup;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author rui
 */
public class SetupContextRMI {

    private Registry registry;
    private InetAddress localHostInetAddress;
    private String localHostName;
    private String localHostAddress;

    private final Class subsystemClass;
    private final String registryHostIP;
    private final int registryHostPort;
    private final String serviceNames[];
    private final String serviceUrls[];
    private final Logger logger;

    /**
     *
     * @param subsystemClass
     * @param registryHostIP
     * @param registryHostPort
     * @param serviceNames
     * @throws java.rmi.RemoteException
     */
    public SetupContextRMI(Class subsystemClass, String registryHostIP, String registryHostPort, String serviceNames[]) throws RemoteException {
        this.logger = Logger.getLogger(subsystemClass.getName());

        logger.log(Level.INFO, "setup context for {0}", subsystemClass.getName());
        this.subsystemClass = subsystemClass;

        logger.log(Level.INFO, "serviceNames.length = {0}", serviceNames.length);
        this.serviceNames = new String[serviceNames.length];
        System.arraycopy(serviceNames, 0, this.serviceNames, 0, serviceNames.length);
        for (int i = 0; i < serviceNames.length; i++) {
            logger.log(Level.INFO, "serviceNames[{0}] = {1}", new Object[]{i, serviceNames[i]});
        }

        //1. Set network context
        getLocalHostInetAddress();

        if ((registryHostIP != null && registryHostPort != null)) {
            this.registryHostIP = registryHostIP;
            this.registryHostPort = Integer.parseInt(registryHostPort);
        } else {
            this.registryHostIP = this.localHostAddress;
            this.registryHostPort = 1099;
        }

        this.serviceUrls = new String[this.serviceNames.length];
        logger.log(Level.INFO, "serviceUrls.length = {0}", this.serviceUrls.length);
        for (int i = 0; i < this.serviceUrls.length; i++) {
            serviceUrls[i] = "rmi://" + this.registryHostIP + ":" + this.registryHostPort + "/" + this.serviceNames[i];
            logger.log(Level.INFO, "serviceUrls[{0}] = {1}", new Object[]{i, serviceUrls[i]});
        }

        //2. Set security context
        setupSecurityManager();

        //3. Set and list registry context
        setupRegistryContext(registryHostIP, registryHostIP);
    }

    public String getServicesUrl(int i) {
        return (i < this.serviceUrls.length ? serviceUrls[i] : null);
    }

    /**
     * Create a basic network context for RMI
     */
    private void getLocalHostInetAddress() {
        try {
            localHostInetAddress = InetAddress.getLocalHost();
            localHostName = localHostInetAddress.getHostName();
            localHostAddress = localHostInetAddress.getHostAddress();

            logger.log(Level.INFO, "localHostName = {0}", new Object[]{localHostName});
            logger.log(Level.INFO, "localHostAddress = {0}", new Object[]{localHostAddress});
            
            InetAddress[] allLocalInetAddresses = InetAddress.getAllByName(localHostName);
            for (InetAddress addr : allLocalInetAddresses) {
                logger.log(Level.INFO, "addr = {0}", new Object[]{addr});
            }
        } catch (UnknownHostException e) {
            //Logger.getLogger(this.getClass().getName()).log(Level.SEVERE, null, e);
            logger.log(Level.SEVERE, "exception {0}", new Object[]{e});
        }
    }

    /**
     * Returns current rmiregistry proxy
     *
     * @return
     */
    public Registry getRegistry() {
        return this.registry;
    }

    /**
     * Create and install a security manager
     *
     */
    private void setupSecurityManager() {
        if (System.getSecurityManager() == null) {
            logger.log(Level.INFO, "set security manager for {0}", subsystemClass.getName());
            System.setSecurityManager(new SecurityManager());
        }
    }

    /**
     * Setup reference for rmiregistry and list available services
     *
     * @param registryHostIP
     * @param registryHostPort
     * @return Registry
     * @throws java.rmi.RemoteException
     */
    private void setupRegistryContext(String registryHostIP, String registryHostPort) throws RemoteException {

        //Get proxy to rmiregistry
        registry = LocateRegistry.getRegistry(this.registryHostIP, this.registryHostPort);
        if (registry != null) {
            //List available services
            String[] registriesList = registry.list();
            logger.log(Level.INFO, "registriesList.length = {0}", new Object[]{registriesList.length});

            for (int i = 0; i < registriesList.length; i++) {
                logger.log(Level.INFO, "registriesList[{0}] = {1}", new Object[]{i, registriesList[i]});
            }
        } else {
            logger.log(Level.INFO, "reference to registry is null!!");
            //registry = LocateRegistry.createRegistry(1099);
        }
        //return registry;
    }

    public static void printArgs(String classname, String args[]) {
        for (int i = 0; args != null && i < args.length; i++) {
            //String t = Thread.currentThread().getName();
            //Logger.getLogger(this.getClass().getName()).log(Level.INFO, "args[{0}] = {1}", new Object[]{i, args[i]});
            Logger.getLogger(classname).log(Level.INFO, "args[{0}] = {1}", new Object[]{i, args[i]});
        }
    }
}
