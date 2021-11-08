sub init()
end sub

function OnKeyEvent(key, press) as boolean
    result = true   
    if key = "OK"    
        if not m.top.disableEventBubling
           m.top.disableEventBubling = true
           result = true
         else 
           result = false     
         end if  
    end if
    if key = "back"
        m.top.disableEventBubling=false
        result = false
    end if
    return result
 end function
