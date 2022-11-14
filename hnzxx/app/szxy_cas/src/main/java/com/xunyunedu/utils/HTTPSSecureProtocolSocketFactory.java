package com.xunyunedu.utils;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.UnknownHostException;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.SocketFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpConnectionParams;
import org.apache.commons.httpclient.protocol.Protocol;
import org.apache.commons.httpclient.protocol.ProtocolSocketFactory;
import org.apache.http.conn.ConnectTimeoutException;


/** 
 * httpclient https 
 * 
 */  
public class HTTPSSecureProtocolSocketFactory implements ProtocolSocketFactory {//SecureProtocolSocketFactory  
    private SSLContext sslcontext = null;  

    private SSLContext createSSLContext() {  
        SSLContext sslcontext = null;  
        try {  
            sslcontext = SSLContext.getInstance("SSL");  
            sslcontext.init(null,  
                    new TrustManager[] { new TrustAnyTrustManager() },  
                    new java.security.SecureRandom());  
        } catch (NoSuchAlgorithmException e) {  
            e.printStackTrace();  
        } catch (KeyManagementException e) {  
            e.printStackTrace();  
        }  
        return sslcontext;  
    }  

    private SSLContext getSSLContext() {  
        if (null == this.sslcontext) {  
            this.sslcontext = createSSLContext();  
        }  
        return this.sslcontext;  
    }  

    public Socket createSocket(Socket socket, String host, int port,  
            boolean autoClose) throws IOException, UnknownHostException {  
        return getSSLContext().getSocketFactory().createSocket(socket, host,  
                port, autoClose);  
    }  

    public Socket createSocket(String host, int port) throws IOException,  
            UnknownHostException {  
        return getSSLContext().getSocketFactory().createSocket(host, port);  
    }  

    public Socket createSocket(String host, int port, InetAddress clientHost,  
            int clientPort) throws IOException, UnknownHostException {  
        return getSSLContext().getSocketFactory().createSocket(host, port,  
                clientHost, clientPort);  
    }  

    public Socket createSocket(String host, int port, InetAddress localAddress,  
            int localPort, HttpConnectionParams params) throws IOException,  
            UnknownHostException, ConnectTimeoutException {  
        if (params == null) {  
            throw new IllegalArgumentException("Parameters may not be null");  
        }  
        int timeout = params.getConnectionTimeout();  
        SocketFactory socketfactory = getSSLContext().getSocketFactory();  
        if (timeout == 0) {  
            return socketfactory.createSocket(host, port, localAddress,  
                    localPort);  
        } else {  
            Socket socket = socketfactory.createSocket();  
            SocketAddress localaddr = new InetSocketAddress(localAddress,  
                    localPort);  
            SocketAddress remoteaddr = new InetSocketAddress(host, port);  
            socket.bind(localaddr);  
            socket.connect(remoteaddr, timeout);  
            return socket;  
        }  
    }  

    private static class TrustAnyTrustManager implements X509TrustManager {  
        public void checkClientTrusted(X509Certificate[] chain, String authType)  
                throws CertificateException {  
        }  

        public void checkServerTrusted(X509Certificate[] chain, String authType)  
                throws CertificateException {  
        }  

        public X509Certificate[] getAcceptedIssuers() {  
            return new X509Certificate[] {};  
        }  
    }  
    
    public static String postByHttps(String url, String body, String contentType) {
        String result = "";
        Protocol https = new Protocol("https", new HTTPSSecureProtocolSocketFactory(), 443);
        Protocol.registerProtocol("https", https);
        PostMethod post = new PostMethod(url);
        HttpClient client = new HttpClient();
        try {
            post.setRequestHeader("Content-Type", contentType);
            post.setRequestBody(body);
            client.executeMethod(post);
            result = post.getResponseBodyAsString();
            Protocol.unregisterProtocol("https");
            return result;
        } catch (HttpException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch(Exception e) {
            e.printStackTrace();
        }

        return "error";
    }

}