# Player Controller

## 1.Definition
   
controller implements controlling logic for player entity like move、dash、attack, 
definitely, all of them are states that receive player input messages to generate output or change state. 
    
## 2.Demo 

```lua
    local _PlayerController = require("Engine.Core.Class")()
    
    function _PlayerController:SetPlayer(playerEntity)
        self.entity = playerEntity
        for _, s in pairs(self.states) do
            s.entity = playerEntity
        end
    end
```