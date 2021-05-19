global darkSkyURL := "https://darksky.net/forecast/xx.x,-xx.x/us12/en"

destroyCreateGUI(){
  gui, destroy
  createGui()
}

openDarksky(){
  run firefox.exe %darkSkyURL%
}

ConnectedToInternet(flag=0x40) { 
  Return DllCall("Wininet.dll\InternetGetConnectedState", "Str", flag,"Int",0) 
}

getWeather() {
  global

  if (ConnectedToInternet()){
    httpObj := comObjCreate("Msxml2.XMLHTTP")
    httpObj.open("GET", darkSkyURL, false)
    httpObj.send()
    weather := httpObj.responseText
  }
  gui, font, s9 q5, segue ui
  gui, add, text, vmainCurrentWeather y5 gopenDarksky c9AA83A wrap, % getCurrentWeather(weather)
  gui, add, text, vmainCurrentLowHigh gopenDarksky c9AA83A, % "l:" getLow(weather) " h:" getHigh(weather)
  gui, add, text, vmainFeelsLike gopenDarksky cD0B344, % "feels like: " getFeelsLike(weather)
  gui, add, text, vmainSummary gopenDarksky cebf8ff w220 wrap , % getSummary(weather)
  gui, add, text, vmainNext gopenDarksky c808080 w220 wrap , % getNext(weather)
  gui, font, s8 q5, segue ui
  gui, add, text, vmainDay1 gopenDarksky c7195a8, % "+1 day :" getDay1Min(weather) " / " getDay1Max(weather)
  gui, add, text, vmainDay2 gopenDarksky c9A9B99, % "+2 days:" getDay2Min(weather) " / " getDay2Max(weather)
  gui, add, text, vmainDay3 gopenDarksky c808080, % "+3 days:" getDay3Min(weather) " / " getDay3Max(weather)
}

getCurrentWeather(weather){
  regExMatch(weather,"<span class=""summary swap"">\s*(\S.*?)\s*</span>", currentWeather )
  currentWeather := strReplace(currentWeather1, "&nbsp;", " ")
  stringLower, currentWeather, currentWeather
  return currentWeather
}

getLow(weather){
  regExMatch(weather,"<span class=""low-temp-text"">\s*(\S.*?)\s*</span>", currentLow )
  currentLow1 := strReplace(currentLow1, "&nbsp;", " ")
  return %currentLow1%
}

getHigh(weather){
  regExMatch(weather,"<span class=""high-temp-text"">\s*(\S.*?)\s*</span>", currentHigh )
  currentHigh1 := strReplace(currentHigh1, "&nbsp;", " ")
  return %currentHigh1%
}

getFeelsLike(weather){
  regExMatch(weather,"<span class=""feels-like-text"">\s*(\S.*?)\s*</span>", feelsLike )
  feelsLike := strReplace(feelsLike1, "&nbsp;", " ")
  return %feelsLike%
}

getSummary(weather){
  regExMatch(weather,"<span class=""currently__summary next swap"">\s*(\S.*?)\s*</span>", currentSummary )
  currentSummary := strReplace(currentSummary1, "&nbsp;", " ")
  stringLower, currentSummary, currentSummary
  return %currentSummary%
}

getNext(weather){
  regExMatch(weather,"<div class=""summary"">\s*(\S.*?)\s*</div>", weatherNext )
  weatherNext := strReplace(weatherNext1, "&nbsp;", " ")
  stringLower, weatherNext, weatherNext
  return %weatherNext%
}

getDay1Min(weather){
  regExMatch(weather,"data-day=""1"".*?<span class=""minTemp"" style=""left:.*?"">\s*(\S.*?)\s*</span>", weatherDay1Min )
  return %weatherDay1Min1%
}

getDay1Max(weather){
  regExMatch(weather,"data-day=""1"".*?<span class=""maxTemp"" style=""left:.*?"">\s*(\S.*?)\s*</span>", weatherDay1Max )
  return %weatherDay1Max1%
}

getDay2Min(weather){
  regExMatch(weather,"data-day=""2"".*?<span class=""minTemp"" style=""left:.*?"">\s*(\S.*?)\s*</span>", weatherDay2Min )
  return %weatherDay2Min1%
}

getDay2Max(weather){
  regExMatch(weather,"data-day=""2"".*?<span class=""maxTemp"" style=""left:.*?"">\s*(\S.*?)\s*</span>", weatherDay2Max )
  return %weatherDay2Max1%
}

getDay3Min(weather){
  regExMatch(weather,"data-day=""3"".*?<span class=""minTemp"" style=""left:.*?"">\s*(\S.*?)\s*</span>", weatherDay3Min )
  return %weatherDay3Min1%
}

getDay3Max(weather){
  regExMatch(weather,"data-day=""3"".*?<span class=""maxTemp"" style=""left:.*?"">\s*(\S.*?)\s*</span>", weatherDay3Max )
  return %weatherDay3Max1%
}