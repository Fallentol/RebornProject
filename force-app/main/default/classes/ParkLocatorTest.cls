/**
 * Created by Alex JR on 7/11/2021.
 */
@isTest
public with sharing class ParkLocatorTest {

    @isTest static void testCallout() {
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        List<String> result = ParkLocator.country('India');
        System.assertEquals('Anamudi Shola National Park', result[0]);
    }

}