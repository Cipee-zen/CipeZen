# CipeZen
CipeZen is a useful framework for optimizing and facilitating code creation

## Usage
- ### Initialize
  - Client
    >to start we must initialize the global variable `CZ`
  
    ***remember, the `cz` object is returned only when the player is loaded.***
    ```lua
    CZ = nil
  
    TriggerEvent("InitializeCipeZenFrameWork",function(cz)
      CZ = cz
    end)
    ```
    >to use [register callback](#registercallback) or [trigger callback](#triggercallback) you can also initialize like this.
  
    ***remember, the czcallback object is returned as soon as the event is called.***
    ```lua
    CZ = nil
  
    TriggerEvent("InitializeCipeZenFrameWork",function(cz)
      CZ = cz
    end,function(czcallback)
      -- register or call callback
    end)
    ```
  - Server
    
    >to start we must initialize the global variable `CZ`
    
    ***remember here don't need create another callback for [trigger callback](#s-triggercallback) or [register callback](#s-registercallback)***
    ```lua
    CZ = nil
  
    TriggerEvent("InitializeCipeZenFrameWork",function(cz) CZ = cz end)
    ```
## Client

- ### CreateThread

  >this function is the strong point of CipeZen, it allows you to create loops that are called at the desired time.

  ***remember, this function groups all loops with the specified tempo into a single loop in order to optimize performance.***
  
  Parameter | Type | Description
  ------------ | ------------- | -------------
  time | `int` | the delay time in milliseconds
  callback | `function(pause,reasume,delete)` | callback
  
  ```lua
  CZ.CreateThread(10,function(pause,reasume,delete)
    -- your code 
  end)
  ```
- ### RegisterCallback
  
  >this function registers a callback on the client for the server.

  ***in order to use this callback look at server [trigger callback](#s-triggercallback), you can use [CZ](#initialize) and [czcallback](#initialize) from `InitializeCipeZenFrameWork`.***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  name | `string` | the callback name
  callback | `function` | callback
  
  ```lua
  CZ.RegisterCallback("name",function(args)
    -- your code 
  end)
  ```
- ### TriggerCallback
  
  >this function trigger a callback from the client to server.

  ***in order to use this trigger callback look at server [register callback](#s-registercallback), you can use [CZ](#initialize) and [czcallback](#initialize) from `Initialize Client`.***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  name | `string` | the callback name
  callback | `function` | callback
  . . . | `all` | the arguments to pass to server [register callback](#s-registercallback)
  
  ```lua
  CZ.TriggerCallback("name",function(args)
    -- your code 
  end,...)
  ```
## Server

- ### <div id="s-registercallback">RegisterCallback</div>᲼
  >this function registers a callback on the server for the client.

  ***in order to use this callback look at client [trigger callback](#triggercallback), you can use [CZ](#initialize) from `Initialize Server`.***
  
  Parameter | Type | Description
  ------------ | ------------- | -------------
  name | `string` | the callback name
  callback | `function` | callback
  
  ```lua
  CZ.RegisterCallback("name",function(args)
    -- your code 
  end)
  ```
  
- ### <div id="s-triggercallback">TrggerCallback</div>᲼
  >this function trigger a callback from the server to client.

  ***in order to use this trigger callback look at client [register callback](#registercallback), you can use [CZ](#initialize)  from `Initialize Server`.***
  
  Parameter | Type | Description
  ------------ | ------------- | -------------
  name | `string` | the callback name
  to | `int` | the id of the player to trigger the callback
  callback | `function` | callback
  . . . | `all` | the arguments to pass to client [register callback](#registercallback)
  
  ```lua
  CZ.TrggerCallback("name",2,function(args)
    -- your code 
  end,...)
  ```
