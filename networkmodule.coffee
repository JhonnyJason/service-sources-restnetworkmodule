networkmodule = {name: "networkmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["networkmodule"]?  then console.log "[networkmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
fetch = require("node-fetch").default

############################################################
specificInterface  = require("./specificinterface")

############################################################
networkmodule.initialize = () ->
    log "networkmodule.initialize"
    if specificInterface? then Object.assign(networkmodule, specificInterface)
    return

############################################################
networkmodule.postData = (url, data) ->
    options =
        method: 'POST'
        credentials: 'omit'
        body: JSON.stringify(data)
        headers:
            'Content-Type': 'application/json'

    response = await fetch(url, options)
    if response.status == 403 then throw new Error("Unauthorized!")
    return response.json()

networkmodule.getData = (url) ->
    response = await fetch(url)
    if response.status == 403 then throw new Error("Unauthorized!")
    return response.json()

module.exports = networkmodule