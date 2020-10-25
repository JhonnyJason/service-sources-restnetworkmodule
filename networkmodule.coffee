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
cfg = null
auth = null

############################################################
networkmodule.initialize = () ->
    log "networkmodule.initialize"
    cfg = allModules.configmodule
    auth = allModules.authmodule
    return

############################################################
postData = (url, data) ->
    options =
        method: 'POST'
        credentials: 'omit'
        body: JSON.stringify(data)
        headers:
            'Content-Type': 'application/json'

    response = await fetch(url, options)
    if response.status == 403 then throw new Error("Unauthorized!")
    return response.json()

############################################################
#region exposedFunctions

############################################################
networkmodule.getTickers = (exchange, assetPairs)->
    log "networkmodule.getTickers"

    throw new Error("Exchange does not exist") unless cfg[exchange]?
    assetPairs = cfg[exchange].assetPairs unless assetPairs?
    assetPairs = [assetPairs] unless Array.isArray(assetPairs)

    requestURL = cfg[exchange].observerURL + "/getLatestTicker"
    data = {assetPairs}
    return postData(requestURL, data)

networkmodule.getBalances = (exchange, assets)->
    log "networkmodule.getBinanceBalances"

    throw new Error("Exchange does not exist") unless cfg[exchange]?
    assets = cfg[exchange].assets unless assets?
    assets = [assets] unless Array.isArray(assets)

    requestURL = cfg[exchange].observerURL + "/getLatestBalance"
    data = {assets}
    return postData(requestURL, data)

networkmodule.getOrders = (exchange, assetPairs)->
    log "networkmodule.getBinanceTickers"

    throw new Error("Exchange does not exist") unless cfg[exchange]?
    assetPairs = cfg[exchange].assetPairs unless assetPairs?
    assetPairs = [assetPairs] unless Array.isArray(assetPairs)

    requestURL = cfg[exchange].observerURL + "/getLatestOrders"
    data = {assetPairs}
    return postData(requestURL, data)


############################################################
networkmodule.placeOrders = (exchange, orders)->
    log "networkmodule.placeOrders"
    
    throw new Error("Exchange does not exist") unless cfg[exchange]?
    orders = [orders] unless Array.isArray(orders)

    signature = auth.createSignature(JSON.stringify(orders))
    requestURL = cfg[exchange].traderURL + "/placeOrders"
    data = {orders,signature}
    return postData(requestURL, data)

networkmodule.cancelOrders = (exchange, orders)->
    log "networkmodule.cancelOrders"
    
    throw new Error("Exchange does not exist") unless cfg[exchange]?
    orders = [orders] unless Array.isArray(orders)

    signature = auth.createSignature(JSON.stringify(orders))
    requestURL = cfg[exchange].traderURL + "/cancelOrders"
    data = {orders,signature}
    return postData(requestURL, data)

#endregion

module.exports = networkmodule