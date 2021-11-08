sub init()
    m.rowListOfCars = m.top.findNode("RListOfCars")
    m.rowListOfCars.setFocus(true)
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.infoLable = m.top.findNode("infoAboutTesting")
    m.genre = m.top.findNode("genre")
    m.description = m.top.findNode("descriptionOfCars")
    m.secondScreen = m.top.findNode("secondScreen")
    m.blendAnimation = m.top.findNode("blendAnimation")
    m.rowListOfCars.observeField("itemFocused", "changeHomeScreenContent")
    m.rowListOfCars.observeField("itemSelected", "setSecondScreenContent")
    m.rowListOfCars.observeField("itemSelected", "changeVisibilityOfComponents")
    m.infoLable.font.size = 36
    m.infoLable.font = "font:LargeBoldSystemFont" 
    m.genre.text = "Genre: motoring | 0 year"
    m.genre.font.size = 16
    m.description.font.size =16
    m.description.font = "font:SmallestBoldSystemFont" 
    taskNode = CreateObject("RoSGNode", "TaskNode")
    taskNode.observeField("responseData", "handleResponse")
    taskNode.control = "run"
    m.indexOfPrevItem = 0
 end sub
 
 function handleResponse(event)
   data = event.getData()
   content = CreateObject("RoSGNode","ContentNode")
   columnSpacings = []
   dataofChannel =  data["rss"][0]["channel"]
   count = 0
   For Each itemofChanel in dataofChannel 
       if itemofChanel.DoesExist("item")
          rowItem = content.createChild("ContentNode")
          columnSpacings.push(35.0)
          itemData = itemOfChanel["item"]
        For Each item in itemData  
           if item.DoesExist("media:thumbnail") 
               media = item["attributes"]
               mediaUrl = media.url.Replace("300x168.jpg", "1280x720.jpg")
               rowItem.Description = mediaUrl
               count++
               rowItem.addField("isPlayed", "boolean", false)
           else if item.DoesExist("description")
                rowItem.Title = item["description"]
           else if item.DoesExist("title")
                rowItem.TitleSeason = item["title"]
           else if item.DoesExist("media:title")
                rowItem.TitleSeason = item["media:title"]
                rowItem.HDBranded = false
                sec = CreateObject("roRegistrySection", "Favorites")
                keys =  sec.GetKeyList() 
            if  sec.Exists(rowItem.TitleSeason )
                rowItem.HDBranded = true
            end if
           else if item.DoesExist("media:content")
                videoUrl = item["attributes"]
                rowItem.Url = videoUrl.url  
                duration = videoUrl.duration.toInt()
                rowItem.PlayDuration = duration                    
           End if 
         End For  
       End if
    End For  
       m.rowListOfCars.columnSpacings =  columnSpacings
       m.rowListOfCars.content = content
 end function

Function updateFavoriteData(key)
  sec = CreateObject("roRegistrySection", "Favorites")
  if  m.currentElement.HDBranded 
    sec.Delete(key)
    m.currentElement.HDBranded = not m.currentElement.HDBranded
  else 
    sec.write(key, "true")
    sec.Flush()
    m.currentElement.HDBranded = true
    end if
End Function

function changeHomeScreenContent(event)
  prevItem = m.rowListOfCars.content.getChild(m.indexOfPrevItem)
  prevItem.isPlayed = false 
  m.blendAnimation.control = "start"
  index = event.getData()
  m.rowListOfCars.content.getChild(index).isPlayed = true
  m.currentElement = m.rowListOfCars.content.getChild(index) 
  m.indexOfPrevItem = index
  m.currentElement.isPlayed = true
  focusedElement = m.rowListOfCars.content.getChild(index)
  m.infoLable.text = focusedElement.TitleSeason
  m.description.text = focusedElement.Title
  m.backgroundPoster.uri = focusedElement.Description  
end function

function setSecondScreenContent(event)
  data = event.getData()
  m.secondScreenData = m.rowListOfCars.content.getChild(data) 
  m.secondScreenComponent = CreateObject("roSGNode", "SecondScreen")
  m.top.appendChild(m.secondScreenComponent)
  m.secondScreenComponent.setFocus(true)
  m.secondScreenComponent.dataSecondScreen = m.secondScreenData
  m.secondScreenComponent.setFocusVideo = true
  m.secondScreenComponent.key = m.secondScreenData.TitleSeason
  m.secondScreenComponent.visible = true  
  m.currentElement.isPlayed = false
  m.secondScreenComponent.videoSetter = true
 end function 
  
 function OnKeyEvent(key, press) as boolean
    result = true
    if key = "back" 
      if  m.secondScreenComponent <> invalid  
         if m.secondScreenComponent.buttonSelected 
           m.currentElement.HDBranded = true
         end if
         m.top.removeChild(m.secondScreenComponent)
         m.secondScreenComponent = invalid
         m.rowListOfCars.setFocus(true)
       return true
      end if
     end if  
     if key = "options"
       if not press 
          updateFavoriteData(m.currentElement.TitleSeason)
       end if 
     end if
        return result
 end function
 