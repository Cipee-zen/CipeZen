# CipeZen
    CipeZen is built using the ESX usage framework,it allows the optimization and simplification of resource development
  
    ⚒️CipeZen is in beta let me know for bugs or improvements.⚒️

## Requirements
  - [cz_menu](https://github.com/Cipee-zen/cz_menu) - v2.0.0 [info](#menu)
  - [mysql-async](https://github.com/brouznouf/fivem-mysql-async) - v3.3.2
## SecureResource
    SecureResource is used to secure the client side of resources from damping, to start securing a script click 'start.bat' in the 'SecureConfig' folder

    ⚒️SecureResource is in beta let me know for bugs or improvements.⚒️
## Important
  >add this in server.cfg

  ```add_ace resource.CipeZen command.add_ace allow
  add_ace resource.CipeZen command.add_principal allow
  add_ace resource.CipeZen command.remove_principal allow
  add_ace resource.CipeZen command.stop allow
  ```
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
    
    AddEventHandler("CZ:onUpdate", function (cz)
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

    AddEventHandler("CZ:onUpdate", function (cz)
	    CZ = cz
    end)
    ```
  - Server
    
    >to start we must initialize the global variable `CZ`
    
    ***remember here don't need create another callback for [trigger callback](#s-triggercallback) or [register callback](#s-registercallback)***
    ```lua
    CZ = nil
  
    TriggerEvent("InitializeCipeZenFrameWork",function(cz) CZ = cz end)
    ```
- ### Commands
  - `setpermission`
    >set the permission of a player [`admin`,`user`]

    ***permission that can use the command `admin`***
    Args | Name | Description
    ------------ | ------------- | -------------
    `{1}` | id | player id
    `{2}` | group | the group to set
  - `car`
    >spaw a vehicle  [`adder`]

    ***permission that can use the command `admin`***
    Args | Name | Description
    ------------ | ------------- | -------------
    `{1}` | model | car model
  - `dv`
    >deletes nearby vehicles

    ***permission that can use the command `admin`***
    Args | Name | Description
    ------------ | ------------- | -------------
    `{1}` | range | range of deleting
  - `giveitem`
    >give item to player

    ***permission that can use the command `admin`***
    Args | Name | Description
    ------------ | ------------- | -------------
    `{1}` | to | Id of player or 'me' for yourself
    `{2}` | item | item name
    `{3}` | amount | amount of item
- ### Variables
  Variable | Type | Description
  ------------ | ------------- | -------------
  PlayerId | `int` | the client id of the player
  PlayerPedId | `int` | the ped id of the player
  PlayerServerId | `int` | the server id of the player
  PlayerName | `string` | the steam name of the player
  Job | `object` | returns all information about the player's job
  Idenrifiers | `object` | returns all player identifiers
  - #### Job
    Variable | Type | Description
    ------------ | ------------- | -------------
    JobName | `string` | job name
    JobLabel | `string` |  job label
    Grade | `int` | the grade of job
    GradeLabel | `string` | the grade label
    GradeName | `string` | the grade name

  - #### Identifiers
    Variable | Type | Description
    ------------ | ------------- | -------------
    steam | `string` | steam id 
    license | `string` | rockstar license
    xbl | `string` | xbl id
    ip | `string` | ip from client
    discord | `string` | discord id
    live | `string` | live id

## Client

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
- ### ControlPressed
  >this function creates a callback when the control is pressed

  ***with this method the callback is activated only when the control is pressed,find [here all key](#allkey) or check the [Fivem Reference](https://docs.fivem.net/docs/game-references/controls/)***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  key | `string` or `int` | the key to handle
  callback | `function` | the callback

  ```lua
  CZ.ControlPressed("F2" or 289 ,function()
    -- your code
  end)
  ```

- ### DrawMarker
  >this feature makes creating markers much easier

  ***remember that you can also not specify all the marker data, there are the default ones,check the [Fivem marker reference](https://docs.fivem.net/docs/game-references/markers/)***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  options | `object` | the marker options, **pos , color ecc...**

  - options
    Parameter | Type | Default |Description
    ------------ | ------------- | ------------- | -------------
    type    | `int`   | **2** | The marker type to draw
    posX    | `float` | **0.0** | The X coordinate to draw the marker at
    posY    | `float` | **0.0** | The Y coordinate to draw the marker at
    posZ    | `float` | **0.0** | The Z coordinate to draw the marker at
    dirX    | `float` | **0.0** | The X component of the direction vector for the marker
    dirY    | `float` | **0.0** | The Y component of the direction vector for the marker
    dirZ    | `float` | **0.0** | The Z component of the direction vector for the marker
    rotX    | `float` | **0.0** | The X rotation for the marker. Only used if the direction vector is **0.0**
    rotY    | `float` | **0.0** | The Y rotation for the marker. Only used if the direction vector is **0.0**
    rotZ    | `float` | **0.0** | The Z rotation for the marker. Only used if the direction vector is **0.0**
    scaleX  | `float` | **1.0** | The scale for the marker on the X axis
    scaleY  | `float` | **1.0** | The scale for the marker on the Y axis
    scaleZ  | `float` | **1.0** | The scale for the marker on the Z axis
    red     | `int`   | **200** | The red component of the marker color, on a scale from 0-255
    green   | `int`   | **200** | The green component of the marker color, on a scale from 0-255
    blue    | `int`   | **200** | The blue component of the marker color, on a scale from 0-255
    alpha   | `int`  | **200** | The alpha component of the marker color, on a scale from 0-255
    bobUpAndDown| `bool` | **false** | Whether or not the marker should slowly animate up/down
    faceCamera  | `bool` | **false** | Whether the marker should be a 'billboard', as in, should constantly face the camera
    p19  | `int` | **2** | Typically set to 2. Does not seem to matter directly
    rotate  | `bool` | **false** | Rotations only apply to the heading
    textureDict  | `string` | **nil** |  A texture dictionary to draw the marker
    textureName  | `string` | **nil** |  A texture name in textureDict to draw
    drawOnEnts  | `bool` | **false** |  Whether or not the marker should draw on intersecting entities
  
  ```lua
  local pos = GetEntityCoords(PlayerPedId())
  CZ.DrawMarker({type = 1,posX = pos.x,posY = pos.y,posZ = pos.z })
  ```

<!--
- ### Menu
  >this menu allows you to create multiple buttons with a callback at the interaction

  ***this function allows you to create a menu that is still in beta,install [c_menu_z](https://github.com/Cipee-zen/c_menu_z)***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  name | `string` | the name of the menu must be unique
  data | `object` | the preferences of the menu
  callback | `function(Value,Close)` | the callback at the interaction,return the **button value** and the **close function**
  callback2 | `function(Close)` | the callback when pressing the close menu button,return **close function**

  ```lua
  local buttons = {
    {value = "dog",label = "Dog"},
  }
  CZ.Menu("name",{
    Title = "Dog menu"
    Buttons = buttons,
  },function(Value,Close)
    if Value == "dog" then
      print("Bauuu !")
      Close()
    end
  end,function(Close)
    Close() -- on press the control to close the menu close it,
  end)
  ```
-->
- ### Notify

  >this function allows you to create a notification of a specific duration

  ***remember not to call this function too many times per second***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  title | `string` | the title of the notification
  description | `string` | the description of the notification
  time | `int` | **[OPTIONAL]** how long the notification is displayed

  ```lua
  CZ.Notify("title","description",5000)
  ```
- ### HelpNotify

  >this function allows you to create a notification of a specific duration

  ***remember if you want to repeat this function many times for second, don't add the time variable***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  title | `string` | the title of the notification
  description | `string` | the description of the notification
  time | `int` | **[OPTIONAL]** how long the notification is displayed

  ```lua
  CZ.HelpNotify("title","description",5000)
  ```
- ### GetNearestPlayer
  >return the player closest to you

  ***remember that it returns both the coordinates and the player id***

   ```lua
  local player,distance = CZ.GetNearestPlayer()
  ```
- ### Menu

  >this function allows you to open the menu

  ***this function allows you to open the menu via [cz_menu](https://github.com/Cipee-zen/cz_menu)***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  type | `string` | the type of the menu **menu/text**
  elements/title | `object/string` | the elements of the menu or the title of the text
  cb | `function` | the interaction callback
  cb | `function` | the close interaction callback

  ```lua
  -- icons https://fontawesome.com/icons
  local elements = {
		nil,-- 1
		nil,-- 2
		{icon="fas fa-thumbs-up",value="yes",description = "some description"},-- 3
		nil,-- 4
		nil,-- 5
		nil,-- 6
		{icon="fas fa-thumbs-down",value="no",description = "some description"},-- 7
      nil,-- 8
	}
  CZ.Menu("menu",elements,function (menu,value)
		if value == "yes" then
			print("you clicked yes")
		end
  end,function (menu)
		menu.close()
  end)

  -- text type menu
  CZ.Menu("text","title",function (menu,value)
		print(value)
  end,function (menu)
		menu.close()
  end)

  ```
- ### CloseAllMenu
  >this function allows you to close all menus
  
  ```lua
  CZ.CloseAllMenu()
  ```
- ### CloseMenu
  >this function allows you to close the menu
  
   Parameter | Type | Description
  ------------ | ------------- | -------------
  menu | `id` | the menu id to close returned on open
  
  ```lua
  CZ.Menu("menu",elements,function (menu,value)
    CZ.CloseMenu(menu.id)
    -- or
    menu.close()
  end,function (menu)
    	menu.close()
  end)
  ```
- ### GetNearestPlayer
  >return the player closest to you

  ***remember that it returns both the coordinates and the player id***

   ```lua
  local player,distance = CZ.GetNearestPlayer()
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

- ### GetPlayerFromId
  >returns all server player data

  ***look [here](#use-czplayer) to see how to use the CZPlayer object***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  id | `int` or `string` | player server id

  ```lua
  local CZPlayer = CZ.GetPlayerFromId(2)
  ```
- ### GetUniqueItem
  >this function returns the unique item id

  ***if the unique item does not exist it will return nil***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  uniqueid | `string` | the unique id to call the item

  ```lua
  local uniqueItem = CZ.GetUniqueItem("uniqueid")
  ```
- ### GetIdentifiers
  >this function returns all the identifiers of the player

  ***remember to specify the id of the player to take the identifiers, [info](#identifiers)***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  id | `string` or `int` | the id of the player to take the identifiers

  ```lua
  local identifiers = CZ.GetIdentifiers("id" || 2)
  ```
- ### GetItem
  >this function returns the item from the name

  ***remember that it will only return general item data not player specific data***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  name | `string` | the name of the item

  ```lua
  local item = CZ.GetItem("name")
  ``` 
- ### CreateUniqueItem
  >this function allows you to create a unique item

  ***remember that the function returns the unique item***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  callback | `function` | the callback that returns the unique item
  name | `string` | the name of the unique item
  label | `string` | the label of the unique item
  description | `string` | the description of unique the item
  weight | `int float` | the weight of unique the item
  other | `object` | an object that contains custom data
  owner | `string` | the license of the owner of the item

  ```lua
  CZ.CreateUniqueItem(function(uniqueItem)
    -- your code
  end,"name","label","description","weight","other","owner")
  ```
- ### EditUniqueItem
  >this function allows you to edit a unique item

  ***remember that the 'other' parameter must be an object or nil***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  uniqueid | `string` | the uniqueid of the unique item
  name | `string` | the name of the unique item
  label | `string` | the label of the unique item
  weight | `int float` | the weight of the unique item
  description | `string` | the description of the unique item
  other | `object` | an object that contains custom data

  ```lua
  CZ.EditUniqueItem("uniqueid","name","label","description","other")
  ```
- ### DeleteUniqueItem
  >this function allows you to delete a unique item

  ***remember that it returns 'true' if the item has been removed***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  uniqueid | `string` | the uniqueid of the unique item

  ```lua
  local deleted = CZ.DeleteUniqueItem("uniqueid")
  ```
- ### GetPlayerIdFromIdentifier
  >this function allows you to return the player id from the license

  ***remember if the player is not online it will return nil***
  Parameter | Type | Description
  ------------ | ------------- | -------------
  license | `string` | the rockstar license

  ```lua
  local playerid = CZ.GetPlayerIdFromIdentifier("identifier")
  ```

- ### Use CZPlayer
  >CZPlayer is the object that is returned by the function [GetPlayerFromId](#getplayerfromid)

  ***remember that CZPlayer contains all the server side data of the player***
  Variables | Type | Description
  ------------ | ------------- | -------------
  Identifiers | `object` | returns all player identifiers, [info](#identifiers)
  Id | `int` | return the player server id
  Name | `string` | return the player steam name
  Ped | `int` | return the player ped id
  Job | `object` | returns all information about the player's job, [info](#job)
  Inventory | `object` | returns all items in the inventory
  Permission | `string` | the name of player permissions
  AddMoney | `function(money,count)` | this function add money ,[info](#addmoney)
  RemoveMoney | `function(money,count)` | this function remove money ,[info](#removemoney)
  AddUniquepItem | `function(uniqueid)` | this function add a unique item to the player's inventory,[info](#adduniqueitem)
  RemoveUniqueItem | `function(uniqueid)` | this function remove a unique item in the player's inventory ,[info](#removeuniqueitem)
  AddItem | `function(name,count)` | this function add an item to the player's inventory, [info](#additem) 
  RemoveItem | `function(name,count)` | this function remove an item to the player's inventory, [info]() 
  GetItem | `function(name)` | this function returns the item from the name, [info](#getitem)

  - #### AddMoney
    >look [here](#use-czplayer) to learn more

    Parameter | Type | Description
    ------------ | ------------- | -------------
    money | `string` | money account name, **money, bankmoney, dirtymoney**
    count | `int` | the count to be added

    ```lua
    local added = CZPlayer.AddMoney("money",1000)
    ```
  - #### RemoveMoney
    >look [here](#use-czplayer) to learn more

    Parameter | Type | Description
    ------------ | ------------- | -------------
    money | `string` | money account name, **money, bankmoney, dirtymoney**
    count | `int` | the count to be removed

    ```lua
    local removed = CZPlayer.RemoveMoney("money",1000)
    ``` 
  - #### AddUniqueItem
    >look [here](#use-czplayer) to learn more

    Parameter | Type | Description
    ------------ | ------------- | -------------
    uniqueid | `string` | the unique id to call the item

    ```lua
    local notExist = CZPlayer.AddUniqueItem("uniqueid")
    ``` 
  - #### RemoveUniqueItem
    >look [here](#use-czplayer) to learn more

    Parameter | Type | Description
    ------------ | ------------- | -------------
    uniqueid | `string` | the unique id to call the item

    ```lua
    local exist = CZPlayer.RemoveUniqueItem("uniqueid")
    ``` 
  - #### AddItem
    >look [here](#use-czplayer) to learn more

    Parameter | Type | Description
    ------------ | ------------- | -------------
    name | `string` | the name of the item
    count | `string` | the count to be added

    ```lua
    local added = CZPlayer.AddItem("name",10)
    ``` 
  - #### RemoveItem

    >look [here](#use-czplayer) to learn more

    Parameter | Type | Description
    ------------ | ------------- | -------------
    name | `string` | the name of the item
    count | `string` | the count to be removed

    ```lua
    local removed = CZPlayer.RemoveItem("name",10)
    ``` 
  - #### GetItem

    >look [here](#use-czplayer) to learn more

    Parameter | Type | Description
    ------------ | ------------- | -------------
    name | `string` | the name of the item

    ```lua
    local item = CZPlayer.GetItem("name")
    ``` 
    

## Global

- ### Print
  >this function allows you to print objects or simple variables in the console in a more comfortable way to read

  ***remember that you can only print one object or variable at a time***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  data | `all` | the object or variable to print

  ```lua
  local object = {dog = "bau"}
  local dog = "bau"

  CZ.Print(object)
  CZ.Print(dog)
  ```
- ### DuplicateObject
  >this function returns a duplicate of the passed object

  ***remember this function only duplicates objects no arrays or variables***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  object | `object` | the object to duplicate

  ```lua
  local object = {dog = "bau"}

  local duplicateObject = CZ.DuplicateObject(object)
  ```
- ### Try
  >this function is for try a function and if get error catch it and trigger callback else execute the function

  ***this is a try and catch beta systema in lua***

  Parameter | Type | Description
  ------------ | ------------- | -------------
  try | `function` | the function to be tested
  catch | `function(error)` | the function that catches the error and returns it

  ```lua
  function test()
    local c = dog -- dog is not defined
  end

  CZ.Try(test,function(error)
    if error then
      print(error)
    end
  end)
  ```
