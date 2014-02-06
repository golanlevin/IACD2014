// This Processing 2.1 program extracts your FuelBand data from api.nike.com (as of 6 Feb 2014).
// To do this, you need a Nike developer Access Token, and your Device ID. 
// https://developer.nike.com/console -- gives you the Access Token
// But your ID must be retrieved using e.g. "Charles", an HTTP sniffer. See:
// https://gist.github.com/NorthIsUp/3949465
// http://www.charlesproxy.com/download/

// By Wes Grubbs, June 2013
// Revised by Golan Levin, February 2014

import java.net.*;
import java.io.*;
import javax.net.ssl.*;

String startDate = "010113"; // I'm pretty sure this is DD/MM/YY
String endDate   = "311214"; // Thus, 31 December 2014

// Daily data resolution: once per minute for 24 hours
int fidelity = 24 * 60; 

String[] response;
String protocol = "https";
String domain   = "api.nike.com";
String version  = "v1.0";
String path     = "me/activities/summary/" + startDate;

String deviceID    = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
String accessToken = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"; 


void setup() {
  //https://api.nike.com/v1.0/me/profile?access_token=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  
  String fullURL = protocol+"://"+domain+"/"+version+"/"+path + "?";
  fullURL += "access_token=" + accessToken + "&";
  fullURL += "deviceId=" + deviceID + "&";
  fullURL += "endDate=" + endDate + "&";
  fullURL += "fidelity=" + fidelity + "&";
  try {
    URL address = new URL(fullURL);
    HttpsURLConnection connection = (HttpsURLConnection)address.openConnection();
    connection.setRequestMethod("GET");
    connection.setDoOutput(true);
    connection.setReadTimeout(300000);
    connection.addRequestProperty("Accept", "application/json");
    connection.addRequestProperty("appid", "fuelband");
    println("opening connection, this may take a moment");
    connection.connect();
    
    BufferedReader rd  = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    StringBuilder sb = new StringBuilder();
    String line;
    while ((line = rd.readLine()) != null) {
        sb.append(line + '\n');
    }
    PrintWriter out = createWriter("fuelBandData.json");
    out.println(sb.toString());
    out.flush();
    out.close();
    println("data saved");
  } catch(Exception e) {
    e.printStackTrace();
  }
//  response = loadStrings(fullURL);
  
}
