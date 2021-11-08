sub init()
   m.top.functionName = "getRequest"
end sub

function getRequest() 
    res = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    res.SetPort(port)
    res.setURL(m.top.requestUrl)
    res.EnableEncodings(true)
    res.SetCertificatesFile("common:/certs/ca-bundle.crt")
    res.InitClientCertificates()     
    if res.AsyncGetToString()
        while true
            msg = Wait (0, port)
            if Type (msg) = "roUrlEvent"
                resJson = invalid
                if msg.GetResponseCode() = 200
                 response = msg.GetString()
                 responseXML = CreateObject("roXMLElement")
                 responseXML.parse(response)             
                 data = handleXML(responseXML) 
                 m.top.responseData = data 
                else  
                  a = msg.GetString()               
                end if              
                exit while
            else if Type (msg) = "Invalid"
                res.AsyncCancel()
                exit while
            end if
        end while
    end if
end function

function handleXML(responseXML) as Object
    assocArray = {}
    items = []
    key = responseXML.getName()
    children = responseXML.GetChildElements()
    attributes = responseXML.GetAttributes()
    assocArray.attributes = attributes
    for each child in children
        items.push(parseXMLElements(child))
    end for
    assocArray[key] = items
    assocArray.attributes = attributes
    return assocArray
end function

function parseXMLElements(child) as object
    assocArray = {}
    key = child.getName() 
    children = child.GetBody()
    attributes = child.GetAttributes()
    items = []
    if Type(children) = "roXMLList"
      for each childXML in children
       item = parseXMLElements(childXML)
       items.push(item)
      end for
    end if
    if items.count() > 0 
        assocArray[key] = items
    else
        assocArray[key] = children
    end if
        assocArray.attributes = attributes
    return assocArray
end function