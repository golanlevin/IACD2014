

/*
FuelDataParser - a tool to parse the FuelBand JSON data returend from api.nike.com
 May, 2013: Wesley Grubbs
 Feb, 2014: Golan Levin
 
 Dependencies:
 - a JSON file (usually about 5-10 MB) returned from calls to api.nike.com
 - Built for Processing 2.1
*/


String jsonFilename = "fuelBandData.json";

void setup() {

  size (720, 640); 
  background (255); 
  noLoop();

  JSONObject fuelbandJson = loadJSONObject(jsonFilename);
  JSONArray dailyJsonArray = fuelbandJson.getJSONArray("daily"); 
  int nDayObjects = dailyJsonArray.size();

  for (int i=0; i<nDayObjects; i++) {
    // get the data for the i'th day
    JSONObject aDayObj = dailyJsonArray.getJSONObject(i);  

    // get the minute-by-minute fuel history.
    JSONArray aDaysFuelHistory = aDayObj.getJSONArray("history"); 
    int nDaysFuelHistoryLength = aDaysFuelHistory.size(); // should be 1440: one per minute. 

    // render the fuel history to see what it looks like. 
    noFill(); 
    stroke(0, 0, 0, 96); 
    beginShape(); 
    if (nDaysFuelHistoryLength == 1440) {
      for (int m=0; m<1440; m++) {
        JSONObject aFuelMeasurementObj = aDaysFuelHistory.getJSONObject(m);
        int aFuelMeasurement = aFuelMeasurementObj.getInt("fuel"); 
        float x = m*0.5; 
        float y = i*6.0 - aFuelMeasurement*0.5; 
        vertex(x, y);
      }
    }
    endShape(); 


    JSONObject aSummary = aDayObj.getJSONObject("summary"); 
    if (aSummary != null) {

      //-------------------------------
      try {
        //"distance": 6.61573,
        float dailyDistance = aSummary.getFloat("distance");
        float dailyCalories = aSummary.getInt("calories"); 
        String mostActiveTimePeriodThatDay = aSummary.getString("mostActiveTimePeriod"); 
        
        fill (255,0,0, 64); 
        noStroke(); 
        float y = i*6.0;
        float rd = dailyDistance;
        ellipse(80,y, rd,rd); 
        
        fill(100,0,255, 64); 
        float rc = dailyCalories/150.0;
        ellipse(120,y, rc,rc); 
        
        //println(mostActiveTimePeriodThatDay); 
        
      } 
      catch (Exception e) {
      }
      
      

    }
  }
}


/*
// Structure of a daily summary object:
 {
 "tags": {},
 "startDate": 1356998400000,
 "mostRecentDSTOffset": "00:00",
 "activeTimePeriods": [{
 "02pm-04pm": 0,
 "06am-08am": 0,
 "00am-02am": 0,
 "02am-04am": 0,
 "08am-10am": 0,
 "04pm-06pm": 0,
 "12pm-02pm": 0,
 "06pm-08pm": 0,
 "10pm-00am": 0,
 "04am-06am": 0,
 "10am-12pm": 0,
 "08pm-10pm": 0
 }],
 "lastKnownDailyGoal": 3500,
 "mostRecentTZOffset": "-08:00",
 "steps": 8402,
 "frequency": "DAILY",
 "leastActiveTimePeriod": "08pm-00am",
 "mostActiveTimePeriod": "08pm-00am",
 "distance": 6.61573,
 "calories": 1394,
 "activeTime": 735,
 "totalFuel": 3824,
 "avgFuelPerDay": 3824,
 "activityType": "ALL_DAY",
 "dailyGoal": {
 "progress": 3824,
 "dailyGoalsSuccessful": 1,
 "targetValue": 3500,
 "dailyGoalsTotal": 1
 }
 }
 
 */
