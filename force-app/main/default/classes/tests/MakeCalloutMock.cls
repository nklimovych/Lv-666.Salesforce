/**
 * Creating external service callout mock
 */
@isTest
global class MakeCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json'); 
        /**   
         * Getting JSON format of hardcoded response
        */
        StaticResource resource = [SELECT body FROM StaticResource WHERE Name = 'GetLocationCoordinate'];
        response.setBody(resource.body.toString());
        response.setStatusCode(200);
        return response;
    }
}
