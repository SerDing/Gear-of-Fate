# Modular Finite State Machine

## Abstract transitions
 
### 1.input check
Attack:
- skill key pressed --> skill state

### 2.animation playover
* Attack
* FrenzyAttack
* UpperSlash
    
### 3.movement finished
* TripleSlash: vx == 0 --> Stay

* Jump: pos.z >= 0 --> Stay

## how to abstract transitions?
abstract conditions as message then dispatch it to states, FSM will have a transition table and do the right transition by message in the method Transition
    
PlayerController --> message --> currentState --> Transition(event) --> FSM.SetState(stateName)

FSM:
```lua
    local _FSM = Class()
    
    -- transitions is a tree, first layer is msg, second layer is source state, third layer is dest state
    self.transitions = {
        ["x_pressed"] = {
            ["stay"] = "attack",
        },
    }
    
    function _FSM:Transition(action)
        if not self.transitions[action] then -- no message pool
            return 
        end
        if not self.transitions[action][self.curState.name] then -- not found specified transition
            return
        end
        self:SetState(self.transitions[action][self.curState.name])
    end
```

PlayerController:
```lua
    local _FSM = require("Src.Engine.FSM.FSM")
    local _PlayerContorller = Class(_FSM)
    
    function _PlayerContorller:SetEntity(entity)
        if self.entity then
            self.input.onActionPressed:DelListener(self, self.Transition)
        end
        
        self.entity = entity
        self.input = entity:GetComponent("Input")
        self.input.onActionPressed:AddListener(self, self.Transition)
    end
```

PlayerController(FSM for hero) extends FSM  
InputCompnent convert hardware input messages to game internal logic words(msgs) like "jump_pressed"