/**
 * Created by Alex JR on 7/11/2021.
 */

public with sharing class AnimalLocator {

    public static String getAnimalNameById(Integer idx) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + idx);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug(response);
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Map<String, Object> animal = (Map<String, Object>) result.get('animal');
        return (String) animal.get('name');
    }

}