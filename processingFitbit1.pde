// This Processing 2.1 code uses the Temboo library to access the Fitbit API. 
// To use it, you will need a Fitbit account and a Temboo account. 
// See: https://www.temboo.com/library
// See: https://dev.fitbit.com/apps/new
// Golan Levin, Feb. 6, 2014


/*
// Example of an extracted json file: 

{
 "lifetime":{
  "total":{
     "activeScore":-1,
     "caloriesOut":8404,
     "distance":25.27,
     "floors":110,
     "steps":37722},
   "tracker":{
     "activeScore":-1,
     "caloriesOut":8375,
     "distance":25.27,
     "floors":110,
     "steps":37722}
   }
 }
 
*/


import com.temboo.core.*;
import com.temboo.Library.Fitbit.Statistics.*;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("golanlevin", "myFirstApp", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");

void setup() {
  // Run the GetActivityStats Choreo function
  runGetActivityStatsChoreo();
}

void runGetActivityStatsChoreo() {
  // Create the Choreo object using your Temboo session
  GetActivityStats getActivityStatsChoreo = new GetActivityStats(session);

  // Set secret inputs. Get your own!
  // I used the Fitbit App registration and Temboo OAuth Wizard to get these. 
  // See: https://dev.fitbit.com/apps/new
  getActivityStatsChoreo.setAccessToken      ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
  getActivityStatsChoreo.setAccessTokenSecret("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
  getActivityStatsChoreo.setConsumerSecret   ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
  getActivityStatsChoreo.setConsumerKey      ("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");

  // Run the Temboo "Choreo" and store the results
  GetActivityStatsResultSet getActivityStatsResults = getActivityStatsChoreo.run();
  println(getActivityStatsResults.getResponse());
  
  // Print results, save them to a file. 
  PrintWriter output;
  output = createWriter("data/fitbit_data.json"); 
  output.println(getActivityStatsResults.getResponse());
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  
  // Load in the file, parse it as JSON. 
  JSONObject json;
  json = loadJSONObject("data/fitbit_data.json");
  JSONObject lifetime = json.getJSONObject("lifetime");
  JSONObject total = lifetime.getJSONObject("total");
  int  fitbitSteps = total.getInt("steps");
  float fitbitDistance = total.getFloat("distance");
  println ("--------------------------"); 
  println ("fitbitSteps: " + fitbitSteps); 
  println ("fitbitDistance: " + fitbitDistance); 

}

