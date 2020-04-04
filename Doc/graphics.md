# Graphics System Reconstruction

## Architecture

## Sprite
### Data structure
* SpriteData = {image, path, ox, oy, sx, sy, angle, color, blendmode, shader}

## Animation 
### Feature
* Play by anim data directly.
* One data for multiple animation instance.

### Data structure
* AnimConfig = {isLoop, frames = {sprite = "1", time = 100}}
* AnimData = {path, isLoop, frames = {spriteData}}

## Avatar
### Feature
* multiple animation parts
* drawing order
* 

### Data structure
Avatar = {
    path, 
    parts = {
        body = {path, order},
    },
}