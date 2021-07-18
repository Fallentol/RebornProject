/**
 * Created by Alex JR on 7/11/2021.
 */
@isTest
global class AnimalLocatorTest {

    @isTest
    static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        String response = AnimalLocator.getAnimalNameById(2);
        System.assertEquals(response, 'bear');
    }

}