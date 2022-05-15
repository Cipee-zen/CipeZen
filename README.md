# CipeZen
CipeZen is a useful framework for optimizing and facilitating code creation

## Usage

## Client

- ### InitializeCipeZenFrameWork
  
  >to start we must initialize the global variable `CZ`
  
  ***remember, the `cz` object is returned only when the player is loaded.***
  ```lua
  CZ = nil
  
  TriggerEvent("InitializeCipeZenFrameWork",function(cz)
    CZ = cz
  end)
  ```
  >to use [register callback](#RegisterCallback) or [trigger callback](#trigger-callback) you can also initialize like this.
  
  ***remember, the czcallback object is returned as soon as the event is called.***
  ```lua
  CZ = nil
  
  TriggerEvent("InitializeCipeZenFrameWork",function(cz)
    CZ = cz
  end,function(czcallback)
    -- register or call callback
  end)
  ```
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

  ***in order to use this callback look at server trigger callback, you can use [CZ](#cipezen) and [czcallbac](#cipezen) from `InitializeCipeZenFrameWork`.***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  name | `string` | the callback name
  callback | `function` | callback
  
  ```lua
  CZ.RegisterCallback("name",function(args)
    -- your code 
  end)
  ```
