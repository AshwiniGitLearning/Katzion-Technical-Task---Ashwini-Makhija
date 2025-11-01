@isTest
public class HttpMockResponseGenerator implements HttpCalloutMock{
	public HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('POST', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Records Status":"Records Created Successfully"}');
        res.setStatusCode(200);
        return res;
    }
}