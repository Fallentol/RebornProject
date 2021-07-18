/**
 * Created by Alex JR on 7/11/2021.
 */

public with sharing class ParkLocator {

    public static String[] country(String countyName) { 
        ParkService.ParksImplPort parksImplPort = new ParkService.ParksImplPort();
        String[] response = parksImplPort.byCountry(countyName);
        System.debug('response = ' + response);
        return response;
    }
}