sub init()
    m.automobilePoster = m.top.findNode("PosterOfCar") 
    m.carVideoAnimation = m.top.findNode("carVideoAnimation")
    m.favorites = m.top.findNode("Favorites")
    m.animationVideo = m.top.findNode("animationVideo")
end sub

function onItemFocus()
      m.valueofFirstKey = 1.0
end function

function fireAnimation()
   if m.top.focusPercent = 0.0
       m.carVideoAnimation.control = "start" 
       m.animationVideo.keyValue = [m.valueofFirstKey , 1.0]
    else 
   end if 
end function

function changeAfterBuffering(event)
      bufferingEvent = event.getData()
      if bufferingEvent = "playing"  
         m.automobilePoster.visible = false
         m.favorites.visible = false
         m.valueofFirstKey = 0.0  
      else if bufferingEvent = "stopped"   
         m.valueofFirstKey = 1.0
         m.automobilePoster.visible = true
         m.favorites.visible = true
      end if
end function

function displayCarsImages()
   carImages = m.top.itemContent
   resolutionCellImage = carImages.Description.Replace("1280x720.jpg", "280x140.jpg")
   m.automobilePoster.uri = resolutionCellImage 
   m.automobilePoster.width = m.top.width
   m.automobilePoster.height = m.top.width
   if carImages.HDBranded
      m.favorites.uri = "pkg:/images/icActiveLike.png"
   else 
      m.favorites.uri ="pkg:/images/icActiveDislike.png"   
   end if
    if  carImages.isPlayed 
     if m.video = invalid
      m.video = CreateObject("roSGNode", "Video")
      m.video.width  = m.top.width
      m.video.height  = m.top.height
      videoContent = createObject("RoSGNode", "ContentNode")
      m.top.insertChild(m.video, 0) 
      videoContent.streamformat = "hls"
      videoContent.url = carImages.Url   
      m.video.content = videoContent
      m.video.control = "play"
      m.video.loop = true
      m.video.observeField("state", "changeAfterBuffering")
     end if
    else if m.video <> invalid
      m.video.control = "stop"
      m.top.removeChild(m.video)
      m.video = invalid
   end if
end function