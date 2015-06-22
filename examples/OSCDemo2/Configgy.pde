//-------------------------------------------------------------------
//  Configgy reads in a file holding config data.
//  The file format is "sort of json"
//  Each line is assumed to be valid json, absent wrapping braces.
//
//  You can read about this at http://jamesbritt.com/posts/getting-configgy-with-processing.html
//  
//  The basic idea is to make writing simple key:value settings super easy,
//  and more complex entries possible.
//
//  The code is constantly evolving based on usage.
//
//-------------------------------------------------------------------


import java.util.Map;
import java.util.Iterator;

class Configgy {

  String[] configTextLines;
  JSONObject json;

  Configgy(String configFile) {
    try {
      configTextLines = getDataLines(loadStrings(configFile));

      String line = trim(configTextLines[0]);
      if (line.charAt(0) == '{') {
        json = loadJSONObject(configFile);
      } else {
        String jsonString = configToJson(configTextLines);
        json = parseJSONObject(jsonString);
      }
    } catch(Exception e) {
      println("Error loading data from '" + configFile + "'");
      e.printStackTrace();
    }
  }

  //-------------------------------------------------------------------
  // Return just the lines that have config data
  String[] getDataLines(String[] configTextLines) {
    String[] dataLines = {};
    String line;

    for (int i=0; i < configTextLines.length; i++) {
      line = trim(configTextLines[i]);
      if ( ( line.indexOf("#") != 0 ) &&  ( line.indexOf(":") > 0 ) )  {
        dataLines = append(dataLines,  line);  
      }
    }
    return dataLines ;
  }


  //-------------------------------------------------------------------
  // Assumes we have a set of congig lines, each being of the form
  //    keyName: validJsonExpression
  String configToJson(String[] configTextLines) {
    String line;
    String[] jsonStrings = {"{" };
    String[] splitString;
    String newJsonLine = "";
    for (int i=0; i < configTextLines.length; i++) {
      line = trim(configTextLines[i]);

      if ( ( line.indexOf("#") != 0 ) &&  ( line.indexOf(":") > 0 ) )  {
        splitString = split(configTextLines[i], ':'); 
        newJsonLine = "\"" + splitString[0] + "\":"  + join(subset(splitString,1), ":" ) + ", ";
        jsonStrings = append(jsonStrings,  newJsonLine);  

      }
    }

    jsonStrings = append(jsonStrings, "}"  );  
    return  join(jsonStrings, "\n");
  }


  //-------------------------------------------------------------------
  // Assorted accessor methods
  String getValue(String k) { return json.getString(k); }

  //-------------------------------------------------------------------
  String getValue(String k, String defaultVal ) { 
    String val = defaultVal;
    try {
      val =  json.getString(k); 
      return val;
    } catch(Exception e) {
      return defaultVal;
    }
  }

  //-------------------------------------------------------------------
  String getString(String k) { return json.getString(k); }

  //-------------------------------------------------------------------
  String getString(String k, String defaultVal ) { 
    String val = defaultVal;
    try {
      val =  json.getString(k); 
      return val;
    } catch(Exception e) {
      return defaultVal;
    }
  }


  //-------------------------------------------------------------------
  int getInt(String k) { return json.getInt(k); }

  //-------------------------------------------------------------------
  int getInt(String k, int defaultVal ) { 
    int val = defaultVal;

    try {
      val = json.getInt(k);
      return val;

    } catch(Exception e) {
      return defaultVal;
    }
  }

  //-------------------------------------------------------------------
  float getFloat(String k) { return json.getFloat(k); }

  //-------------------------------------------------------------------
  float getFloat(String k, float defaultVal ) { 
    float val = defaultVal;

    try {
      val = json.getFloat(k);
      return val;

    } catch(Exception e) {
      return defaultVal;
    }
  }

  //-------------------------------------------------------------------
  boolean getBoolean(String k) { return json.getBoolean(k); }

  //-------------------------------------------------------------------
  boolean getBoolean(String k, boolean defaultVal) { 
    boolean val = defaultVal;

    try {
      val = json.getBoolean(k);
      return val;
    } catch(Exception e) {
      return defaultVal;
    }
  }

  //--------------------------------------------------------------
  String[][] getStringList(String k) {
    JSONArray values = json.getJSONArray(k);
    String[][] strings = new String[values.size()][2];
    for (int i = 0; i < values.size(); i++) {
      strings[i] = jsonArrayToStrings(values.getJSONArray(i));
    }
    return strings;
  }

  //--------------------------------------------------------------
  String[] jsonArrayToStrings( JSONArray values ) {
    String[] strings = new String[values.size()];
    for (int i = 0; i < values.size(); i++) {
      strings[i] = values.getString(i);
    }
    return strings;
  }



  //--------------------------------------------------------------
  //  NOTE: Things asplode if you call the wrong 'getXXX' method
  String[] getStrings(String k) {
    JSONArray values = json.getJSONArray(k);
    String[] strings = new String[values.size()];
    for (int i = 0; i < values.size(); i++) {
      strings[i] = values.getString(i);
    }
    return strings;
  }

  //-------------------------------------------------------------------
  // Assumes the JSON "hashmap" is string:string.
  // Might look at adding some ways to get other kinds of maps.
  // However, if the client really needs, say, strings and ints then
  // the values returned can be casted or otherwise converted.
  HashMap<String,String> getHashMap(String k) {
    HashMap<String, String> h = new HashMap<String, String>();
    JSONObject jo = json.getJSONObject(k);

    Iterator keys = jo.keyIterator();

    while( keys.hasNext() ) {
      String key_name = (String) keys.next(); 
      h.put(key_name,  jo.getString(key_name));
    }
    return h;
  }

  //-------------------------------------------------------------------
  HashMap<Integer,String> getHashMapN(String k) {

    HashMap<Integer, String> h = new HashMap<Integer, String>();
    JSONObject jo = json.getJSONObject(k);

    Iterator keys = jo.keyIterator();

    while( keys.hasNext() ) {
      String key_name = (String) keys.next(); 
      h.put(parseInt(key_name),  jo.getString(key_name));
    }
    return h;

  }

  //-------------------------------------------------------------------
  int[] getInts(String k) {
    JSONArray values = json.getJSONArray(k);
    int[] ints = new int[values.size()];
    for (int i = 0; i < values.size(); i++) {
      ints[i] = values.getInt(i); 
    }
    return ints;
  }

  //-------------------------------------------------------------------
  float[] getFloats(String k) {
    JSONArray values = json.getJSONArray(k);
    float[] floats = new float[values.size()];
    for (int i = 0; i < values.size(); i++) {
      floats[i] = values.getFloat(i); 
    }
    return floats;
  }


  //-------------------------------------------------------------------
  boolean[] getBooleans(String k) {
    JSONArray values = json.getJSONArray(k);
    boolean[] booleans= new boolean[values.size()];
    for (int i = 0; i < values.size(); i++) {
      booleans[i] = values.getBoolean(i); 
    }
    return booleans;
  }

}


